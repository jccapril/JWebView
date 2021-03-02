//
//  JJSBridgeModuleRegister.m
//  JWebView
//
//  Created by Flutter on 2020/12/30.
//

#import "JJSBridgeModuleRegister.h"
#import "JJSBridgeEngine.h"
#import "JJSBridgeSafeDictionary.h"
#import "JJSBridgeModuleMetaClass.h"
@interface JJSBridgeModuleRegister()

@property (nonatomic, weak) JJSBridgeEngine *engine;

@property (nonatomic, copy) JJSBridgeSafeDictionary *moduleMetaClassMap;
@property (nonatomic, copy) JJSBridgeSafeDictionary *singletonMetaClassMap;


@end

@implementation JJSBridgeModuleRegister

- (instancetype)initWithEngine:(JJSBridgeEngine *)engine {
    if (self = [super init]) {
        self.engine = engine;
        self.moduleMetaClassMap = [JJSBridgeSafeDictionary dictionary];
        self.singletonMetaClassMap = [JJSBridgeSafeDictionary dictionary];
    }
    return self;
}

- (JJSBridgeModuleMetaClass *)registerModuleClass:(Class<JJSBridgeModule>)moduleClass {
    return [self registerModuleClass:moduleClass withContext:nil];
}

- (JJSBridgeModuleMetaClass *)registerModuleClass:(Class<JJSBridgeModule>)moduleClass withContext:(id _Nullable)context {
    return [self registerModuleClass:moduleClass withContext:context initialize:NO];
}
- (JJSBridgeModuleMetaClass *)registerModuleClass:(Class<JJSBridgeModule>)moduleClass withContext:(id _Nullable)context initialize:(BOOL)initialize {
    
    if (!moduleClass) return nil;
    
    NSString *moduleName;
    if ([moduleClass respondsToSelector:@selector(moduleName)]) {
        moduleName = [(Class<JJSBridgeModule>)moduleClass moduleName];
    }
    if (!moduleName) {
        moduleName = NSStringFromClass(moduleClass);
    }
    
    
    
    return nil;
}


@end
