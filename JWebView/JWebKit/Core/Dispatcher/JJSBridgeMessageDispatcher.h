//
//  JJSBridgeMessageDispatcher.h
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JJSBridgeEngine;
@class JJSBridgeMessage;

/**
 统一消息分发者，分发所有来自 H5 的消息，并处理消息回调
 */
@interface JJSBridgeMessageDispatcher : NSObject

- (instancetype)initWithEngine:(JJSBridgeEngine *)engine;




/**
 分发回调消息消息

 @param message 消息
 */
- (void)dispatchCallbackMessage:(JJSBridgeMessage *)message;

@end

NS_ASSUME_NONNULL_END
