//
//  JJSBridgeMessage.h
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 统一 JSBridge 消息，封装来自 H5 的消息体和需要发送给 H5 回调的消息体
*/
@interface JJSBridgeMessage : NSObject

@property (nonatomic, copy, nullable) NSDictionary *data;

#pragma mark - callback 相关
@property (nonatomic, copy, nullable) NSString *module;
@property (nonatomic, copy, nullable) NSString *method;
/// 用于H5调用回调
@property (nonatomic, copy, nullable) NSString *callbackId;
/// 用于本地调用回调
@property (nonatomic, copy, nullable) void (^callback)(NSDictionary * _Nullable responseData);


/**
 转换 json 到 message 对象

 @param json message json
 @return message 对象
 */
+ (instancetype)convertMessageFromMessageJson:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
