//
//  JJSBridgeEngine.m
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import "JJSBridgeEngine.h"
#import "WKWebView+JJSBridgeEngine.h"
#import "JJSBridgeWeakScriptMessageDelegate.h"
#import "JJSBridgeMessage.h"
#import "JJSBridgeMessageDispatcher.h"
#import "JJSBridgeModuleRegister.h"
static NSString * const JJSBridgeMessageName = @"JJSBridgeMessage";

@interface JJSBridgeEngine()<WKScriptMessageHandler>

@property (nonatomic, weak, readwrite) WKWebView *webView;

// 消息分发器
@property (nonatomic, strong, readwrite) JJSBridgeMessageDispatcher *dispatcher;
 
@property (nonatomic, strong, readwrite) JJSBridgeModuleRegister *moduleRegister;

@end

@implementation JJSBridgeEngine


- (void)dealloc {
#ifdef DEBUG
    NSLog(@"KKJSBridgeEngine dealloc");
#endif
    WKWebView *webView = (WKWebView *)self.webView;
    [webView.configuration.userContentController removeScriptMessageHandlerForName:JJSBridgeMessageName];
}

+ (instancetype)bridgeForWebView:(WKWebView *)webView {
    JJSBridgeEngine *bridge = [[self alloc] initWithWebView:webView];
    webView.j_engine = bridge;
    return bridge;
}

- (instancetype)initWithWebView:(WKWebView *)webView {
    if (self = [super init]) {
        self.webView = webView;
        [self commonInit];
        [self setup];
    }
    
    return self;
}


- (void)commonInit{
    
    self.dispatcher = [[JJSBridgeMessageDispatcher alloc] initWithEngine:self];
    self.moduleRegister = [[JJSBridgeModuleRegister alloc] initWithEngine:self];
}
- (void)setup {
    [self setupJSBridge];
}

- (void)setupJSBridge {
    WKWebViewConfiguration *webViewConfiguration = self.webView.configuration;
    if (webViewConfiguration && !webViewConfiguration.userContentController) {
        self.webView.configuration.userContentController = [WKUserContentController new];
    }
    
    // 防止内存泄露
    [self.webView.configuration.userContentController addScriptMessageHandler:[[JJSBridgeWeakScriptMessageDelegate alloc] initWithDelegate:self] name:JJSBridgeMessageName];
}


- (void)setupDefaultModuleRegister {
    
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:JJSBridgeMessageName]) {
        NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] initWithDictionary:message.body];
        JJSBridgeMessage *messageInstance = [JJSBridgeMessage convertMessageFromMessageJson:messageJson];
        [self.dispatcher dispatchCallbackMessage:messageInstance];
    }
}



@end
