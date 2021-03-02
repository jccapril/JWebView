//
//  WKWebView+JJSBridgeEngine.m
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import "WKWebView+JJSBridgeEngine.h"
#import <objc/runtime.h>
#import "JJSBridgeEngine.h"
#import "JJSBridgeWeakProxy.h"


@implementation WKWebView (JJSBridgeEngine)

- (JJSBridgeEngine *)j_engine {
    JJSBridgeWeakProxy *proxy = objc_getAssociatedObject(self, @selector(j_engine));
    return proxy.target;
}

- (void)setJ_engine:(JJSBridgeEngine *)j_engine {
    JJSBridgeWeakProxy *proxy = [JJSBridgeWeakProxy proxyWithTarget:j_engine];
    objc_setAssociatedObject(self, @selector(j_engine), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
