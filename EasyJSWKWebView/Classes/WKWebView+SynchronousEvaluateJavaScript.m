//
//  WKWebView+SynchronousEvaluateJavaScript.m
//  EasyJSWKWebView
//
//  Created by Zayin Krige on 2016/09/15.
//  Copyright © 2016 Apex Technology. All rights reserved.
//

#import "WKWebView+SynchronousEvaluateJavaScript.h"

@implementation WKWebView (SynchronousEvaluateJavaScript)

//execute the JS and wait for a response
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script error:(NSError **)error {
    __block NSString *resultString = @"";
    __block BOOL finished = NO;
    __block NSError *tmpError = nil;
    
    
    [self evaluateJavaScript:script completionHandler:^(id result, NSError *jsError) {
        if (jsError == nil) {
            if (result != nil) {
                resultString = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            tmpError = [jsError copy];
        }
        finished = YES;
    }];
    
    //max 5 seconds for script to run
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
    
    while (!finished && [[NSDate date] compare:date] == NSOrderedAscending){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    if (!finished) {
        NSLog(@"Timed out");
    }

    
    if (tmpError && error != NULL) {
        *error = [tmpError copy];
    }
    
    return resultString;
}

//just execute the JS, dont wait for a response
- (void)executeJavaScriptFromString:(NSString *)script {
    [self evaluateJavaScript:script completionHandler:nil];
}
@end
