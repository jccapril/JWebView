//
//  LeafEngine.m
//  JWebView
//
//  Created by Flutter on 2021/1/26.
//

#import "LeafEngine.h"
#import <AFNetworking/AFNetworking.h>
#import <AVOSCloud/AVOSCloud.h>
#import <RNCryptor-objc/RNDecryptor.h>
#import <CommonCrypto/CommonCrypto.h>


#define kDefaultTimeDelta 43200

#ifdef DEBUG
# define LeafLog(fmt, ...) NSLog((@"💗💗💗💗💗💗[路径:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), [[NSString stringWithFormat:@"%s", __FILE__].lastPathComponent UTF8String], __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
//# define GALLog(fmt,...) NSLog(@"" fmt);
# define LeafLogLog(...);
#endif

#define kLeafEngineBid ([NSBundle mainBundle].bundleIdentifier)
#define kLeafEngineAppVerison ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

// 验签
const RNCryptorSettings kLeafRNCryptorAES256Settings = {
    .algorithm = kCCAlgorithmAES128,
    .blockSize = kCCBlockSizeAES128,
    .IVSize = kCCBlockSizeAES128,
    .options = kCCOptionPKCS7Padding,
    .HMACAlgorithm = kCCHmacAlgSHA256,
    .HMACLength = CC_SHA256_DIGEST_LENGTH,
    
    .keySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 8
    },
    
    .HMACKeySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 8
    }
};

NSString *  const LeafEngineOptionsKey = @"leaf_options_key";
NSString *  const LeafEngineDBUrlKey = @"leaf_db_key";
NSString *  const LeafEngineExpireDateKey = @"leaf_expire_date_key";
NSString *  const LeafEngineSecretKey = @"leaf_engine_key";

NSString *  const LeafEnginePassword = @"n62bm23xer84yt";


NSString *  const LeafEngineAVOSCloudAppId = @"9BLTawQRk3oG3Q41c1w1IlLF-gzGzoHsz";
NSString *  const LeafEngineAVOSCloudClientKey = @"9HtET8nhNaJuxuEi898IPK2R";
NSString *  const LeafEngineAVOSCloudDomain = @"https://9bltawqr.api.lncld.net";

//[AVOSCloud setServerURLString:@"https://wg0hi6ve.api.lncld.net" forServiceModule:AVServiceModuleAPI];
//[AVOSCloud setApplicationId:@"Wg0hI6vE9pTLLPoVGTB9Qt3F-gzGzoHsz"
//                  clientKey:@"5D2jJJ3m2MB6LnpGhbNy3Neb"];

//https://9bltawqr.api.lncld.net
//[AVOSCloud setApplicationId:@"9BLTawQRk3oG3Q41c1w1IlLF-gzGzoHsz"
//                  clientKey:@"9HtET8nhNaJuxuEi898IPK2R"];



@interface LeafEngine()

/// 哔噜的api域名
@property (nonatomic, copy, readwrite) NSString *host;

/// 友盟的appKey
@property (nonatomic, copy, readwrite) NSString *umengAppKey;

/// 云信的appKey
@property (nonatomic, copy, readwrite) NSString *nimAppKey;

/// 云信的证书名
@property (nonatomic, copy, readwrite) NSString *nimApnsCername;

/// 高德地图的apiKey
@property (nonatomic, copy, readwrite) NSString *aMapApiKey;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSDate *expireDate;

@property (nonatomic, assign) BOOL repeat;

@end

@implementation LeafEngine

#pragma mark --- getter setter ---

- (NSString *)apiHost {
    if ([_host hasPrefix:@"https://"]) {
        _host = [_host stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    }else if ([_host hasPrefix:@"http://"]) {
        _host = [_host stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    }
    if (![_host hasPrefix:@"api."]) {
        _host = [NSString stringWithFormat:@"api.%@",_host];
    }
    return _host;
}


#pragma mark --- signleton ---
+ (instancetype)sharedEngine {
    static dispatch_once_t once;
    static LeafEngine *singleton;
    dispatch_once(&once, ^{
        singleton = [[LeafEngine alloc] init];
        singleton.expireDate = [[NSUserDefaults standardUserDefaults] objectForKey:LeafEngineExpireDateKey];
        singleton.url = [[NSUserDefaults standardUserDefaults] objectForKey:LeafEngineDBUrlKey];
    });
    return singleton;
}



+ (RACSignal *)rac_replaceSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[LeafEngine sharedEngine] willStart:subscriber];
        return [RACDisposable disposableWithBlock:^{
            LeafLog(@"signal destory");
        }];
    }];
    return signal;
}

- (void)willStart:(id<RACSubscriber>)subscriber {
    [[[AFNetworkReachabilityManager sharedManager] rac_valuesAndChangesForKeyPath:@"reachable" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        BOOL reachable = [x.first boolValue];
        if (reachable) {
            [self didStart:subscriber];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)didStart:(id<RACSubscriber>)subscriber {
    // kvo在初始化也会被observer，所以加一个重复判断
    if (self.repeat) {
        return;
    }
    self.repeat = YES;
    
    if (self.expireDate != nil) {
        NSDate *current = [NSDate date];
        if ([current laterDate:self.expireDate] != current) {
            [self unPack];
            [subscriber sendNext:RACTuplePack(@1,@"success from cache")];
            return;
        }
    }
    
    if (self.url != nil && self.url.length > 0) {
        LeafLog(@"app request with db url from cache");
        [self requestUrl:_url withSubscriber:subscriber];
        return;
    }
    
    [AVOSCloud setApplicationId:LeafEngineAVOSCloudAppId clientKey:LeafEngineAVOSCloudClientKey serverURLString:LeafEngineAVOSCloudDomain];
    AVQuery *bid_query = [AVQuery queryWithClassName:@"bapps"];
    [bid_query whereKey:@"bid" equalTo:kLeafEngineBid];
    AVQuery *version_query = [AVQuery queryWithClassName:@"bapps"];
    [version_query whereKey:@"version" equalTo:kLeafEngineAppVerison];
    AVQuery *state_query = [AVQuery queryWithClassName:@"bapps"];
    [state_query whereKey:@"status" equalTo:@(1)];
    AVQuery *query = [AVQuery andQueryWithSubqueries:@[bid_query,version_query,state_query]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            AVObject *obj = [objects firstObject];
            NSString *url = [obj objectForKey:@"u"];
            if (url.length > 0) {
                LeafLog(@"app start request from leancloud");
                [self requestUrl:url withSubscriber:subscriber];
            }else {
                LeafLog(@"leancloud url is nil");
                [subscriber sendNext:RACTuplePack(@0,@"leancloud url is nil")];
                [subscriber sendCompleted];
            }
        }else {
            if (error != nil) {
                LeafLog(@"leancloud error");
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }else {
                LeafLog(@"leancloud no data");
                [subscriber sendNext:RACTuplePack(@0,@"leancloud no data")];
                [subscriber sendCompleted];
            }
        }
    }];
    
}



/// 请求db的api
- (void)requestUrl:(NSString *)url withSubscriber:subscriber{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:LeafEngineDBUrlKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[AFHTTPSessionManager manager] GET:url parameters:@{@"bundleid":kLeafEngineBid,@"version":kLeafEngineAppVerison} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkData:responseObject]) {
            [self pack:responseObject];
            LeafLog(@"db api success");
            [subscriber sendNext:RACTuplePack(@1,@"success from db")];
            [subscriber sendCompleted];
        }else {
            LeafLog(@"db api fmt error");
            [subscriber sendNext:RACTuplePack(@0,@"db api fmt error")];
            [subscriber sendCompleted];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LeafLog(@"db api error");
        [subscriber sendError:error];
    }];
    
}


// 检查dbapi数据是否非法
- (BOOL)checkData:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        if ([response[@"payload"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *payload = response[@"payload"];
            if ([payload[@"api_host"] isKindOfClass:[NSString class]]) {
                NSString *api = payload[@"api_host"];
                return api.length > 0;
            }
        }
    }
    return NO;
}


// 保存数据
- (void)pack:(NSDictionary *)response {
    NSDictionary *payload = response[@"payload"];
    self.host = payload[@"api_host"];
    NSInteger timeDelta = [payload[@"time_delta"] integerValue];
    if (timeDelta <= 0) {
        timeDelta = kDefaultTimeDelta;
    }
    self.expireDate = [NSDate dateWithTimeIntervalSinceNow:timeDelta];
    NSDictionary *thirdConfigs = payload[@"third_configs"];
    self.aMapApiKey = [self decryptString:thirdConfigs[@"amap"]];
    self.umengAppKey = [self decryptString:thirdConfigs[@"umeng"]];
    NSDictionary *nimConfigs = thirdConfigs[@"nim"];
    self.nimAppKey = [self decryptString:nimConfigs[@"key"]];
    self.nimApnsCername =  [self decryptString:nimConfigs[@"cert"]];
    NSDictionary *r = @{@"host":_host?:@"",
                        @"amap_api_key":_aMapApiKey?:@"",
                        @"umeng_app_key":_umengAppKey?:@"",
                        @"nim_app_key":_nimAppKey?:@"",
                        @"nim_apns_cer_name":_nimApnsCername?:@""
    };
    [[NSUserDefaults standardUserDefaults] setObject:r forKey:LeafEngineOptionsKey];
    [[NSUserDefaults standardUserDefaults] setObject:_expireDate forKey:LeafEngineExpireDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 解析保存数据
- (void)unPack {
    NSDictionary *options = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LeafEngineOptionsKey];
    if ([options isKindOfClass:[NSDictionary class]] && options != nil) {
        self.host =  options[@"host"];
        self.aMapApiKey = options[@"amap_api_key"];
        self.umengAppKey = options[@"umeng_app_key"];
        self.nimAppKey = options[@"nim_app_key"];
        self.nimApnsCername = options[@"nim_apns_cer_name"];
    }
}

- (NSString *)decryptString:(NSString *)source {
    if (source.length == 0) return @"";
    NSString * password = [NSString stringWithFormat:@"%@%@",kLeafEngineBid,LeafEnginePassword];

    NSData * sourceData = [[NSData alloc] initWithBase64EncodedString:source options:0];
    NSError *error;
    NSData * decryptedData = [RNDecryptor decryptData:sourceData
                                       withSettings:kLeafRNCryptorAES256Settings
                                           password:password
                                              error:&error];
    if (error) {
        return @"";
    }
    NSString * decryptedString = [[NSString alloc] initWithData:decryptedData
                                                     encoding:NSUTF8StringEncoding];
    return decryptedString;
}


@end
