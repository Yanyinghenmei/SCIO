//
//  UIApplication+ZYAnalysis.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/22.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import "UIApplication+ZYAnalysis.h"
#import "ZYVisualSelectorWindow.h"
#import "MethodSwizzingTool.h"
#import "NSObject+ZYHelper.h"
#import "Reachability.h"
#import "ZYPageIOQueue.h"
#import "ZYHeader.h"


static const char *hostReachKey = "hostReachKey";
static ZYVisualSelectorWindow *visualSelectorWindow;

@implementation UIApplication (ZYAnalysis)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL originalSetDelegateSelector = @selector(setDelegate:);
        SEL swizzingSetDelegateSelector = @selector(zy_setDelegate:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalSetDelegateSelector swizzingSel:swizzingSetDelegateSelector];
    });
}

- (void)zy_setDelegate:(id<UIApplicationDelegate>)delegate {
    if ([delegate isKindOfClass:UIResponder.class]) {
        UIResponder *res_delegate = (UIResponder *)delegate;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 替换applicationWillResignActive
            if ([res_delegate isContainSel:@selector(applicationWillResignActive:) inClass:[res_delegate class]]) {
                
                SEL originalSelector = @selector(applicationWillResignActive:);
                SEL swizzingSelector = @selector(zy_temp_applicationWillResignActive:);
                
                // 添加新方法, 并将 UIApplication类中的 zy_temp_applicationWillResignActive: 作为其实现
                BOOL suc = [MethodSwizzingTool addMethodForClass:[res_delegate class] sel:swizzingSelector impClass:[self class] impSelector:swizzingSelector];
                
                if (suc) {
                    [MethodSwizzingTool swizzingForClass:[res_delegate class] originalSel:originalSelector swizzingSel:swizzingSelector];
                }
            }
            
            // 替换application:didFinishLaunchingWithOptions:
            if ([res_delegate isContainSel:@selector(application:didFinishLaunchingWithOptions:) inClass:[res_delegate class]]) {
                SEL finOriSelector = @selector(application:didFinishLaunchingWithOptions:);
                SEL finSwiSelector = @selector(zy_temp_application:didFinishLaunchingWithOptions:);
                BOOL suc = [MethodSwizzingTool addMethodForClass:[res_delegate class] sel:finSwiSelector impClass:[self class] impSelector:finSwiSelector];
                if (suc) {
                    [MethodSwizzingTool swizzingForClass:[res_delegate class] originalSel:finOriSelector swizzingSel:finSwiSelector];
                }
            }
        });
    }
    
    [self zy_setDelegate:delegate];
}


- (void)zy_temp_applicationWillResignActive:(UIApplication *)application {
    // 保存页面 访问路径 数据
    // [StatisticalRequest uploadEventInfos:[ZYPageIOQueue shareQueue].pageInfoArray];
    
    // 调用原方法
    [self zy_temp_applicationWillResignActive:application];
}

- (void)zy_temp_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 上传基本信息--- 启动时发送 --- 没有网路的时候缓存起来, 在其他数据发送前, 先检查此数据有没有缓存, 如果有, 优先发送基本信息.
    [StatisticalRequest uploadBaseInfo];
    
    [self zy_temp_application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 可视化埋点 window
    visualSelectorWindow = [[ZYVisualSelectorWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    visualSelectorWindow.hidden = false;
    visualSelectorWindow.windowLevel = UIWindowLevelAlert+1;
}

    
    
    

    
    
@end
