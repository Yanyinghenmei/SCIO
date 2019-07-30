//
//  DataCacheManager.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/29.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/**
 数据缓存及压缩, 暂时只做缓存
 */
@interface DataCacheManager : NSObject

+ (void)saveDeviceData:(NSDictionary *)data;
+ (void)saveEventData:(NSDictionary *)data;
+ (void)savePageVisitData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
