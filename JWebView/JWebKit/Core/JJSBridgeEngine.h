//
//  JJSBridgeEngine.h
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JJSBridgeEngine : NSObject

@property (nonatomic, weak, readonly) WKWebView *webView; // 与桥接器对应的 webView

/**
 为 webView 创建一个桥接
 
 @param webView webView
 @return 返回一个桥接实例
 */
+ (instancetype)bridgeForWebView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
