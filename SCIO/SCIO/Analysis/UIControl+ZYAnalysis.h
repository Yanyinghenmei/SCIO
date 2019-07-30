//
//  UIControl+ZYAnalysis.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ZYAnalysis)

/**
 获取 target-aciton 映射
 */
- (NSArray *)targetActionArray;
@end

NS_ASSUME_NONNULL_END
