//
//  WKWebView+JExtension.h
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, JWebViewConfigUAType) {
    JWebViewConfigUATypeReplace,     //replace all UA string
    JWebViewConfigUATypeAppend,      //append to original UA string
};

@interface WKWebView (JExtension)

+ (void)configCustomUserAgentWithType:(JWebViewConfigUAType)type userAgent:(NSString *)userAgent;

@end

NS_ASSUME_NONNULL_END
