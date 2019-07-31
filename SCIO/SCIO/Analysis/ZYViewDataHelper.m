//
//  ZYViewDataHelper.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/5.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ZYViewDataHelper.h"
#import "UIView+ZYNode.h"
#import "UIControl+ZYAnalysis.h"
#import "UIGestureRecognizer+ZYAnalysis.h"
#import "UITableView+ZYAnalysis.h"
#import "UICollectionView+ZYAnalysis.h"
#import "ZYHeader.h"


@implementation ZYViewDataHelper
+ (NSDictionary *)getAnalysisDataWithView:(UIView *)view {
    
    // 其实, 能进入这个里的view userInteractionEnabled 都是 true
    // 以下安全起见也做了判断
    
    NSArray *targetActionArray = @[];
    NSString *elementPath = [view elementPathWithIndexPath:nil];
    
    BOOL haveControlAction = [view isKindOfClass:UIControl.class] && view.userInteractionEnabled;
    
    // 判断是否有手势
    BOOL haveTapGesture = false;
    for (UIGestureRecognizer *ges in view.gestureRecognizers) {
        if ([ges isKindOfClass:UITapGestureRecognizer.class]) {
            haveTapGesture = true;
            break;
        }
    }
    
    // 是否会覆盖 cell 的点击事件, 如果没有覆盖/拦截, 会触发 didSelectRowAtIndexPath
    BOOL willCoverCellTouchUpInside = haveTapGesture && view.userInteractionEnabled;
    
    // 会触发 UITableView delegate didSelectRowAtIndexPath
    if ([view superViewOrSelfWithClass:UITableViewCell.class] && !haveControlAction && !willCoverCellTouchUpInside) {
        UITableViewCell *cell = [view superViewOrSelfWithClass:UITableViewCell.class];
        UITableView *tableView = [view superViewOrSelfWithClass:UITableView.class];
        NSIndexPath *indexPath = [cell indexPathIfONListView];
        elementPath = [tableView elementPathWithIndexPath:indexPath];
        SEL or_sel = @selector(tableView:didSelectRowAtIndexPath:);
        if (tableView.delegate) {
            targetActionArray = @[@{p_targetName:tableView.delegate.class,p_actionName:NSStringFromSelector(or_sel)}];
        }
        // 替换统计元素主体
        view = tableView;
    }
    
    // 会触发 UICollectionView delegate didSelectRowAtIndexPath
    else if ([view superViewOrSelfWithClass:UICollectionViewCell.class] && !haveControlAction && !willCoverCellTouchUpInside) {
        UICollectionViewCell *cell = [view superViewOrSelfWithClass:UICollectionViewCell.class];
        UICollectionView *collectionView = [view superViewOrSelfWithClass:UICollectionView.class];
        NSIndexPath *indexPath = [cell indexPathIfONListView];
        elementPath = [collectionView elementPathWithIndexPath:indexPath];
        SEL or_sel = @selector(collectionView:didSelectItemAtIndexPath:);
        if (collectionView.delegate) {
            targetActionArray = @[@{p_targetName:collectionView.delegate.class,p_actionName:NSStringFromSelector(or_sel)}];
        }
        // 替换统计元素主体
        view = collectionView;
    }
    
    // 网页暂不支持
    else if ([view superViewOrSelfWithClass:UIWebView.class] ||
             [view superViewOrSelfWithClass:NSClassFromString(@"WkWebView")]) {
        return nil;
    }
    
    // 其他
    else {
        // 如果有手势
        if (view.gestureRecognizers.count) {
            NSMutableArray *tempArr = @[].mutableCopy;
            for (UIGestureRecognizer *ges in view.gestureRecognizers) {
                [tempArr addObject:@{p_targetName:ges.targetName,p_actionName:ges.methodName}];
            }
            targetActionArray = tempArr;
        }
        
        // 如果是 UIControl 且 能够点击
        if ([view isKindOfClass:UIControl.class] && view.userInteractionEnabled) {
            UIControl *control = (UIControl *)view;
            // 如果存在点击事件
            if (control.allTargets.count) {
                if (targetActionArray.count) {
                    NSMutableArray *tempArr = targetActionArray.mutableCopy;
                    [tempArr addObjectsFromArray:[control targetActionArray]];
                    targetActionArray = tempArr.copy;
                } else {
                    targetActionArray = [control targetActionArray];
                }
            }
        }
    }
    
    
    // 视图xPath
    NSString *className = NSStringFromClass(view.class);
    NSString *date = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    NSString *tag = [NSString stringWithFormat:@"%zd",view.tag];
    
    
    NSDictionary *dic = @{p_elementPath:elementPath,
                          p_targetActionMap:targetActionArray,
                          p_className:className,
                          p_date:date,
                          p_tag:tag};

    return dic;
}


@end
