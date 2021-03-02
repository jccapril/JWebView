//
//  ViewController.m
//  JWebView
//
//  Created by Flutter on 2020/12/28.
//

#import "ViewController.h"
#import "JWebKit/JWebKit.h"
#import <WKWebViewJavascriptBridge.h>
@interface ViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) JWebView *webView;

@property (nonatomic, strong) WKWebView *originWebView;

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation ViewController

+ (void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self prepareWebView];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}

+ (void)prepareWebView {
    [JWebView configCustomUserAgentWithType:JWebViewConfigUATypeAppend userAgent:@"JWebKit/1.0"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.webView = [[JWebView alloc] initWithFrame:self.view.bounds makeConfiguration:^(WKWebViewConfiguration * _Nonnull configuration) {
        configuration.allowsAirPlayForMediaPlayback = YES;
    }];
    
    
   
//    WKWebViewConfiguration *cfg = [[WKWebViewConfiguration alloc] init];
//    self.webView = [[JWebView alloc] initWithFrame:self.view.bounds configuration:cfg];
     
    self.webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    [self.webView loadRequest:request];
    
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge registerHandler:@"test" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dataDict = (NSDictionary *)data;
        NSString *scheme = dataDict[@"scheme"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme] options:@{} completionHandler:^(BOOL success) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                responseCallback(@(success));
            });
            
        }];
    }];
    
//    JJSBridgeEngine *engine = [JJSBridgeEngine bridgeForWebView:_webView];
//    NSLog(@"engine");
    
//    UIApplicationDidBecomeActiveNotification
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂不支持" preferredStyle:UIAlertControllerStyleAlert];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"TEST" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
}
- (void)buttonAction:(UIButton *)btn {
    
    
    NSString *urlString =  @"tbopen://m.taobao.com/tbopen/index.html?&action=ali.open.nav&module=h5&packageName=default&bc_fl_src=tunion_eleme&h5Url=https%3A%2F%2Ffc.ele.me%2Fa%2FdGIuZWxlLm1lL3dvdy96L2VsZS1hZC9zc3IvbmV3LWRnei0wMS0wNjEw%3Fwh_biz%3Dtm%26es%3DvHxG%252BNOcm84N%252BoQUE6FNzL1JH6PivRXAEYv%252BA8HgKVAMF0VpobfA43dFaQYGYhOd%26ali_trackid%3D2%253Amm_133983099_127950319_70375650406%253A1611825670_141_895685454%26e%3D-s023Ne1w6SsqauC0DCW34tKzPW5ZwjRDfA311WXIflhP1WS2ubz8hERx2XHQ2pIb0SLSZKqpgS6CV81PaJ4MwlJSn1QXCYBhbRrmmug9Xh6Ncvu5SzTm3Q9mgE2aB1LJnso8zjbfN7YjQ7zAP1PKfDeZzDRbGUaKA3nBd8SmUnfpsbE54YlQD3GYmhZSYtSzBqg6YI9L5oS89dWpd560ruHNz7izlIqJNKG1hqIlPFpFaIVkUmy1syepkGyb80qRI75H3ER8OJDsI7iGSTEkCL9peKeDTJBa2vbe1FMPU5SzIFLmUhVy3Gr0XUJluyZyFEJyAUsaYbEeDfOSrFoiY1poga3pcNQk0EHfjx3KCmTyCkyBcffwT9pVobQmHxWB16KBiJWIDcYVUMYt8qBGlDAWxNudbpFcQwZYlcd9VDxdtMQOuQeLj8007WIW%26union_lens%3DlensId%253AOPT%25401610343253%25400b579028_524e_176eff005da_043c%254001%253BeventPageId%253A20150318020002597%26o2i_page_id%3D3m6q7goegstdcpore4197tm06pfbjnjf_2020-12-24%26cna-url%3Da8bIFySk3BcCAbfAFHhG1klo_1611825685225";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
            
    }];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"JWebView start");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    if ([request.URL.scheme isEqualToString:@"tbopen"]) {
        [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {

        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}




@end
