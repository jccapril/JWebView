//
//  JJSBridgeModuleRegister.h
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JJSBridgeEngine;


@protocol JJSBridgeModule <NSObject>

+ (NSString *)moduleName; // 配置模块名

@optional
+ (BOOL)isSingleton; // 是否是单例模块

@end


/**
 模块注册者，每个 JSBridge 有自己单独的注册者，保持独立
 */
@interface JJSBridgeModuleRegister : NSObject

- (instancetype)initWithEngine:(JJSBridgeEngine *)engine;

@end

NS_ASSUME_NONNULL_END
