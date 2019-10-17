# EasyJSWKWebView

[![Version](https://img.shields.io/cocoapods/v/EasyJSWKWebView.svg?style=flat)](http://cocoapods.org/pods/EasyJSWKWebView)
[![License](https://img.shields.io/cocoapods/l/EasyJSWKWebView.svg?style=flat)](http://cocoapods.org/pods/EasyJSWKWebView)
[![Platform](https://img.shields.io/cocoapods/p/EasyJSWKWebView.svg?style=flat)](http://cocoapods.org/pods/EasyJSWKWebView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```html
<html>
<body><br/><br/><br/><input value="Press Me" type="button" onclick="JSInterface.test();"></body>
</html>
```

```swift

public class ClickCatcher : NSObject {
	public func test() -> String{
        return "Clicked"
    }
}


let interfaces = ["JSInterface" : ClickCatcher()];
webview = EasyJSWKWebView(frame: view.bounds, configuration: config, withJavascriptInterfaces: interfaces)
```

## Requirements
iOS8+

## Installation

EasyJSWKWebView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EasyJSWKWebView"
```

## Swift

This library uses OBJC functions that are not transportable to SWIFT. If you are using this with swift, remember to tag your methods @objc so that the objc invoker can find them

## Author

Zayin Krige, zkrige@gmail.com

## License

EasyJSWKWebView is available under the MIT license. See the LICENSE file for more info.
