//
//  ZYViewDataHelper.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/5.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYViewDataHelper : NSObject


/**
 获取view的统计信息
 
 Keys:
 elementPath -- 视图元素的视图层次路径
 targetAction -- 视图点击事件数组, 可作为事件的唯一标识  [target+action+tag+UIControlEvents]
 className -- 视图类名
 date -- 触发时间戳
 tag -- view.tag

 @param view 需要获取信息的view
 @return 数据信息
 */
+ (NSDictionary *)getAnalysisDataWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
