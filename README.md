# Spinner
> Present loading indicators anywhere quickly and easily

A helpful loading spinner tool allowing you to present a UIActivityIndicator view directly in to views and buttons.

## 📦 Installation

### Carthage
~~~
github "nodes-ios/Spinner"
~~~

### CocoaPods
~~~
pod 'Spinner', '~> 1.0'
~~~ 

## 🔧 Setup
Easily present spinners in views like so:
```swift
let spinner = SpinnerView.showSpinnerInView(self.view)
```
Spinner also gives you the option to customise the UIActivityIndicator Style, color and whether it should disable user interaction of the passed view. These optional parameters will be set as the following if not set. 
```swift
public static func showSpinnerInView(view: UIView, style: UIActivityIndicatorViewStyle = .White, color:UIColor? = nil, disablesUserInteraction: Bool = false) -> Spinner 
```
Example of adding it to a view.
```swift
let spinner = SpinnerView.showSpinnerInView(self.view, style: UIActivityIndicatorViewStyle.White, color: UIColor.redColor(), disablesUserInteraction: false)
```

To remove the spinner from your view simply call dismiss.
```swift
spinner.dismiss()
```

----
## Custom Images spinner
If you would rather use something more custom than the UIActivityIndicator, you can set an array of images to the Spinner with a duration time it takes to animate through them and display it in a view.
```swift
public static func setCustomImages(images: [UIImage], duration: NSTimeInterval)

public static func showCustomSpinnerInView(view: UIView)
```
----
## Buttons
You can also display the spinner in buttons, simply add the spinner to any UIButton and the spinner will hide the title in the button and display the spinner in the centre of the button. Once the spinner is dismissed, the title will be made visible once more. 

```swift
public static func showCustomSpinnerInButton(button: UIButton, disablesUserInteraction:Bool = true) -> Spinner
```

 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Spinner** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Spinner/blob/master/LICENSE) file for more info.
