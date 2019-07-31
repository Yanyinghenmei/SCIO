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

- (NSArray *)eventDataArrayWithSessionId:(NSString *)sessionId;
- (NSArray *)pageVisitDataArrayWithSessionId:(NSString *)sessionId;

- (void)cleanEventData;
- (void)cleanPageVisitData;

@end

NS_ASSUME_NONNULL_END
