//
//  WKUserScript+InterfacesScriptGenerator.m
//  EasyJSWKWebView
//
//  Created by Zayin Krige on 2016/10/05.
//  Copyright © 2016 Apex Technology. All rights reserved.
//

#import "WKUserScript+InterfacesScriptGenerator.h"
#import <objc/runtime.h>
#import "EasyJSWKWebView.h"

@implementation WKUserScript (InterfacesScriptGenerator)

+ (instancetype)generateScriptForInterfaces:(NSDictionary *)interfaces {
    NSMutableString* injection = [NSMutableString new];
    
    //inject the javascript interface
    for(NSString *key in [interfaces allKeys]) {
        NSObject* interface = [interfaces objectForKey:key];
        
        [injection appendString:@"EasyJS.inject(\""];
        [injection appendString:key];
        [injection appendString:@"\", ["];
        
        unsigned int mc = 0;
        Class cls = object_getClass(interface);
        Method * mlist = class_copyMethodList(cls, &mc);
        for (int i = 0; i < mc; i++){
            [injection appendString:@"\""];
            [injection appendString:[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]];
            [injection appendString:@"\""];
            
            if (i != mc - 1){
                [injection appendString:@", "];
            }
        }
        
        free(mlist);
        
        [injection appendString:@"]);"];
    }
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:injection injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    return script;
}

+ (instancetype)generateMainScript {
    NSBundle *podBundle = [NSBundle bundleForClass:[EasyJSWKWebView class]];
    NSURL *bundleUrl = [podBundle URLForResource:@"EasyJSWKWebView" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    NSURL *url = [bundle URLForResource:@"easyjs-inject" withExtension:@"js"];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:content injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    return script;
}
@end
