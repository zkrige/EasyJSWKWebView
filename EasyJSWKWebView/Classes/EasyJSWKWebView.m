//
//  EasyJSWKWebView.m
//  EasyJSWKWebView
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//
//  Modified for WKWebview by Zayin Krige on 2016/10/05
//  Copyright (c) 2016 Apex Technology. All rights reserved.
//  zayin@apextechnology.co.za
//

#import "EasyJSWKWebView.h"
#import "EasyJSListener.h"
#import "WKUserScript+InterfacesScriptGenerator.h"

@interface EasyJSWKWebView()
@property (nonatomic, strong) EasyJSListener* listener;
@end

@implementation EasyJSWKWebView

- (instancetype)initWithFrame:(CGRect)frame
                configuration:(WKWebViewConfiguration *)configuration
     withJavascriptInterfaces:(NSDictionary *)interfaces {
    
    WKUserContentController *controller = configuration.userContentController;
    if (!controller) {
        controller = [WKUserContentController new];
    }
    [controller addUserScript:[WKUserScript generateMainScript]];
    [controller addUserScript:[WKUserScript generateScriptForInterfaces:interfaces]];

    EasyJSListener *listener = [EasyJSListener new];
    listener.javascriptInterfaces = interfaces;
    [controller addScriptMessageHandler:listener name:@"Listener"];
    
    configuration.userContentController = controller;
    
    self = [super initWithFrame:frame configuration:configuration];
    self.listener = listener;
    return self;
}


@end
