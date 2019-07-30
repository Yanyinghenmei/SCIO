//
//  UIView+ZYNode.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZYNode)


/**
 view所在控制器
 */
- (UIViewController*)viewController;


/**
 判断此view是否是controller.view

 @return true: 是控制器持有的view, false: 不是...
 */
- (BOOL)isViewOfViewController;


/**
 获取view的路径(elementPath)
 
 注意:
    在相同视图状态下的elementPath才是相同的, 所以在获取elementPath时, 注意视图状态
    由于大多数时候是点击事件触发时获取elementPath, 如果点击事件也会进行UI操作, 而UI操作前后的elementPath很可能是不同的, 需要在UI操作之前获取elementPath

 @param indexPath 如果是tableView/collectionView 需要传indexPath
 @return 视图路径 elementPath
 */
- (NSString *)elementPathWithIndexPath:(nullable NSIndexPath *)indexPath;


/**
 返回响应者链条

 @return 响应者链条
 */
- (NSString *)responderPath;


/**
 如果是在listView上, 获取cell的 indexPath

 @return indexPath
 */
- (NSIndexPath *)indexPathIfONListView;


/**
 获取类型为cla的当前视图或父视图

 @param cla 类型
 @return 视图
 */
- (id)superViewOrSelfWithClass:(Class)cla;


/**
 获取类型为cla的下级响应者

 @param cla 类型
 @return 响应者
 */
- (UIResponder *)nextResponderWithClass:(Class)cla;
@end

NS_ASSUME_NONNULL_END
