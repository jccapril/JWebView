//
//  JWebViewPool.h
//  JWebView
//
//  Created by Flutter on 2020/12/28.
//


// todo 等待开发

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class WKWebView;
@class WKWebViewConfiguration;

@interface JWebViewPool : NSObject

+ (instancetype)sharedInstance;


/**
 webView最大缓存数量
 默认为5个
 */
@property (nonatomic, assign, readwrite) NSInteger webViewMaxReuseCount;

/**
 webview进入回收复用池前加载的url，用于刷新webview和容错
 默认为空
 */
@property (nonatomic, copy, readwrite) NSString *webViewReuseLoadUrlStr;

/**
 webview最大重用次数
 默认为最大无限制
 */
@property (nonatomic, assign, readwrite) NSInteger webViewMaxReuseTimes;

/**
 获得一个可复用的webview
 
 @param webViewClass webview的自定义class
 @param webViewHolder webview的持有者，用于自动回收webview
 */
- (nullable __kindof WKWebView *)dequeueWebViewWithClass:(Class)webViewClass       webViewHolder:(nullable NSObject *)webViewHolder;


- (void)makeWebViewConfiguration:(nullable void(^)(WKWebViewConfiguration *configuration))block;


@end

NS_ASSUME_NONNULL_END
