//
//  JJSBridgeWeakScriptMessageDelegate.h
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JJSBridgeWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak, readonly) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

NS_ASSUME_NONNULL_END
