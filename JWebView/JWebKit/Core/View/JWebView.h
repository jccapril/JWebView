//
//  JWebView.h
//  JWebView
//
//  Created by Flutter on 2020/12/28.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame makeConfiguration:(nullable void(^)(WKWebViewConfiguration *configuration))block;

@end

NS_ASSUME_NONNULL_END
