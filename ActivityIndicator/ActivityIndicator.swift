//
//  ActivityIndicator.swift
//  TestProject
//
//  Created by Chris Combs on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit

/** 
	Protocol for any view that can be used as an Activity Indicator. Currently only has one dismiss
	method, because the 'showInView' methods need to be custom for each class
*/

public protocol ActivityIndicator {
	/**
		Dismiss the ActivityIndicator. Implementations should remove
		any views from their superview and restore UIButton.titleLabel.alpha
		to 1, if applicable
	*/
	func dismiss()
}

/// An Activity Indicator view, named as such because ActivityIndicatorView is a pain to type
public class Spinner: NSObject {
	
	//TODO: Add an option to offset the indicator in the view or button
	
	/**
		To display the indicator centered in a view.
	
		- Parameters:
			- view: The view to display the indicator in
			- style: A constant that specifies the style of the object to be created
		
		- Returns: A reference to the ActivityIndicator that was created, so that it can be dismissed as needed
	*/
	public static func showSpinnerInView(view: UIView, style: UIActivityIndicatorViewStyle = .White) -> ActivityIndicator {
		let center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2)
		let spinner = UIActivityIndicatorView(activityIndicatorStyle: style)
		spinner.center = center
		spinner.startAnimating()
		view.addSubview(spinner)
		return spinner
	}
	
	/**
		To display the indicator centered in a button. The button's titleLabel will be hidden while the indicator is shown.
	
		- Parameters:
			- button: The button to display the indicator in
			- style: A constant that specifies the style of the object to be created
	
		- Returns: A reference to the ActivityIndicator that was created, so that it can be dismissed as needed
	*/
	public static func showSpinnerInButton(button: UIButton, style: UIActivityIndicatorViewStyle = .White) -> ActivityIndicator {
		button.titleLabel?.alpha = 0.0
		return showSpinnerInView(button, style: style)
	}
}

/// Extension of Spinner that supports an animated UIImageView as a custom activity indicator
public extension Spinner {
	
	/**
		Used to create the custom indicator. Call this once (on app open, for example) and it
		will be set for the lifetime of the app. 
	
		- Note:	Currently only supports one custom indicator. If you need multiple custom activity
			indicators, you are probably better off creating something custom.
	
		- Parameters:
			- images: An array containing the UIImages to use for the animation
			- duration: The animation duration
	*/
	public static func setCustomImages(images: [UIImage], duration: NSTimeInterval) {
		let image = UIImageView(frame: CGRectMake(0, 0, images[0].size.width, images[0].size.height))
		image.animationImages = images
		image.animationDuration = duration
		animationImage = image
	}
	/// Reference to the UIImageView to use for the indicator created by setCustomImages
	private static var animationImage: UIImageView?
	
	/**
		To display the indicator centered in a view.
	
		- Note: If the animationImage has not been created (via setCustomImages), 
				it will default to the normal UIActivityIndicatorView and will not use
				a custom UIImageView.
	
		- Parameters:
			- view: The view to display the indicator in
	
		- Returns: A reference to the ActivityIndicator that was created, so that it can be dismissed as needed
	*/
	public static func showCustomSpinnerInView(view: UIView) -> ActivityIndicator {
		if let image = animationImage {
			let spinner = UIImageView(frame: view.bounds)
			spinner.contentMode = .Center
			spinner.animationDuration = image.animationDuration
			spinner.animationImages = image.animationImages
			spinner.startAnimating()
			view.addSubview(spinner)
			return spinner
		}
		else {
			return showSpinnerInView(view)
		}
	}
	
	/**
		To display the indicator centered in a button. The button's titleLabel will be hidden while the indicator is shown.
	
		- Parameters:
			- button: The button to display the indicator in
	
		- Returns: A reference to the ActivityIndicator that was created, so that it can be dismissed as needed
	*/
	public static func showCustomSpinnerInButton(button: UIButton) -> ActivityIndicator {
		button.titleLabel?.alpha = 0.0
		return showCustomSpinnerInView(button)
	}
}

/// Extension to allow UIActivityIndicatorView to be dismissed
extension UIActivityIndicatorView: ActivityIndicator {
	
	/// Called when the activity indicator should be removed. If shown on a button, it restores the titleLabel
	public func dismiss() {
		stopAnimating()
		if let superview = superview as? UIButton {
			superview.titleLabel?.alpha = 1.0
		}
		removeFromSuperview()
	}
}

/// Extension to allow UIImageView to be dismissed
extension UIImageView: ActivityIndicator {
	/// Called when the activity indicator should be removed. If shown on a button, it restores the titleLabel
	public func dismiss() {
		stopAnimating()
		if let superview = superview as? UIButton {
			superview.titleLabel?.alpha = 1.0
		}
		removeFromSuperview()
	}
}
