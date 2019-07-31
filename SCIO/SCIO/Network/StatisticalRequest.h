//
//  StatisticalRequest.h
//  ZYDataCollectionDemo
//
//  Created by cn on 2019/7/18.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticalRequest : NSObject
+ (void)postUploadStatisticsWithUrlString:(NSString *)urlString
                                   params:(NSDictionary *)params
                        completionHandler:(void(^)(NSDictionary * _Nullable data,NSError * _Nullable error))completionHandler;

+ (void)getUploadStatisticsWithUrlString:(NSString *)urlString
                                  params:(NSDictionary *)params
                       completionHandler:(void(^)(NSDictionary * _Nullable data, NSError * _Nullable error))completionHandler;



/**
 上传设备/APP信息
 */
+ (void)uploadBaseInfo;


/**
 上传事件信息
 */
+ (void)uploadEventInfos:(NSArray *)infos callback:(void(^)(NSError * _Nullable error))callback;


/**
 上传页面访问信息
 */
+ (void)uploadPageVisitInfos:(NSArray *)infos callback:(void(^)(NSError * _Nullable error))callback;
@end

NS_ASSUME_NONNULL_END
