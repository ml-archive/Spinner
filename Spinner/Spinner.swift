//
//  Spinner.swift
//  TestProject
//
//  Created by Chris Combs on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

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

public class SpinnerView: UIActivityIndicatorView {
    
    // MARK: - Static Properties
    
    // Private reference to a proxy UIImageView holding images for use in custom spinner.
    private static var animationImage: UIImageView?
    
    // MARK: - Properties
    
    private var controlTitleColors: [ControlTitleColor]?
    private var controlTitleAttributes: [ControlTitleAttributes]?
    private var imageView: UIImageView?
    private var userInteractionEnabledAtReception = true
    private var dimView: UIView?
    
    // MARK: - Init
    
    public init(style: UIActivityIndicatorViewStyle = .white, color: UIColor? = nil) {
        super.init(activityIndicatorStyle: style)
        self.color = color
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Show

extension SpinnerView {
    
    /// To display the indicator centered in a view.
    ///
    /// - parameter view: The view to display the indicator in.
    /// - parameter style: A constant that specifies the style of the object to be created.
    /// - parameter color: A UIColor that specifies the tint of the spinner
    /// - parameter disablesUserInteraction: A boolean that specifies if the user interaction on the view should be disabled while the spinner is shown. Default is true
    /// - parameter dimBackground: A Boolean specifying if background should be dimmed while showing spinner. Default is false
    /// - returns: A reference to the Spinner that was created, so that it can be dismissed as needed.
    public func show(in view: UIView, dimBackground: Bool = false, disablesUserInteraction: Bool = true) {
        dismiss()
        
        // User interaction
        userInteractionEnabledAtReception = view.isUserInteractionEnabled
        
        if disablesUserInteraction {
            frame = view.frame
            view.isUserInteractionEnabled = false
        }
        
        // Set position
        let center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        self.center = center
        autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        // Start animation
        startAnimating()
        
        // Add to view
        view.addSubview(self)
        
        // Check if backgrounds needs to be dimmed
        if dimBackground {
            dimView = UIView(frame: view.bounds)
            dimView?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            dimView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(dimView!, belowSubview: self)
        }
    }
    
    /// To display the indicator centered in a button. The button's titleLabel colors will be set to clear color while the indicator is shown.
    ///
    /// - parameter button: The button to display the indicator in.
    /// - parameter style: A constant that specifies the style of the object to be created.
    /// - parameter color: A UIColor that specifies the tint of the spinner
    /// - parameter disablesUserInteraction: A boolean that specifies if the user interaction on the button should be disabled while the spinner is shown. Default is true
    /// - returns: A reference to the Spinner that was created, so that it can be dismissed as needed.
    public func show(in button: UIButton, disablesUserInteraction: Bool = true) {
        show(in: button, dimBackground: false, disablesUserInteraction: disablesUserInteraction)
        controlTitleColors = button.allTitleColors
        button.removeAllTitleColors()
        controlTitleAttributes = button.allTitleAttributes
        button.removeAllAttributedStrings()
        
        guard disablesUserInteraction else { return }
        button.isUserInteractionEnabled = false
    }
}

// MARK: - Show Custom

extension SpinnerView {
    
    //// To display the indicator centered in a view.
    ///
    /// - Note: If the `animationImage` has not been created via `setCustomImages(_:duration:)`, it will default to the normal `UIActivityIndicatorView` and will not use a custom `UIImageView`.
    ///
    /// - parameter view: The view to display the indicator in.
    /// - parameter dimBackground: A Boolean specifying if background should be dimmed while showing spinner. Default is false.
    /// - returns: A reference to the `Spinner` that was created, so that it can be dismissed as needed.
    public func showCustom(in view: UIView, dimBackground: Bool = false) {
        guard let image = SpinnerView.animationImage else {
            show(in: view)
            return
        }
        
        //In case the previous spinner wasn't dismissed
        dismiss()
        
        // Create image view
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .center
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        imageView.animationDuration = image.animationDuration
        imageView.animationImages = image.animationImages
        imageView.startAnimating()
        view.addSubview(imageView)
        
        self.imageView = imageView
        
        // Check if background needs to be dimmed
        guard dimBackground else { return }
        dimView = UIView(frame: view.bounds)
        dimView?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        dimView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(dimView!, belowSubview: imageView)
    }
    
    /// To display the indicator centered in a button. The button's titleLabel colors will be set to clear color while the indicator is shown.
    ///
    /// - parameter button: The button to display the indicator in.
    /// - returns: A reference to the ActivityIndicator that was created, so that it can be dismissed as needed.
    public func showCustom(in button: UIButton, disablesUserInteraction: Bool = true) {
        showCustom(in: button)
        button.isUserInteractionEnabled = !disablesUserInteraction
        controlTitleColors = button.allTitleColors
        button.removeAllTitleColors()
        controlTitleAttributes = button.allTitleAttributes
        button.removeAllAttributedStrings()
    }
}

// MARK: - Dismiss

extension SpinnerView: Spinner {
    
    /// To dismiss the currently displayed indicator. The views interaction will then be enabled depending on the parameter boolean
    /// If shown in a button the titles text will become visible
    public func dismiss() {
        if let superView = superview {
            superView.isUserInteractionEnabled = self.userInteractionEnabledAtReception
            let button = superView as? UIButton
            button?.restore(titleColors: controlTitleColors, attributedStrings: controlTitleAttributes)
        }
        else if let superView = imageView?.superview {
            superView.isUserInteractionEnabled = self.userInteractionEnabledAtReception
            let button = superView as? UIButton
            button?.restore(titleColors: controlTitleColors, attributedStrings: controlTitleAttributes)
        }
        
        stopAnimating()
        removeFromSuperview()
        imageView?.dismiss()
        dimView?.removeFromSuperview()
    }
}

// MARK: - Setup Custom

// Extension of SpinnerView that supports an animated UIImageView as a custom activity indicator
public extension SpinnerView  {
    
    /**
     Used to create the custom indicator. Call this once (on app open, for example) and it
     will be set for the lifetime of the app.
     
     - Note:    Currently only supports one custom indicator. If you need multiple custom activity
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
}

// MARK: - UI Image View Extension

// Extension to allow UIImageView to be dismissed
extension UIImageView: Spinner {

    // Called when the activity indicator should be removed.
    public func dismiss() {
        stopAnimating()
        removeFromSuperview()
    }
}

// MARK: - UI Button Extension

private extension UIButton {
    
    // Extension to return an array of every color for every button state
    var allTitleColors: [ControlTitleColor] {
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
    
    // Extension to return an array of title attributes for every button state
    var allTitleAttributes: [ControlTitleAttributes] {
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
    
    /// Function to set the buttons title colors to specific button states passed in the array parameter
    ///
    /// - parameter colors: An array of ControlTitleColor each containing a UIControlState and a UIColor
    func restore(titleColors colors: [ControlTitleColor]?, attributedStrings: [ControlTitleAttributes]?) {
        if let colors = colors {
            colors.forEach {
                guard titleColor(for: $0.0) == .clear else { return }
                setTitleColor($0.1, for: $0.0)
            }
        }
        
        if let attributedStrings = attributedStrings {
            attributedStrings.forEach {
                setAttributedTitle($0.1, for: $0.0)
            }
        }
    }
    
    /// Sets all the the buttons title colors to clear
    func removeAllTitleColors() {
        let clearedColors = allTitleColors.map({ return ($0.0, UIColor.clear) })
        clearedColors.forEach {
            setTitleColor($0.1, for: $0.0)
        }
    }
    
    /// Remove all attributed strings
    func removeAllAttributedStrings() {
        setAttributedTitle(nil, for: .normal)
        setAttributedTitle(nil, for: .highlighted)
        setAttributedTitle(nil, for: .disabled)
        setAttributedTitle(nil, for: .selected)
        setAttributedTitle(nil, for: .application)
        setAttributedTitle(nil, for: .reserved)
        
        guard #available(iOS 9.0, *) else { return }
        setAttributedTitle(nil, for: .focused)
    }
}

// MARK: - Deprecated

extension SpinnerView {
    /**
     To display the indicator centered in a view.
     
     - Parameter view: The view to display the indicator in.
     - Parameter style: A constant that specifies the style of the object to be created.
     - Parameter color: A UIColor that specifies the tint of the spinner
     - Parameter disablesUserInteraction: A boolean that specifies if the user interaction on the view should be disabled while the spinner is shown. Default is true
     - Parameter dimBackground: A Boolean specifying if background should be dimmed while showing spinner. Default is false
     
     - Returns: A reference to the Spinner that was created, so that it can be dismissed as needed.
     */
    @available(*, deprecated, message: "This method is deprecated and will be removed in a future release, please use the new show instance method")
    public static func showSpinner(inView view: UIView, style: UIActivityIndicatorViewStyle = .white, color: UIColor? = nil, disablesUserInteraction: Bool = true, dimBackground: Bool = false) -> SpinnerView {
        let center      = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        
        
        let activityIndicator     = UIActivityIndicatorView(activityIndicatorStyle: style)
        
        let spinnerView = SpinnerView(style: style)
        spinnerView.userInteractionEnabledAtReception = view.isUserInteractionEnabled
        
        //In case the previous spinner wasn't dismissed
        if let oldSpinner = view.subviews.filter({ $0 is SpinnerView }).first as? SpinnerView {
            
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
    @available(*, deprecated, message: "This method is deprecated and will be removed in a future release, please use the new show instance method")
    public static func showSpinner(inButton button: UIButton, style: UIActivityIndicatorViewStyle = .white, color:UIColor? = nil, disablesUserInteraction:Bool = true) -> SpinnerView {
        
        let spinnerView = showSpinner(inView: button, style: style, color: color)
        spinnerView.controlTitleColors = button.allTitleColors
        button.removeAllTitleColors()
        spinnerView.controlTitleAttributes = button.allTitleAttributes
        button.removeAllAttributedStrings()
        
        if disablesUserInteraction {
            button.isUserInteractionEnabled = false
        }
        
        return spinnerView
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
    @available(*, deprecated, message: "This method is deprecated and will be removed in a future release, please use the new showCustom instance method")
    public static func showCustomSpinner(inView view: UIView, dimBackground: Bool = false) -> SpinnerView {
        if let image = SpinnerView.animationImage {
            
            //In case the previous spinner wasn't dismissed
            if let oldSpinner = view.subviews.filter({ $0 is SpinnerView }).first as? SpinnerView {
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
    @available(*, deprecated, message: "This method is deprecated and will be removed in a future release, please use the new showCustom instance method")
    public static func showCustomSpinner(inButton button: UIButton, disablesUserInteraction:Bool = true) -> SpinnerView {
        let spinnerView = showCustomSpinner(inView: button)
        button.isUserInteractionEnabled = !disablesUserInteraction
        spinnerView.controlTitleColors = button.allTitleColors
        button.removeAllTitleColors()
        spinnerView.controlTitleAttributes = button.allTitleAttributes
        button.removeAllAttributedStrings()
        return spinnerView
    }
}
