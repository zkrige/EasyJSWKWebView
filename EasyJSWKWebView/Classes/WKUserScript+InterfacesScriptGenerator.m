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
    // The easyjs-inject.js resource ships in a sibling .bundle whose name and
    // location depend on how the library is integrated:
    //   CocoaPods: "EasyJSWKWebView.bundle" alongside the framework binary.
    //   SPM (statically linked into a host framework): "EasyJSWKWebView_EasyJSWKWebView.bundle"
    //     at the top of the *main app* bundle, NOT inside bundleForClass:'s framework.
    //   SPM (linked directly into app): same SPM name, also in main bundle.
    // Walk likely candidates and try both naming conventions.
    NSBundle *classBundle = [NSBundle bundleForClass:[EasyJSWKWebView class]];
    NSArray<NSBundle *> *candidates = [NSBundle mainBundle] == classBundle
        ? @[classBundle]
        : @[classBundle, [NSBundle mainBundle]];
    NSBundle *bundle = nil;
    for (NSBundle *candidate in candidates) {
        NSURL *bundleURL = [candidate URLForResource:@"EasyJSWKWebView_EasyJSWKWebView" withExtension:@"bundle"]
                        ?: [candidate URLForResource:@"EasyJSWKWebView" withExtension:@"bundle"];
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
            break;
        }
    }
    if (!bundle) {
        // Fall back to the framework bundle itself in case the resource was
        // copied directly inside it (some build setups do this).
        bundle = classBundle;
    }
    NSURL *url = [bundle URLForResource:@"easyjs-inject" withExtension:@"js"];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:content injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    return script;
}
@end
