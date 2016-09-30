//
//  Spinner.swift
//  TestProject
//
//  Created by Chris Combs on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit

public typealias ControlTitleColor = (UIControlState, UIColor?)

/**
	Protocol for any view that can be used as a Spinner. Currently only has one dismiss
	method, because the 'showInView' methods need to be custom for each class
 */
public protocol Spinner {
    
    /**
     Dismiss the Spinner. Implementations should remove any views from their superview.
     
     - Parameter enablesUserInteraction: A boolean that specifies if the user interaction on the view should be enabled when the spinner is dismissed
     */
    func dismiss()
}

public class SpinnerView: NSObject, Spinner {

    //TODO: Add an option to offset the indicator in the view or button

    fileprivate var controlTitleColors: [ControlTitleColor]?
    fileprivate var spinner: UIActivityIndicatorView?
    fileprivate var imageView: UIImageView?
    fileprivate var userInteractionEnabledAtReception = true

    /**
     To display the indicator centered in a view.

     - Parameter view: The view to display the indicator in.
     - Parameter style: A constant that specifies the style of the object to be created.
     - Parameter color: A UIColor that specifies the tint of the spinner
     - Parameter disablesUserInteraction: A boolean that specifies if the user interaction on the view should be disabled while the spinner is shown. Default is true
     
     - Returns: A reference to the Spinner that was created, so that it can be dismissed as needed.
     */

    public static func showSpinner(inView view: UIView, style: UIActivityIndicatorViewStyle = .white, color:UIColor? = nil, disablesUserInteraction: Bool = true) -> Spinner {
        let center      = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)

        let spinner     = UIActivityIndicatorView(activityIndicatorStyle: style)
        
        let spinnerView = SpinnerView()
        spinnerView.userInteractionEnabledAtReception = view.isUserInteractionEnabled
        
        if disablesUserInteraction {
            spinner.frame = view.frame
            spinner.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).cgColor
            view.isUserInteractionEnabled = false
        }
        spinner.color = color
        spinner.center = center
        spinner.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        spinner.startAnimating()
        view.addSubview(spinner)
        spinnerView.spinner = spinner
        
        return spinnerView
    }
    
    /**
     To display the indicator centered in a button.
     The button's titleLabel colors will be set to clear color while the indicator is shown.
     
     - Parameter button: The button to display the indicator in.
     - Parameter style: A constant that specifies the style of the object to be created.
     - Parameter color: A UIColor that specifies the tint of the spinner
     - Parameter disablesUserInteraction: A boolean that specifies if the user interaction on the button should be disabled while the spinner is shown. Default is true
     
     - Returns: A reference to the Spinner that was created, so that it can be dismissed as needed.
     */
    public static func showSpinner(inButton button: UIButton, style: UIActivityIndicatorViewStyle = .white, color:UIColor? = nil, disablesUserInteraction:Bool = true) -> Spinner {
        
        let view = showSpinner(inView: button, style: style, color: color)
        
        if let spinnerView = view as? SpinnerView {
            spinnerView.userInteractionEnabledAtReception = button.isUserInteractionEnabled
            spinnerView.controlTitleColors = button.allTitleColors()
            button.removeAllTitleColors()
        }
        if disablesUserInteraction {
            button.isUserInteractionEnabled = false
        }
    
        return view
    }

    public func dismiss() {
        
        if let superView = spinner?.superview {
            superView.isUserInteractionEnabled = self.userInteractionEnabledAtReception
            if let button = superView as? UIButton {
                button.restore(titleColors: controlTitleColors)
            }
            
        }
        spinner?.dismiss()
        imageView?.dismiss()
    }
}

// Extension of SpinnerView that supports an animated UIImageView as a custom activity indicator
public extension SpinnerView {

    // Private reference to a proxy UIImageView holding images for use in custom spinner.
    private static var animationImage: UIImageView?

    /**
     Used to create the custom indicator. Call this once (on app open, for example) and it
     will be set for the lifetime of the app.

     - Note:	Currently only supports one custom indicator. If you need multiple custom activity
     indicators, you are probably better off creating something custom.

     - Parameter images: An array containing the UIImages to use for the animation.
     - Parameter duration: The animation duration.
     */
    public static func set(customImages images: [UIImage], duration: TimeInterval) {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: images[0].size.width, height: images[0].size.height))
        image.animationImages = images
        image.animationDuration = duration
        animationImage = image
    }

    /**
     To display the indicator centered in a view.

     - Note: If the `animationImage` has not been created via `setCustomImages(_:duration:)`,
     it will default to the normal `UIActivityIndicatorView` and will not use
     a custom `UIImageView`.

     - Parameter view: The view to display the indicator in.

     - Returns: A reference to the `Spinner` that was created, so that it can be dismissed as needed.
     */
    public static func showCustomSpinner(inView view: UIView) -> Spinner {
        if let image = animationImage {
            let imageView = UIImageView(frame: view.bounds)
            imageView.contentMode = .center
            imageView.animationDuration = image.animationDuration
            imageView.animationImages = image.animationImages
            imageView.startAnimating()
            view.addSubview(imageView)

            let spinnerView = SpinnerView()
            spinnerView.imageView = imageView
            return spinnerView
        }
        else {
            return showSpinner(inView: view)
        }
    }

    /**
     To display the indicator centered in a button. 
     The button's titleLabel colors will be set to clear color while the indicator is shown.

     - Parameter button: The button to display the indicator in.

     - Returns: A reference to the ActivityIndicator that was created, so that it can be dismissed as needed
     */
    public static func showCustomSpinner(inButton button: UIButton, disablesUserInteraction:Bool = true) -> Spinner {
        let view = showCustomSpinner(inView: button)
        button.isUserInteractionEnabled = !disablesUserInteraction
        if let spinnerView = view as? SpinnerView {
            spinnerView.controlTitleColors = button.allTitleColors()
            button.removeAllTitleColors()
        }

        return view
    }
}

// MARK: - Spinner Conformance -

// Extension to allow UIActivityIndicatorView to be dismissed.
extension UIActivityIndicatorView: Spinner {

    // Called when the activity indicator should be removed.
    public func dismiss() {
        stopAnimating()
        removeFromSuperview()
    }
}

// Extension to allow UIImageView to be dismissed
extension UIImageView: Spinner {

    // Called when the activity indicator should be removed.
    public func dismiss() {
        stopAnimating()
        removeFromSuperview()
    }
}

// MARK: - Private -

fileprivate extension UIButton {

    fileprivate func allTitleColors() -> [ControlTitleColor] {
        var colors: [ControlTitleColor] = [
            (UIControlState(), titleColor(for: UIControlState())),
            (.highlighted, titleColor(for: .highlighted)),
            (.disabled, titleColor(for: .disabled)),
            (.selected, titleColor(for: .selected)),
            (.application, titleColor(for: .application)),
            (.reserved, titleColor(for: .reserved))
        ]

        if #available(iOS 9.0, *) {
            colors.append((.focused, titleColor(for: .focused)))
        }

        return colors
    }

    fileprivate func restore(titleColors colors: [ControlTitleColor]?) {
        guard let colors = colors else { return }
        for color in colors {
            setTitleColor(color.1, for: color.0)
        }
    }

    fileprivate func removeAllTitleColors() {
        restore(titleColors: allTitleColors().map({ return ($0.0, UIColor.clear) }))
    }
}
