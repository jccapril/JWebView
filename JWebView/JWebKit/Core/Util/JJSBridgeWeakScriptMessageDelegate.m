//
//  JJSBridgeWeakScriptMessageDelegate.m
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import "JJSBridgeWeakScriptMessageDelegate.h"

@interface JJSBridgeWeakScriptMessageDelegate()

@property (nonatomic, weak, readwrite) id<WKScriptMessageHandler> scriptDelegate;

@end

@implementation JJSBridgeWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
