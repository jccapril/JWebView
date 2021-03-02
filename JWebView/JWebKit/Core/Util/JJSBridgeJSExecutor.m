//
//  JJSBridgeJSExecutor.m
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import "JJSBridgeJSExecutor.h"

@implementation JJSBridgeJSExecutor

+ (NSString *)jsSerializeWithJson:(NSDictionary * _Nullable)json {
    NSString *messageJSON = [self serializeWithJson:json ? json : @{} pretty:NO];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    return messageJSON;
}

+ (NSString *)serializeWithJson:(NSDictionary * _Nullable)json pretty:(BOOL)pretty {
    NSError *error = nil;
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:json ? json : @{} options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:&error] encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    if (error) {
        NSLog(@"KKJSBridge Error: format json error %@", error.localizedDescription);
    }
#endif
    
    return str ? str : @"";
}

@end
