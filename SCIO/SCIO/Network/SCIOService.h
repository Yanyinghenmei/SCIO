//
//  SCIOService.h
//  SCIO
//
//  Created by Daniel Chuang on 2019/8/23.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCIOService : NSObject
+ (instancetype)shareManager;

- (void)saveUserInfoWithUserId:(NSString *)userId
                          name:(NSString *)name
                         phone:(NSInteger)phone
                           sex:(NSInteger)sex
                           age:(NSInteger)age;

- (void)saveUserLocalWithLatitude:(double)latitude
                        longitude:(double)longitude;

/**
 针对后台分配的事件和字段上传数据
 例如，后台分配 eventId = 00001, 所有eventId == 00001都表示为成交事件， price代表成交价， orderId代表订单id
 [[DataCacheManager shareManager] saveForEvent:@"00001" info:@{@"price":@"1000",@"orderId":@"xxxxxxx"}]
 
 @param eventId 事件ID
 @param info 数据信息
 */
- (void)saveForEvent:(NSString *)eventId
                info:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
