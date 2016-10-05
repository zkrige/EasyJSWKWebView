//
//  EasyJSViewController.m
//  EasyJSWKWebView
//
//  Created by Zayin Krige on 10/05/2016.
//  Copyright (c) 2016 Zayin Krige. All rights reserved.
//

#import "EasyJSViewController.h"
@import EasyJSWKWebView;
#import "ClickCatcher.h"

@interface EasyJSViewController ()
@end

@implementation EasyJSViewController {
    ClickCatcher *_JSInterface;
    EasyJSWKWebView *_webview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _JSInterface = [ClickCatcher new];
    WKPreferences *prefs = [WKPreferences new];
    prefs.javaScriptEnabled = YES;
    //this enables debugging with safari developer
    [prefs setValue:@"YES" forKey:@"developerExtrasEnabled"];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = prefs;
    NSDictionary *interfaces = @{@"JSInterface": _JSInterface};
    _webview = [[EasyJSWKWebView alloc] initWithFrame:self.view.bounds
                                        configuration:config
                             withJavascriptInterfaces:interfaces];
    [self.view addSubview:_webview];
    NSString *html = [self html];
    [_webview loadHTMLString:html baseURL:nil];
}

- (NSString *)html {
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:@"test" withExtension:@"html"];
    NSString *content = [NSString stringWithContentsOfURL:url
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    return content;
}
@end
