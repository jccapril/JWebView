//
//  JWebViewPool.m
//  JWebView
//
//  Created by Flutter on 2020/12/28.
//

#import "JWebViewPool.h"
#import <WebKit/WebKit.h>
@interface JWebViewPool()

@property (nonatomic, strong, readwrite) dispatch_semaphore_t lock;

@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, NSMutableSet< __kindof WKWebView *> *> *dequeueWebViews;

@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, NSMutableSet< __kindof WKWebView *> *> *enqueueWebViews;
@property (nonatomic, copy) void(^makeWebViewConfigurationBlock)(WKWebViewConfiguration *configuration);

@end

@implementation JWebViewPool

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static JWebViewPool *singleton;
    dispatch_once(&once, ^{
        singleton = [[JWebViewPool alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    if (self = [super init]) {
        _webViewMaxReuseCount = 5;
        _webViewMaxReuseTimes = NSIntegerMax;
        _webViewReuseLoadUrlStr = @"";
        
        _dequeueWebViews = @{}.mutableCopy;
        _enqueueWebViews = @{}.mutableCopy;
        _lock = dispatch_semaphore_create(1);
        //memory warning 时清理全部
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearAllReusableWebViews)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.dequeueWebViews removeAllObjects];
    [self.enqueueWebViews removeAllObjects];
    self.dequeueWebViews = nil;
    self.enqueueWebViews = nil;
}


- (nullable __kindof WKWebView *)dequeueWebViewWithClass:(Class)webViewClass webViewHolder:(nullable NSObject *)webViewHolder {
    return nil;
}


- (void)makeWebViewConfiguration:(nullable void(^)(WKWebViewConfiguration *configuration))block {
    self.makeWebViewConfigurationBlock = block;
}


- (void)clearAllReusableWebViews {
    
}


- (__kindof WKWebView *)generateInstanceWithWebViewClass:(Class)webViewClass {
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    if (self.makeWebViewConfigurationBlock) {
        self.makeWebViewConfigurationBlock(config);
    }
    return [[webViewClass alloc] initWithFrame:CGRectZero configuration:config];
}

@end
