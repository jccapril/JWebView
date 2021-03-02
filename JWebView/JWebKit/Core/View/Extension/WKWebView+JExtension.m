//
//  WKWebView+JExtension.m
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import "WKWebView+JExtension.h"

@implementation WKWebView (JExtension)

+ (void)configCustomUserAgentWithType:(JWebViewConfigUAType)type
                            userAgent:(NSString *)userAgent {
    if (!userAgent || userAgent.length <= 0) {
        NSLog(@"WKWebView (SyncConfigUA) config with invalid string");
        return;
    }
        
    if (type == JWebViewConfigUATypeReplace) {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }else if (type == JWebViewConfigUATypeAppend) {
        //同步获取webview UserAgent
        NSString *originalUserAgent;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        SEL privateUASel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@%@",@"_",@"user",@"Agent"]);
        if ([webView respondsToSelector:privateUASel]) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            originalUserAgent = [webView performSelector:privateUASel];
            #pragma clang diagnostic pop
        }
                
        NSString *appUserAgent = [NSString stringWithFormat:@"%@ %@", originalUserAgent ?: @"", userAgent];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:appUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }else {
        NSLog(@"WKWebView (SyncConfigUA) config with invalid type :%@", @(type));
    }
}

@end
