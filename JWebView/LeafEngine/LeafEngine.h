//
//  LeafEngine.h
//  JWebView
//
//  Created by Flutter on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeafEngine : NSObject

/// 哔噜的api域名
@property (nonatomic, copy, readonly) NSString *apiHost;

/// 友盟的appKey
@property (nonatomic, copy, readonly) NSString *umengAppKey;

/// 云信的appKey
@property (nonatomic, copy, readonly) NSString *nimAppKey;

/// 云信的证书名
@property (nonatomic, copy, readonly) NSString *nimApnsCername;

/// 高德地图的apiKey
@property (nonatomic, copy, readonly) NSString *aMapApiKey;

+ (instancetype)sharedEngine;

+ (RACSignal<RACTwoTuple<id, NSString *> *> *)rac_replaceSignal;

@end

NS_ASSUME_NONNULL_END
