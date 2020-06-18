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

+ (instancetype)shareManager;

- (void)saveUserInfoWithUserId:(NSString *)userId
                          name:(NSString *)name
                         phone:(NSInteger)phone
                           sex:(NSInteger)sex
                           age:(NSInteger)age;

- (void)saveUserLocalWithLatitude:(double)latitude
                        longitude:(double)longitude;


- (void)saveForEvent:(NSString *)eventId;

/**
 针对后台分配的事件和字段上传数据
 例如，后台分配 eventId = 00001, 所有eventId == 00001都表示为成交事件， price代表成交价， orderId代表订单id
 [[DataCacheManager shareManager] saveForEvent:@"00001" info:@{@"price":@"1000",@"orderId":@"xxxxxxx"}]

 @param eventId 事件ID
 @param info 数据信息
 */
- (void)saveForEvent:(NSString *)eventId
                info:(NSDictionary *)info;


- (void)saveEventDataWithSessionId:(NSString *)sessionId
                        targetName:(NSString *)targetName
                        actionName:(NSString *)actionName
                         className:(NSString *)className
                       elementPath:(NSString *)elementPath
                      analysisName:(NSString *)analysisName
                              date:(NSString *)date
                         indexPath:(nullable NSString *)indexPath
                          selected:(BOOL)selected
                               tag:(NSInteger)tag;

- (void)savePageVisitDataWithSessionId:(NSString *)sessionId
                            targetName:(NSString *)targetName
                            actionName:(NSString *)actionName
                             className:(NSString *)className
                           elementPath:(NSString *)elementPath
                          analysisName:(NSString *)analysisName
                                  date:(NSString *)date
                                   tag:(NSInteger)tag;

- (void)uploadCacheData;

@end

NS_ASSUME_NONNULL_END
