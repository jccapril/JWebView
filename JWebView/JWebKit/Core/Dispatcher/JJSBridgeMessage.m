//
//  JJSBridgeMessage.m
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import "JJSBridgeMessage.h"

@implementation JJSBridgeMessage

+ (instancetype)convertMessageFromMessageJson:(NSDictionary *)json {
    JJSBridgeMessage *message = [JJSBridgeMessage new];
    [message setValuesForKeysWithDictionary:json];
//    message.module = json[@"module"];
//    message.method = json[@"method"];
//    message.data = json[@"data"];
//    message.callbackId = json[@"callbackId"];
//    message.callback = json[@"callback"];
    
    return message;
}

@end
