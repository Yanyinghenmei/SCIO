//
//  ZYPageIOQueue.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/22.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*
 统计页面访问路径, 在应用进入后台时, 保存路径数组到缓存器, 并清空路径数组
 */

@interface ZYPageIOQueue : NSObject
+ (instancetype)shareQueue;

- (BOOL)addPageInfo:(NSDictionary *)info;
- (NSArray *)pageInfoArray;
@end

NS_ASSUME_NONNULL_END
