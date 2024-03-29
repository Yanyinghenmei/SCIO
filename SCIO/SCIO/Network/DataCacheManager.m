//
//  DataCacheManager.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/29.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import "DataCacheManager.h"
#import "ZYDefine.h"
#import "StatisticalRequest.h"
#import "ParameterConfig.h"
#import "ZYGlobalInfoHelper.h"
#import "StatisticalRequest.h"

#import <zlib.h>
#import <sqlite3.h>

#define DB_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject
#define DB_NAME @"scio.sqlite"

#define EVENT_T_NAME @"t_event"
#define PAGE_T_NAME @"t_page"

@implementation DataCacheManager {
    sqlite3 *_db;
}

+ (instancetype)shareManager {
    static DataCacheManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [DataCacheManager new];
        
        // 打开数据库, 如果数据库不存在, 会自动创建数据库
        int res = [mgr openDB];
        if (res == SQLITE_OK) {
            
            /// 创建表的 sql 语句
            // 事件信息
            NSString *eventSql = [NSString stringWithFormat:
                                   @"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL);",
                                   EVENT_T_NAME, p_sessionId, p_targetName,
                                   p_actionName, p_className,
                                   p_elementPath, p_analysisName,
                                   p_date, p_indexPath,
                                   p_selected,p_tag];

            // 页面信息
            NSString *pageSql = [NSString stringWithFormat:
                                  @"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL,%@ text NOT NULL);",
                                  PAGE_T_NAME, p_sessionId, p_targetName,
                                  p_actionName, p_className,
                                  p_elementPath, p_analysisName,
                                  p_date, p_tag];

            
            const char *page_sql = pageSql.UTF8String;
            const char *event_sql = eventSql.UTF8String;
            
            // printf("----- %s", event_sql);
            // printf("----- %s", page_sql);
            
            // 创建表
            char *error_msg = NULL;
            res = sqlite3_exec(mgr->_db, event_sql, NULL, NULL, &error_msg);
            if (res != SQLITE_OK) {
                ZYPrintf(@"创建表%@失败, eror:%s", EVENT_T_NAME, error_msg);
            }
            
            res = sqlite3_exec(mgr->_db, page_sql, NULL, NULL, &error_msg);
            if (res != SQLITE_OK) {
                ZYPrintf(@"创建表%@失败, eror:%s", PAGE_T_NAME, error_msg);
            }
            
            [mgr closeDB];
        } else {
            ZYPrintf(@"打开数据库失败");
        }
    });
    return mgr;
}

- (int)openDB {
    NSString *dbPath = [DB_PATH stringByAppendingPathComponent:DB_NAME];
    const char *db_path = dbPath.UTF8String;
    
    // 打开数据库, 如果数据库不存在, 会自动创建数据库
    return sqlite3_open(db_path, &_db);
}

- (void)closeDB {
    sqlite3_close(_db);
}

- (void)saveEventDataWithSessionId:(NSString *)sessionId
                        targetName:(NSString *)targetName
                        actionName:(NSString *)actionName
                         className:(NSString *)className
                       elementPath:(NSString *)elementPath
                      analysisName:(NSString *)analysisName
                              date:(NSString *)date
                         indexPath:(NSString *)indexPath
                          selected:(BOOL)selected
                               tag:(NSInteger)tag {
    if (!indexPath) {
        indexPath = @"";
    }
    NSString *tagString = [NSString stringWithFormat:@"%zd", tag];
    NSString *selectedStr = selected ? @"1" : @"0";
    
    int res = [self openDB];
    if (res == SQLITE_OK) {
        
        // 插入数据
        NSString *eventInsertSql = [NSString stringWithFormat:
                                    @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');"
                                    ,EVENT_T_NAME, p_sessionId,
                                    p_targetName, p_actionName,
                                    p_className, p_elementPath,
                                    p_analysisName, p_date,
                                    p_indexPath, p_selected,
                                    p_tag,
                                    sessionId, targetName,
                                    actionName, className,
                                    elementPath, analysisName,
                                    date, indexPath,
                                    selectedStr, tagString];
        
        const char *event_insert_sql = eventInsertSql.UTF8String;
        char *error_msg = NULL;
        sqlite3_exec(_db, event_insert_sql, NULL, NULL, &error_msg);
        if (error_msg) {
            ZYPrintf(@"插入数据失败: %s", error_msg);
        }
        [self closeDB];
    }
}

- (void)savePageVisitDataWithSessionId:(NSString *)sessionId
                            targetName:(NSString *)targetName
                            actionName:(NSString *)actionName
                             className:(NSString *)className
                           elementPath:(NSString *)elementPath
                          analysisName:(NSString *)analysisName
                                  date:(NSString *)date
                                   tag:(NSInteger)tag {
    
    NSString *tagString = [NSString stringWithFormat:@"%zd", tag];
    
    int res = [self openDB];
    if (res == SQLITE_OK) {
        
        // 插入数据
        NSString *eventInsertSql = [NSString stringWithFormat:
                                    @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@');"
                                    ,PAGE_T_NAME, p_sessionId, p_targetName,
                                    p_actionName, p_className,
                                    p_elementPath, p_analysisName,
                                    p_date, p_tag,
                                    sessionId, targetName,
                                    actionName, className,
                                    elementPath, analysisName,
                                    date, tagString];
        
        const char *event_insert_sql = eventInsertSql.UTF8String;
        char *error_msg = NULL;
        sqlite3_exec(_db, event_insert_sql, NULL, NULL, &error_msg);
        if (error_msg) {
            ZYPrintf(@"插入数据失败: %s", error_msg);
        }
        [self closeDB];
    }
}

- (NSArray *)eventDataArrayWithSessionId:(NSString *)sessionId {
    NSMutableArray *dataArray = @[].mutableCopy;
    
    int res = [self openDB];
    if (res == SQLITE_OK) {
        
        NSString *eventSelectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@';", EVENT_T_NAME, p_sessionId, sessionId];
        const char *event_select_sql = eventSelectSql.UTF8String;
        sqlite3_stmt *stmt = NULL;
        
        // 如果sql 语句没有问题
        if (sqlite3_prepare_v2(_db, event_select_sql, -1, &stmt, NULL) == SQLITE_OK) {
            
            
            // 每调用一次 sqlite3_step 函数, stmt就会指向下一条记录
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                // 取出数据
                // int id = sqlite3_column_int(stmt, 0);
                // const unsigned char *session_id = sqlite3_column_text(stmt, 1);
                const unsigned char *target_name = sqlite3_column_text(stmt, 2);
                const unsigned char *action_name = sqlite3_column_text(stmt, 3);
                const unsigned char *class_name = sqlite3_column_text(stmt, 4);
                const unsigned char *element_path = sqlite3_column_text(stmt, 5);
                const unsigned char *analysis_name = sqlite3_column_text(stmt, 6);
                const unsigned char *date_value = sqlite3_column_text(stmt, 7);
                const unsigned char *index_path = sqlite3_column_text(stmt, 8);
                const unsigned char *selected_value = sqlite3_column_text(stmt, 9);
                const unsigned char *tag_value = sqlite3_column_text(stmt, 10);
                
                NSDictionary *dic
                = @{p_targetName : [NSString stringWithUTF8String:(const char *)target_name],
                    p_actionName : [NSString stringWithUTF8String:(const char *)action_name],
                    p_className : [NSString stringWithUTF8String:(const char *)class_name],
                    p_elementPath : [NSString stringWithUTF8String:(const char *)element_path],
                    p_analysisName : [NSString stringWithUTF8String:(const char *)analysis_name],
                    p_date : [NSString stringWithUTF8String:(const char *)date_value],
                    p_indexPath : [NSString stringWithUTF8String:(const char *)index_path],
                    p_selected : [NSString stringWithUTF8String:(const char *)selected_value],
                    p_tag : [NSString stringWithUTF8String:(const char *)tag_value],};
                ZYPrintf(@"----%@", dic);
                [dataArray addObject:dic];
            }
            
        } else {
            ZYPrintf(@"sql 语句有问题");
        }
        
        [self closeDB];
    }
    return dataArray.copy;
}


- (NSArray *)pageVisitDataArrayWithSessionId:(NSString *)sessionId {
    
    NSMutableArray *dataArray = @[].mutableCopy;
    
    int res = [self openDB];
    if (res == SQLITE_OK) {
        
        NSString *eventSelectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@';", PAGE_T_NAME, p_sessionId, sessionId];
        const char *event_select_sql = eventSelectSql.UTF8String;
        sqlite3_stmt *stmt = NULL;
        
        // 如果sql 语句没有问题
        if (sqlite3_prepare_v2(_db, event_select_sql, -1, &stmt, NULL) == SQLITE_OK) {
            
            
            // 每调用一次 sqlite3_step 函数, stmt就会指向下一条记录
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                // 取出数据
                // int id = sqlite3_column_int(stmt, 0);
                // const unsigned char *session_id = sqlite3_column_text(stmt, 1);
                const unsigned char *target_name = sqlite3_column_text(stmt, 2);
                const unsigned char *action_name = sqlite3_column_text(stmt, 3);
                const unsigned char *class_name = sqlite3_column_text(stmt, 4);
                const unsigned char *element_path = sqlite3_column_text(stmt, 5);
                const unsigned char *analysis_name = sqlite3_column_text(stmt, 6);
                const unsigned char *date_value = sqlite3_column_text(stmt, 7);
                const unsigned char *tag_value = sqlite3_column_text(stmt, 8);
                
                NSDictionary *dic
                = @{p_targetName : [NSString stringWithUTF8String:(const char *)target_name],
                    p_actionName : [NSString stringWithUTF8String:(const char *)action_name],
                    p_className : [NSString stringWithUTF8String:(const char *)class_name],
                    p_elementPath : [NSString stringWithUTF8String:(const char *)element_path],
                    p_analysisName : [NSString stringWithUTF8String:(const char *)analysis_name],
                    p_date : [NSString stringWithUTF8String:(const char *)date_value],
                    p_tag : [NSString stringWithUTF8String:(const char *)tag_value],};
                
                ZYPrintf(@"----%@", dic);
                [dataArray addObject:dic];
            }
        } else {
            ZYPrintf(@"sql 语句有问题");
        }
        
        [self closeDB];
    }
    return dataArray.copy;
}


- (void)cleanEventDataWithSessionId:(NSString *)sessionId {
    int res = [self openDB];
    if (res == SQLITE_OK) {
        
        NSString *eventDeleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@';", EVENT_T_NAME, p_sessionId, sessionId];
        const char *event_delete_sql = eventDeleteSql.UTF8String;
        
        char *error_msg = NULL;
        sqlite3_exec(_db, event_delete_sql, NULL, NULL, &error_msg);
        
        if (error_msg) {
            ZYPrintf(@"删除表:%@ 中数据失败: %s", EVENT_T_NAME, error_msg);
        }
        
        [self closeDB];
    }
}

- (void)cleanPageVisitDataWithSessionId:(NSString *)sessionId {
    int res = [self openDB];
    if (res == SQLITE_OK) {
        
        NSString *pageDeleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@';", PAGE_T_NAME, p_sessionId, sessionId];
        const char *page_delete_sql = pageDeleteSql.UTF8String;
        
        char *error_msg = NULL;
        sqlite3_exec(_db, page_delete_sql, NULL, NULL, &error_msg);
        
        if (error_msg) {
            ZYPrintf(@"删除表:%@ 中数据失败: %s", PAGE_T_NAME, error_msg);
        }
        
        [self closeDB];
    }
}

- (NSArray *)allSessionId {
    NSMutableArray *pageSessionArr = @[].mutableCopy;
    NSMutableArray *eventSessionArr = @[].mutableCopy;
    
    int res = [self openDB];
    if (res == SQLITE_OK) {
        sqlite3_stmt *stmt = NULL;
        
        /// 查询page数据表中的所有sessionid, 去重
        NSString *pageDistinctSql = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@;", p_sessionId, PAGE_T_NAME];
        const char *page_distinct_sql = pageDistinctSql.UTF8String;
        
        // 如果sql 语句没有问题
        if (sqlite3_prepare_v2(_db, page_distinct_sql, -1, &stmt, NULL) == SQLITE_OK) {
            // 每调用一次 sqlite3_step 函数, stmt就会指向下一条记录
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                const unsigned char *session_id = sqlite3_column_text(stmt, 0);
                [pageSessionArr addObject:[NSString stringWithUTF8String:(const char *)session_id]];
            }
        } else {
            ZYPrintf(@"sql 语句有问题");
        }
        
        /// 查询event表中的说有sessionid, 去重
        NSString *eventDistinctSql = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@;", p_sessionId, EVENT_T_NAME];
        const char *event_distinct_sql = eventDistinctSql.UTF8String;
        
        // 如果sql 语句没有问题
        if (sqlite3_prepare_v2(_db, event_distinct_sql, -1, &stmt, NULL) == SQLITE_OK) {
            // 每调用一次 sqlite3_step 函数, stmt就会指向下一条记录
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                const unsigned char *session_id = sqlite3_column_text(stmt, 0);
                [eventSessionArr addObject:[NSString stringWithUTF8String:(const char *)session_id]];
            }
        } else {
            ZYPrintf(@"sql 语句有问题");
        }
        
        // 关闭数据库
        [self closeDB];
    }
    
    // 取并集
    NSMutableSet *pageSet = [NSMutableSet setWithArray:pageSessionArr];
    NSSet *eventSet = [NSSet setWithArray:eventSessionArr];
    [pageSet unionSet:eventSet];
    
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
    NSArray *sortSetArray = [pageSet sortedArrayUsingDescriptors:sortDesc];
    
    return sortSetArray;
}



- (void)uploadCacheData {
    NSArray *allSessionId = [self allSessionId];
    NSString *currentSessionId = [[ZYGlobalInfoHelper shareHelper] sessionId];
    
    for (NSString *sesid in allSessionId) {
        // 本次启动得到的数据不上传
        if ([sesid isEqualToString:currentSessionId]) {
            continue;
        }
        
        NSArray *eventData = [[DataCacheManager shareManager] eventDataArrayWithSessionId:sesid];
        NSArray *pageVisitData = [[DataCacheManager shareManager] pageVisitDataArrayWithSessionId:sesid];
        
        // 如果没有网不上传
        if ([[ZYGlobalInfoHelper shareHelper].deviceNetType isEqualToString:@"0"]) {
            return;
        }
        
        [StatisticalRequest uploadEventInfos:eventData callback:^(NSError * _Nullable error) {
            NSAssert(error == nil, @"网络错误");
            if (!error) {
                [[DataCacheManager shareManager] cleanEventDataWithSessionId:sesid];
            }
        }];
        
        [StatisticalRequest uploadPageVisitInfos:pageVisitData callback:^(NSError * _Nullable error) {
            NSAssert(error == nil, @"网络错误");
            if (!error) {
                [[DataCacheManager shareManager] cleanPageVisitDataWithSessionId:sesid];
            }
        }];
    }
}

@end
