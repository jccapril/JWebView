//
//  JJSBridgeJSExecutor.h
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJSBridgeJSExecutor : NSObject

+ (NSString *)jsSerializeWithJson:(NSDictionary * _Nullable)json; // 序列化成 JS 可以执行的字符串

+ (NSString *)serializeWithJson:(NSDictionary * _Nullable)json pretty:(BOOL)pretty;

@end

NS_ASSUME_NONNULL_END
