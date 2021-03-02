//
//  JJSBridgeSafeDictionary.h
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 单线程写，多线程读
 */
@interface JJSBridgeSafeDictionary : NSMutableDictionary

@end

NS_ASSUME_NONNULL_END
