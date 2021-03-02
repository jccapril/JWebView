//
//  JJSBridgeMessageDispatcher.m
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import "JJSBridgeMessageDispatcher.h"
#import "JJSBridgeMessage.h"

@interface JJSBridgeMessageDispatcher()

@property (nonatomic, weak) JJSBridgeEngine *engine;

@property (nonatomic, strong) NSOperationQueue *dispatchQueue;

@end

@implementation JJSBridgeMessageDispatcher

- (instancetype)initWithEngine:(JJSBridgeEngine *)engine {
    if (self  = [super init]) {
        self.engine = engine;
        self.dispatchQueue = [NSOperationQueue new];
        self.dispatchQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}


- (void)dispatchCallbackMessage:(JJSBridgeMessage *)message {
    
    __weak typeof(self) weakSelf = self;
    [self.dispatchQueue addOperationWithBlock:^{
        [weakSelf dispatchCallbackMessageInQueue:message];
    }];
}

- (void)dispatchCallbackMessageInQueue:(JJSBridgeMessage *)message {
    NSString *moduleName = message.module;
    NSString *methodName = message.method;
    if (!moduleName || !methodName) {
#ifdef DEBUG
        NSLog(@"JJSBridge Error: module or method is not found");
#endif
        return;
    }
    NSDictionary *params = message.data;
}

@end
