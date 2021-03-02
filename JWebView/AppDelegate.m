//
//  AppDelegate.m
//  JWebView
//
//  Created by Flutter on 2020/12/28.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeafEngine.h"
#import "JJSBridgeJSExecutor.h"
#import <AFNetworking/AFNetworking.h>

#import "AppDelegate+Service.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerThirdSDKWithOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIViewController *svc = [[UIViewController alloc] init];
    svc.view.backgroundColor = [UIColor redColor];
    self.window.rootViewController = svc;
    
    [[LeafEngine rac_replaceSignal] subscribeNext:^(RACTwoTuple<id,NSString *> * _Nullable x) {
        NSLog(@"jcc %@ receive result is %@, msg is %@",[NSThread currentThread],x.first,x.second);
        NSInteger result = [x.first integerValue];
        if (result == 1) {
            ViewController *rvc = [[ViewController alloc] init];
            rvc.url = [NSURL URLWithString:@"https://www.qq.com"];
            self.window.rootViewController = rvc;
        }else {
            ViewController *ovc = [[ViewController alloc] init];
            ovc.url = [NSURL URLWithString:@"https://www.baidu.com"];
            self.window.rootViewController = ovc;
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"jcc receive err %@",error);
        ViewController *ovc = [[ViewController alloc] init];
        ovc.url = [NSURL URLWithString:@"https://www.baidu.com"];
        self.window.rootViewController = ovc;
    } completed:^{
        NSLog(@"jcc receive completed");
    }];

    NSString *jsonString = [JJSBridgeJSExecutor serializeWithJson:@{@"a":@"b"} pretty:NO];
    NSLog(@"%@",jsonString);
    NSString *jsJSONString = [JJSBridgeJSExecutor jsSerializeWithJson:@{@"a":@"b"}];
    NSLog(@"%@",jsJSONString);

    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%@",url);
//    [LeafEngine openUrl:url];
    return YES;
}





@end
