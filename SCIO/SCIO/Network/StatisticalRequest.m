//
//  StatisticalRequest.m
//  ZYDataCollectionDemo
//
//  Created by cn on 2019/7/18.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import "StatisticalRequest.h"
#import "ZYHeader.h"
#import "ZYGlobalInfoHelper.h"

//@interface StatisticalRequest()<NSURLSessionDelegate>
//
//@end
#define BASE_API @"http://47.94.15.141:9099/index.php"

@implementation StatisticalRequest
+ (NSURLSession *)shared {
    static NSURLSession *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
        configuration.timeoutIntervalForRequest = 10;
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        instance = [NSURLSession sessionWithConfiguration:configuration];
    });
    return instance;
}

+ (void)postUploadStatisticsWithUrlString:(NSString *)urlString params:(NSDictionary *)params completionHandler:(void(^)(NSDictionary *data))completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPMethod = @"POST";
    
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *jsonStr = [self transformationToJsonString:params];
    request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [[StatisticalRequest shared] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            ZYPrintf(@"请求成功:\n%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(dataDict);
            });
        } else {
            ZYPrintf(@"请求错误:\n%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(@{@"error":error});
            });
        }
    }];
    [dataTask resume];
}

+ (void)getUploadStatisticsWithUrlString:(NSString *)urlString params:(NSDictionary *)params completionHandler:(void(^)(NSDictionary *data))completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableString *paramsStr = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [paramsStr appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
    }];
    if (paramsStr.length) [paramsStr deleteCharactersInRange:NSMakeRange(paramsStr.length-1, 1)];
    request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",urlString,paramsStr]];
    
    NSURLSessionDataTask *dataTask = [[StatisticalRequest shared] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功:\n%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(dataDict);
            });
        } else {
            NSLog(@"请求错误:\n%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(@{@"error":error});
            });
        }
    }];
    [dataTask resume];
}



+ (void)uploadBaseInfo {
    NSDictionary *info = @{p_deviceId : [ZYGlobalInfoHelper deviceId],
                          p_deviceType : @"iphone",
                          p_deviceModel : [ZYGlobalInfoHelper deviceModel],
                          p_osType : @"iOS",
                          p_osVersion : [ZYGlobalInfoHelper osVersion],
                          p_appName : [ZYGlobalInfoHelper appName],
                          p_appId : [ZYGlobalInfoHelper appId],
                          p_appVersion : [ZYGlobalInfoHelper appVersion],
                          p_deviceNetType : [ZYGlobalInfoHelper deviceNetType],
                          p_deviceNetOperator : [ZYGlobalInfoHelper deviceNetOperator],
                          p_sdkVersion : [ZYGlobalInfoHelper sdkVersion],
                          };

    NSDictionary *dic = @{p_deviceId : [ZYGlobalInfoHelper deviceId],
                          p_type : p_type_deviceData,
                          p_sessionId : [ZYGlobalInfoHelper sessionId],
                          p_data : info,
                           };
    
    [self postUploadStatisticsWithUrlString:BASE_API params:dic completionHandler:^(NSDictionary * _Nonnull data) {
        ZYPrintf(@"%@",data);
    }];
}

+ (void)uploadEventInfos:(NSArray *)infos {
    NSDictionary *dic = @{p_deviceId : [ZYGlobalInfoHelper deviceId],
                          p_type : p_type_eventData,
                          p_sessionId : [ZYGlobalInfoHelper sessionId],
                          p_data : infos,};
    [self postUploadStatisticsWithUrlString:BASE_API params:dic completionHandler:^(NSDictionary * _Nonnull data) {
        ZYPrintf(@"%@",data);
    }];
}

+ (void)uploadPageVisitInfos:(NSArray *)infos {
    NSDictionary *dic = @{p_deviceId : [ZYGlobalInfoHelper deviceId],
                          p_type : p_type_pageData,
                          p_sessionId : [ZYGlobalInfoHelper sessionId],
                          p_data : infos,};
    [self postUploadStatisticsWithUrlString:BASE_API params:dic completionHandler:^(NSDictionary * _Nonnull data) {
        ZYPrintf(@"%@",data);
    }];
}

/**
 后台通过日志的方式记录数据, 所以也没有请求反馈
 */
+ (void)temporaryUploadRequestWithDataString:(NSString *)string {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://47.94.15.141:9099/index.htm",string]];
    
    NSURLSessionDataTask *dataTask = [[StatisticalRequest shared] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) NSLog(@"%@", error);
    }];
    [dataTask resume];
}


+ (NSString *)transformationToJsonString:(id)transition{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:transition
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}
@end
