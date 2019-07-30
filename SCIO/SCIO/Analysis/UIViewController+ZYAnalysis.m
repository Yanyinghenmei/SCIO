//
//  UIViewController+ZYAnalysis.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/6.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "UIViewController+ZYAnalysis.h"
#import "MethodSwizzingTool.h"
#import "DataContainer.h"
#import <objc/runtime.h>
#import "UIView+ZYNode.h"
#import "ZYHeader.h"

#import "ZYPageIOQueue.h"

@implementation UIViewController (ZYAnalysis)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalViewWillAppearSelector = @selector(viewWillAppear:);
        SEL swizzingViewWillAppearSelector = @selector(zy_viewWillAppear:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalViewWillAppearSelector swizzingSel:swizzingViewWillAppearSelector];
        
        SEL originalViewWillDisappearSelector = @selector(viewWillDisappear:);
        SEL swizzingViewWillDisappearSelector = @selector(zy_viewWillDisappear:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalViewWillDisappearSelector swizzingSel:swizzingViewWillDisappearSelector];
        
        /*
        SEL originalDidLoadSelector = @selector(viewDidLoad);
        SEL swizzingDidLoadSelector = @selector(zy_viewDidLoad);
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalDidLoadSelector swizzingSel:swizzingDidLoadSelector];
         */
        
    });
}

//-(void)zy_viewDidLoad {
//    [self zy_viewDidLoad];
//}

- (void)zy_viewWillAppear:(BOOL)animated {
    [self zy_viewWillAppear:animated];
    
    // 收集数据--  逻辑上, 所有数据围绕 tableView
    SEL or_sel = @selector(viewWillAppear:);
    NSString *viewPath = [self.view elementPathWithIndexPath:nil];
    NSString *actionName = NSStringFromSelector(or_sel);
    NSString *className = NSStringFromClass(self.class);
    NSString *targetName = className;
    NSString *date = [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
    NSString *tag = [NSString stringWithFormat:@"%zd",self.view.tag];
    NSString *analysisName = self.title;
    if (!analysisName) {
        analysisName = NSStringFromClass(self.class);
    }
    
    NSDictionary *dic = @{p_elementPath:viewPath,
                          p_actionName:actionName,
                          p_targetName:targetName,
                          p_className:className,
                          p_date:date,
                          p_tag:tag,
                          p_analysisName:analysisName};
    ZYPrintf(@"%@",dic);
    // 上传数据
    [StatisticalRequest uploadPageVisitInfos:@[dic]];
}
- (void)zy_viewWillDisappear:(BOOL)animated {
    [self zy_viewWillDisappear:animated];
    
    SEL or_sel = @selector(viewWillDisappear:);
    NSString *elementPath = [self.view elementPathWithIndexPath:nil];
    NSString *actionName = NSStringFromSelector(or_sel);
    NSString *className = NSStringFromClass(self.class);
    NSString *targetName = className;
    NSString *date = [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
    NSString *tag = [NSString stringWithFormat:@"%zd",self.view.tag];
    NSString *analysisName = self.title;
    if (!analysisName) {
        analysisName = NSStringFromClass(self.class);
    }
    
    NSDictionary *dic = @{p_elementPath:elementPath,
                          p_actionName:actionName,
                          p_targetName:targetName,
                          p_className:className,
                          p_date:date,
                          p_tag:tag,
                          p_analysisName:analysisName};
    ZYPrintf(@"%@",dic);
    
    // 上传数据
    [StatisticalRequest uploadPageVisitInfos:@[dic]];
}

@end
