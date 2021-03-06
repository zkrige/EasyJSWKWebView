//
//  ClickCatcher.m
//  EasyJSWKWebView
//
//  Created by Zayin Krige on 2016/10/05.
//  Copyright © 2016 Zayin Krige. All rights reserved.
//

#import "ClickCatcher.h"
@import EasyJSWKWebView;

@implementation ClickCatcher

//this is a method that can be called from the JS library
- (NSString *)test {
    NSLog(@"event from JS was captured here");
    //this value will be sent back to the JS Library
    return @"Clicked";
}

- (void) testWithFuncParam: (EasyJSWKDataFunction *) param{
    NSLog(@"test with func");
    NSString* ret = [param executeWithParam:@"blabla:\"bla"];
    NSLog(@"Return value from callback: %@", ret);
}

@end
