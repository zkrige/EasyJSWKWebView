//
//  EasyJSWKWebViewDelegate.m
//  EasyJSWKWebView
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//
//  Modified for WKWebview by Zayin Krige on 2016/10/05
//  Copyright (c) 2016 Apex Technology. All rights reserved.
//  zayin@apextechnology.co.za
//

#import "EasyJSListener.h"
#import "EasyJSWKDataFunction.h"
#import <objc/runtime.h>
#import "WKWebView+SynchronousEvaluateJavaScript.h"

@implementation EasyJSListener

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSMutableArray <EasyJSWKDataFunction *>* _funcs = [NSMutableArray new];
    NSMutableArray <NSString *>* _args = [NSMutableArray new];

    if ([message.name isEqualToString:@"Listener"]) {
        __weak EasyJSWKWebView *webView = (EasyJSWKWebView *)message.webView;
        NSString *requestString = [message body];
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        //NSLog(@"req: %@", requestString);
        
        NSString* obj = (NSString*)[components objectAtIndex:0];
        NSString* method = [(NSString*)[components objectAtIndex:1] stringByRemovingPercentEncoding];
        NSObject* interface = [self.javascriptInterfaces objectForKey:obj];
        
        // execute the interfacing method
        SEL selector = NSSelectorFromString(method);
        NSMethodSignature* sig = [interface methodSignatureForSelector:selector];
        NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
        invoker.selector = selector;
        invoker.target = interface;
        
        if ([components count] > 2){
            NSString *argsAsString = [(NSString*)[components objectAtIndex:2] stringByRemovingPercentEncoding];
            NSArray* formattedArgs = [argsAsString componentsSeparatedByString:@":"];
            
            for (unsigned long i = 0, j = 0, l = [formattedArgs count]; i < l; i+=2, j++){
                NSString* type = ((NSString*) [formattedArgs objectAtIndex:i]);
                NSString* argStr = ((NSString*) [formattedArgs objectAtIndex:i + 1]);
                
                if ([@"f" isEqualToString:type]){
                    EasyJSWKDataFunction *func = [[EasyJSWKDataFunction alloc] initWithWebView:webView];
                    func.funcID = argStr;
                    //do this to force retain a reference to it
                    [_funcs addObject:func];
                    [invoker setArgument:&func atIndex:(j + 2)];
                }else if ([@"s" isEqualToString:type]){
                    NSString* arg = [argStr stringByRemovingPercentEncoding];
                    //do this to force retain a reference to it
                    [_args addObject:arg];
                    [invoker setArgument:&arg atIndex:(j + 2)];
                }
            }
        }
        [invoker retainArguments];
        [invoker invoke];
        
        //return the value by using javascript
        if ([sig methodReturnLength] > 0){
            __unsafe_unretained NSString* tmpRetValue;
            [invoker getReturnValue:&tmpRetValue];
            NSString *retValue = tmpRetValue;
            
            if (retValue == NULL || retValue == nil){
                [webView executeJavaScriptFromString:@"EasyJS.retValue=null;"];
            }else{
                retValue = [retValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
                retValue = [@"" stringByAppendingFormat:@"EasyJS.retValue=\"%@\";", retValue];
                [webView executeJavaScriptFromString:retValue];
            }
        }
    }

    //clean up any retained funcs
    [_funcs removeAllObjects];
    //clean up any retained args
    [_args removeAllObjects];
}


@end
