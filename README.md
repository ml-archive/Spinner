# Spinner
> Present loading indicators anywhere quickly and easily

[![Travis](https://travis-ci.org/nodes-ios/Spinner.svg?branch=master)](https://travis-ci.org/nodes-ios/Spinner)
[![Codecov](https://img.shields.io/codecov/c/github/nodes-ios/Spinner.svg)](https://codecov.io/github/nodes-ios/Spinner)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Plaform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Spinner/blob/master/LICENSE)

A helpful loading spinner tool allowing you to present a UIActivityIndicator view directly in to views and buttons.

## 📝 Requirements

* iOS 9.0+
* Swift 4.0+  
*(Swift 2.2 & Swift 2.3 & Swift 3 supported in older versions)*

## 📦 Installation

### Carthage
~~~
github "nodes-ios/Spinner" ~> 2.0
~~~

> Last versions compatible with lower Swift versions:  
>
> **Swift 3**  
> `github "nodes-ios/Spinner" ~> 1.2`
>
> **Swift 2.3**  
> `github "nodes-ios/Spinner" == 0.2.5`
>
> **Swift 2.2**  
> `github "nodes-ios/Spinner" == 0.2.4`

## 💻 Usage

### Standard spinner
Easily present spinners in views like so:

```swift
let spinner = SpinnerView.showSpinner(inView: view)
```

Spinner also gives you the option to customise the UIActivityIndicator Style, color and whether it should disable user interaction of the passed view. These optional parameters will be set as the following if not set.

```swift
public static func showSpinner(inView view: UIView, style: UIActivityIndicatorViewStyle = .white, color:UIColor? = nil, disablesUserInteraction: Bool = true, dimBackground: Bool = false) -> SpinnerView
```

Example of adding it to a view.

```swift
let spinner = SpinnerView.showSpinner(inView: view, style: UIActivityIndicatorViewStyle.white, color: UIColor.red, disablesUserInteraction: false, dimBackground: true)
```

To remove the spinner from your view simply call dismiss.

```swift
spinner.dismiss()
```

### Custom spinner
If you would rather use something more custom than the UIActivityIndicator, you can set an array of images to the Spinner with a duration time it takes to animate through them and display it in a view.

```swift
public static func set(customImages images: [UIImage], duration: TimeInterval)

public static func showCustomSpinner(inView view: UIView, dimBackground: Bool = false) -> SpinnerView
```

### Buttons
You can also display the spinner in buttons, simply add the spinner to any UIButton and the spinner will hide the title in the button and display the spinner in the centre of the button. Once the spinner is dismissed, the title will be made visible once more.

```swift
public static func showCustomSpinner(inButton button: UIButton, disablesUserInteraction:Bool = true) -> SpinnerView
```

## Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Spinner** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Spinner/blob/master/LICENSE) file for more info.
