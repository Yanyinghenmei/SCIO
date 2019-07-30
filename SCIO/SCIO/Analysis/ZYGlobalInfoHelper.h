//
//  ZYGlobalInfoHelper.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/24.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYGlobalInfoHelper : NSObject

/**
 iPhone 所有设备获取到的 mac 地址都一样, 这里返回空字符串 @""
 */
+ (NSString *)mac;

/**
 设备唯一标识, 暂时取用idfv, 并且不保存idfv到钥匙链
 参考: https://www.jianshu.com/p/686958c352f1
 */
+ (NSString *)deviceId;


/**
 网络类型
 */
+ (NSString *)deviceNetType;


/**
 移动/网络运营商
 */
+ (NSString *)deviceNetOperator;


/**
 手机系统版本
 */
+ (NSString *)osVersion;

/**
 手机硬件版本, 如: iPhone7,1
 */
+ (NSString *)deviceModel;


/**
 sdk 版本, 暂时为 1.0
 */
+ (NSString *)sdkVersion;


/**
 APP 版本号
 */
+ (NSString *)appVersion;

/**
 bundle id
 */
+ (NSString *)appId;


/**
 app 名称
 */
+ (NSString *)appName;


/**
 APP每次启动代表一次会话,会话id暂时使用启动时的时间戳, 后续可能服务器分配, 或根据服务器时间生成
 */
+ (NSString *)sessionId;
@end

NS_ASSUME_NONNULL_END
