//
//  Spinner.swift
//  TestProject
//
//  Created by Chris Combs on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

/*
import UIKit

public typealias ControlTitleColor = (UIControlState, UIColor?)
public typealias ControlTitleAttributes = (UIControlState, NSAttributedString?)

/**
	Protocol for any view that can be used as a Spinner. Currently only has one dismiss
	method, because the 'showInView' methods need to be custom for each class
 */
public protocol Spinner {
    
    /**
     Dismiss the Spinner. Implementations should remove any views from their superview.
     */
    func dismiss() 
}

public class SpinnerView: NSObject, Spinner {
    
    //TODO: Add an option to offset the indicator in the view or button
    
    private var controlTitleColors: [ControlTitleColor]?
    private var controlTitleAttributes: [ControlTitleAttributes]?
    private var activityIndicator: UIActivityIndicatorView?
    private var imageView: UIImageView?
    private var userInteractionEnabledAtReception = true
    private var dimView: UIView?
    
    /**
     To display the indicator centered in a view.
     
     - Parameter view: The view to display the indicator in.
     - Parameter style: A constant that specifies the style of the object to be created.
     - Parameter color: A UIColor that specifies the tint of the spinner
     - Parameter disablesUserInteraction: A boolean that specifies if the user interaction on the view should be disabled while the spinner is shown. Default is true
     - Parameter dimBackground: A Boolean specifying if background should be dimmed while showing spinner. Default is false
     
     - Returns: A reference to the Spinner that was created, so that it can be dismissed as needed.
     */
    
    public static func showSpinner(inView view: UIView, style: UIActivityIndicatorViewStyle = .white, color:UIColor? = nil, disablesUserInteraction: Bool = true, dimBackground: Bool = false) -> SpinnerView {
        let center      = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        
        
        let activityIndicator     = UIActivityIndicatorView(activityIndicatorStyle: style)
        
        let spinnerView = SpinnerView()
        spinnerView.userInteractionEnabledAtReception = view.isUserInteractionEnabled
        
        //In case the previous spinner wasn't dismissed
        if let oldSpinner = view.subviews.filter({ $0 is Spinner }).first as? Spinner {
            
            spinnerView.userInteractionEnabledAtReception = true //We will need to assume userinteraction should be restored as we do not have access to the original SpinnerView
            oldSpinner.dismiss()
        }
        
        if disablesUserInteraction {
            activityIndicator.frame = view.frame
            view.isUserInteractionEnabled = false
        }
       
        activityIndicator.color = color
        activityIndicator.center = center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        if dimBackground {
            spinnerView.dimView = UIView(frame: view.bounds)
            if let dimView = spinnerView.dimView {
                dimView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
                dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.insertSubview(dimView, belowSubview: activityIndicator)
            }
        }
        spinnerView.activityIndicator = activityIndicator
        
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
    public static func showSpinner(inButton button: UIButton, style: UIActivityIndicatorViewStyle = .white, color:UIColor? = nil, disablesUserInteraction:Bool = true) -> SpinnerView {
        
        let spinnerView = showSpinner(inView: button, style: style, color: color)
        spinnerView.controlTitleColors = button.allTitleColors()
        button.removeAllTitleColors()
        spinnerView.controlTitleAttributes = button.allTitleAttributes()
        button.removeAllAttributedStrings()
        
        if disablesUserInteraction {
            button.isUserInteractionEnabled = false
        }
        
        return spinnerView
    }
    
    /**
     To dismiss the currently displayed indicator.
     The views interaction will then be enabled depending on the parameter boolean
     If shown in a button the titles text will become visible
     */
    public func dismiss() {
        
        if let superView = activityIndicator?.superview {
            superView.isUserInteractionEnabled = self.userInteractionEnabledAtReception
            if let button = superView as? UIButton {
                button.restore(titleColors: controlTitleColors, attributedStrings: controlTitleAttributes)
            }
        }
        else if let superView = imageView?.superview {
            superView.isUserInteractionEnabled = self.userInteractionEnabledAtReception
            if let button = superView as? UIButton {
                button.restore(titleColors: controlTitleColors, attributedStrings: controlTitleAttributes)
            }
        }
        
        activityIndicator?.dismiss()
        imageView?.dismiss()
        dimView?.removeFromSuperview()
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
     - Parameter dimBackground: A Boolean specifying if background should be dimmed while showing spinner. Default is false
     
     - Returns: A reference to the `Spinner` that was created, so that it can be dismissed as needed.
     */
    public static func showCustomSpinner(inView view: UIView, dimBackground: Bool = false) -> SpinnerView {
        if let image = animationImage {
            
            //In case the previous spinner wasn't dismissed
            if let oldSpinner = view.subviews.filter({ $0 is Spinner }).first as? Spinner {
                oldSpinner.dismiss()
            }
            
            let imageView = UIImageView(frame: view.bounds)
            imageView.contentMode = .center
            imageView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            imageView.animationDuration = image.animationDuration
            imageView.animationImages = image.animationImages
            imageView.startAnimating()
            view.addSubview(imageView)
            
            let spinnerView = SpinnerView()
            spinnerView.imageView = imageView
            if dimBackground {
                spinnerView.dimView = UIView(frame: view.bounds)
                if let dimView = spinnerView.dimView {
                    dimView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
                    dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view.insertSubview(dimView, belowSubview: imageView)
                }
            }

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
    public static func showCustomSpinner(inButton button: UIButton, disablesUserInteraction:Bool = true) -> SpinnerView {
        let spinnerView = showCustomSpinner(inView: button)
        button.isUserInteractionEnabled = !disablesUserInteraction
        spinnerView.controlTitleColors = button.allTitleColors()
        button.removeAllTitleColors()
        spinnerView.controlTitleAttributes = button.allTitleAttributes()
        button.removeAllAttributedStrings()
        return spinnerView
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

private extension UIButton {
    
    // Extension to return an array of every color for every button state
    func allTitleColors() -> [ControlTitleColor] {
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
    
    func allTitleAttributes() -> [ControlTitleAttributes] {
        var attributes: [ControlTitleAttributes] = [
            (UIControlState(), attributedTitle(for: UIControlState())),
            (.highlighted, attributedTitle(for: .highlighted)),
            (.disabled, attributedTitle(for: .disabled)),
            (.selected, attributedTitle(for: .selected)),
            (.application, attributedTitle(for: .application)),
            (.reserved, attributedTitle(for: .reserved))
        ]
        
        if #available(iOS 9.0, *) {
            attributes.append((.focused, attributedTitle(for: .focused)))
        }
        
        return attributes
    }
    
    /**
     Function to set the buttons title colors to specific button states passed in the array parameter
     
     - Parameter colors: An array of ControlTitleColor each containing a UIControlState and a UIColor
     */
    func restore(titleColors colors: [ControlTitleColor]?, attributedStrings: [ControlTitleAttributes]?) {
        if colors != nil {
            for color in colors! {
                if titleColor(for: color.0) == .clear {
                    setTitleColor(color.1, for: color.0)
                }
            }
        }
        
        if attributedStrings != nil {
            for string in attributedStrings! {
                self.setAttributedTitle(string.1, for: string.0)
            }
        }
    }
    
    /**
     Sets all the the buttons title colors to clear
     */
    func removeAllTitleColors() {
        let clearedColors = allTitleColors().map({ return ($0.0, UIColor.clear) })
        for color in clearedColors {
            setTitleColor(color.1, for: color.0)
        }
    }
    
    func removeAllAttributedStrings() {
        self.setAttributedTitle(nil, for: .normal)
        self.setAttributedTitle(nil, for: .highlighted)
        self.setAttributedTitle(nil, for: .disabled)
        self.setAttributedTitle(nil, for: .selected)
        self.setAttributedTitle(nil, for: .application)
        self.setAttributedTitle(nil, for: .reserved)
        
        if #available(iOS 9.0, *) {
            self.setAttributedTitle(nil, for: .focused)
        }
    }
}
*/
