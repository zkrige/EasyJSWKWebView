//
//  EasyJSWKWebView.h
//  EasyJSWKWebView
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//
//  Modified for WKWebview by Zayin Krige on 2016/10/05
//  Copyright (c) 2016 Apex Technology. All rights reserved.
//  zayin@apextechnology.co.za
//

@import WebKit;

@interface EasyJSWKWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame
                configuration:(WKWebViewConfiguration *)configuration
     withJavascriptInterfaces:(NSDictionary *)interfaces;

@end

// Umbrella imports - exposes the rest of the public API.
// CocoaPods built a framework modulemap that included these automatically;
// SPM only sees what the umbrella header includes.
#import "EasyJSListener.h"
#import "EasyJSWKDataFunction.h"
#import "WKUserScript+InterfacesScriptGenerator.h"
#import "WKWebView+SynchronousEvaluateJavaScript.h"
