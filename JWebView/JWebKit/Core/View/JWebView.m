//
//  JWebView.m
//  JWebView
//
//  Created by Flutter on 2020/12/28.
//

#import "JWebView.h"

@interface JWebView()<WKNavigationDelegate, WKUIDelegate,WKURLSchemeHandler>


/// A real delegate of the class.
@property (nonatomic, weak) id<WKNavigationDelegate> realNavigationDelegate;

@end

@implementation JWebView


- (instancetype)initWithFrame:(CGRect)frame makeConfiguration:(nullable void(^)(WKWebViewConfiguration *configuration))block {
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
//    if (@available(iOS 11.0, *)) {
//        [configuration setURLSchemeHandler:self forURLScheme:@"tbopen"];
//    } else {
//        // Fallback on earlier versions
//    }
    if (block) {
        block(configuration);
    }
    if (self = [super initWithFrame:frame configuration:configuration]) {
        if (!self.configuration.userContentController) {
            self.configuration.userContentController = [WKUserContentController new];
        }
        self.configuration.processPool = [JWebView processPool];
        self.navigationDelegate = self;
        self.UIDelegate = self;
    }
    
    return self;
}

//- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
//    NSURLRequest *request = urlSchemeTask.request;
//    if ([request.URL.scheme isEqualToString:@"tbopen"]) {
//        [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {
//                    
//        }];
//    }
//}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    // 虽然传入 nil 会有警告，这里还是做一层判断
    if (!configuration) {
        configuration = [WKWebViewConfiguration new];
    }
    
    if (self = [super initWithFrame:frame configuration:configuration]) {
        if (!self.configuration.userContentController) {
            self.configuration.userContentController = [WKUserContentController new];
        }
        
        self.configuration.processPool = [JWebView processPool];
        self.navigationDelegate = self;
        self.UIDelegate = self;
    }
    
    return self;
}


- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request {
    
    return [super loadRequest:request];
}


#pragma mark - WKNavigationDelegate
// 1、在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    id<WKNavigationDelegate> mainDelegate = self.realNavigationDelegate;
    if ([mainDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [mainDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 2、在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    id<WKNavigationDelegate> mainDelegate = self.realNavigationDelegate;
    if ([mainDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [mainDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

// 3、页面跳转完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    id<WKNavigationDelegate> mainDelegate = self.realNavigationDelegate;
    if ([mainDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [mainDelegate webView:webView didFinishNavigation:navigation];
    }
}

// 4、需要校验服务器可信度时调用
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    id<WKNavigationDelegate> mainDelegate = self.realNavigationDelegate;
    if ([mainDelegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [mainDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

#pragma mark - WKUIDelegate




- (UIViewController *)_topPresentedViewController {
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (viewController.presentedViewController)
        viewController = viewController.presentedViewController;
    return viewController;
}


#pragma mark -
#pragma mark WKNavigationDelegate Forwarder

- (void)setNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate
{
    self.realNavigationDelegate = (navigationDelegate != self ? navigationDelegate : nil);
    super.navigationDelegate = navigationDelegate ? self : nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    
    return [super respondsToSelector:aSelector] || [_realNavigationDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [super methodSignatureForSelector:aSelector] ?: [(id)_realNavigationDelegate methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id delegate = _realNavigationDelegate;
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}


#pragma mark - process
/**
 通过让所有 WKWebView 共享同一个WKProcessPool实例，可以实现多个 WKWebView 之间共享 Cookie（session Cookie and persistent Cookie）数据。Session Cookie（代指没有设置 expires 的 cookie），Persistent Cookie （设置了 expires 的 cookie）。
 
 另外 WKWebView WKProcessPool 实例在 app 杀进程重启后会被重置，导致 WKProcessPool 中的 session Cookie 数据丢失。
 同样的，如果是存储在 NSHTTPCookieStorage 里面的 SeesionOnly cookie 也会在 app 杀掉进程后清空。
 
 @return processPool
 */
+ (WKProcessPool *)processPool {
    static WKProcessPool *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[WKProcessPool alloc] init];
    });
    
    return pool;
}



@end
