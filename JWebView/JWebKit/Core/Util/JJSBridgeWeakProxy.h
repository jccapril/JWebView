//
//  JJSBridgeWeakProxy.h
//  JWebView
//
//  Created by Flutter on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJSBridgeWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
