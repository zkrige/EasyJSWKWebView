//
//  WKWebView+SynchronousEvaluateJavaScript.h
//  
//
//  Created by Zayin Krige on 2016/09/15.
//  Copyright © 2016 Apex Technology. All rights reserved.
//

@import WebKit;

@interface WKWebView (SynchronousEvaluateJavaScript)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script error:(NSError **)error;
- (void)executeJavaScriptFromString:(NSString *)script;
@end
