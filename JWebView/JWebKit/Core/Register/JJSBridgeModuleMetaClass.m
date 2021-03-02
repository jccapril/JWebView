//
//  JJSBridgeModuleMetaClass.m
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import "JJSBridgeModuleMetaClass.h"

@interface JJSBridgeModuleMetaClass()

@property (nonatomic, copy, readwrite) NSString *moduleName;
@property (nonatomic, strong, readwrite) Class moduleClass;
@property (nonatomic, assign, readwrite) BOOL isSingleton;
@property (nonatomic, strong, readwrite) id context;

@end

@implementation JJSBridgeModuleMetaClass

- (instancetype)initWithModuleName:(NSString *)moduleName
                       moduleClass:(Class)moduleClass
                       isSingleton:(BOOL)isSingleton {
    return [self initWithModuleName:moduleName moduleClass:moduleClass isSingleton:isSingleton context:nil];
}

- (instancetype)initWithModuleName:(NSString *)moduleName
                       moduleClass:(Class)moduleClass
                       isSingleton:(BOOL)isSingleton context:(id _Nullable)context {
    if (self = [super init]) {
        self.moduleName = [moduleName copy];
        self.moduleClass = moduleClass;
        self.isSingleton = isSingleton;
        self.context = context;
    }
    
    return self;
}

@end
