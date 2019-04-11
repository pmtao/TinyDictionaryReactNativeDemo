//
//  EasyReadWebView.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/14.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "EasyReadWebView.h"

/** 解决 html 默认字体过小的脚本 */
static NSString *const fontSizeBiggerScript = @"var meta = document.createElement('meta');\nmeta.setAttribute('name', 'viewport');\nmeta.setAttribute('content', 'width=device-width');\ndocument.getElementsByTagName('head')[0].appendChild(meta);";

/** 禁止缩放脚本 */
static NSString *const unscalableScript = @"var meta = document.createElement('meta');\nmeta.setAttribute('name', 'viewport');\nmeta.setAttribute('content', 'initial-scale=1, maximum-scale=1, user-scalable=no');\ndocument.getElementsByTagName('head')[0].appendChild(meta);";


@implementation EasyReadWebView

- (instancetype)initWithFrame:(CGRect)frame {
    WKWebViewConfiguration * configuration = [EasyReadWebView defaultScriptedConfiguration];
    self = [super initWithFrame:frame configuration:configuration];
    return self;
}


+ (WKWebViewConfiguration *)defaultScriptedConfiguration {
    WKWebViewConfiguration * webConfiguration = [WKWebViewConfiguration new];
    NSArray *userScripts = [EasyReadWebView importScriptSources:@[fontSizeBiggerScript, unscalableScript]];
    WKUserContentController *userContentController = [EasyReadWebView setScriptController:userScripts messageHandler:nil named:nil];
    webConfiguration.userContentController = userContentController;
    return webConfiguration;
}

+ (NSArray *)importScriptSources:(NSArray *)scripts {
    NSMutableArray *userScripts = [NSMutableArray array];
    for (NSString *script in scripts) {
        WKUserScript *scriptObject =
        [[WKUserScript alloc] initWithSource:script
                               injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                            forMainFrameOnly:NO];
        [userScripts addObject:scriptObject];
    }
    return userScripts;
}

+ (WKUserContentController *)setScriptController:(NSArray *)userScripts messageHandler:(id<WKScriptMessageHandler>)messageHandler named:(NSString *)handlerName {
    WKUserContentController *userContentController = [WKUserContentController new];
    for (WKUserScript *userScript in userScripts) {
        [userContentController addUserScript:userScript];
    }
    if (messageHandler != nil && handlerName != nil) {
        [userContentController addScriptMessageHandler:messageHandler name:handlerName];
    }
    return userContentController;
}



@end
