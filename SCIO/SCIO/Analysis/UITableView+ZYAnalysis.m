//
//  UITableView+ZYAnalysis.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/6.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "UITableView+ZYAnalysis.h"
#import "MethodSwizzingTool.h"
#import <objc/runtime.h>
#import "NSObject+ZYHelper.h"
#import "UIView+ZYNode.h"
#import "ZYHeader.h"


/*
 说明:
 目前tableView 只支持 didSelected 行为的统计, 其他包括左滑删除等行为暂不考虑
 */

@implementation UITableView (ZYAnalysis)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalAppearSelector = @selector(setDelegate:);
        SEL swizzingAppearSelector = @selector(zy_setDelegate:);
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalAppearSelector swizzingSel:swizzingAppearSelector];
    });
}

-(void)zy_setDelegate:(id<UITableViewDelegate>)delegate
{
    
    SEL originalSelector = @selector(tableView:didSelectRowAtIndexPath:);
    SEL swizzingSelector = @selector(zy_tableView:didSelectRowAtIndexPath:);
    
    //因为 tableView:didSelectRowAtIndexPath:方法是optional的，所以可能没有实现
    if ([self isContainSel:originalSelector inClass:[delegate class]]) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            // 添加新方法, 并将 UIApplication类中的 zy_temp_applicationWillResignActive: 作为其实现
            BOOL suc = [MethodSwizzingTool addMethodForClass:[delegate class] sel:swizzingSelector impClass:[self class] impSelector:swizzingSelector];
            
            if (suc) {
                [MethodSwizzingTool swizzingForClass:[delegate class] originalSel:originalSelector swizzingSel:swizzingSelector];
            }
        });
    }
    
    [self zy_setDelegate:delegate];
}


// 由于我们交换了方法， 所以在tableview的 didselected 被调用的时候， 实质调用的是以下方法：
-(void)zy_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL or_sel = @selector(tableView:didSelectRowAtIndexPath:);
    
    // 收集数据--  逻辑上, 所有数据围绕 tableView
    if (tableView && indexPath) {
        NSString *elementPath = [tableView elementPathWithIndexPath:indexPath];
        NSString *actionName = NSStringFromSelector(or_sel);
        NSString *targetName = NSStringFromClass(tableView.delegate.class);
        NSString *className = NSStringFromClass(tableView.class);
        NSString *indexPathStr = [NSString stringWithFormat:@"(%zd,%zd)",indexPath.section,indexPath.row];
        NSString *date = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
        NSString *analysisName = @"";
        
        // 保存数据
        [[DataCacheManager shareManager] saveEventDataWithSessionId:[ZYGlobalInfoHelper sessionId] targetName:targetName actionName:actionName className:className elementPath:elementPath analysisName:analysisName date:date indexPath:indexPathStr selected:false tag:tableView.tag];
    }
    
    // 最后调用原方法
    [self zy_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
