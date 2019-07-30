//
//  UIGestureRecognizer+ZYAnalysis.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/5.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (ZYAnalysis)
@property(nonatomic,copy)NSString * methodName;
@property(nonatomic,copy)NSString * targetName;
@end

NS_ASSUME_NONNULL_END
