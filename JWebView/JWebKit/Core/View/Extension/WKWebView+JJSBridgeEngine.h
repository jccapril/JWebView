//
//  WKWebView+JJSBridgeEngine.h
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JJSBridgeEngine;
@interface WKWebView (JJSBridgeEngine)

/**
 KKJSBridgeEngine 在安装的时候，会赋值
 */
@property (nonatomic, weak) JJSBridgeEngine *j_engine;

@end

NS_ASSUME_NONNULL_END
