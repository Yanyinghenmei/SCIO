//
//  ParameterConfig.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/22.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#ifndef ParameterConfig_h
#define ParameterConfig_h


#endif /* ParameterConfig_h */

// 事件/统计 信息
static NSString *p_className = @"cname";                // 类名
static NSString *p_date = @"date";                      // 触发时间
static NSString *p_elementPath = @"epath";              // 视图元素路径
static NSString *p_tag = @"tag";                        // 视图标号/视图id
static NSString *p_targetActionMap = @"tam";            // target-action 映射数组
static NSString *p_targetAction = @"ta";                // target-action 映射
static NSString *p_actionName = @"aname";               // 方法名/函数名
static NSString *p_analysisName = @"alname";            // 分析行为命名
static NSString *p_targetName = @"tname";               // 方法/函数 所在的类名
static NSString *p_selected = @"sele";                  // 视图选中状态
static NSString *p_indexPath = @"idxp";                 // 标号
static NSString *p_customAnalysisName = @"cusan";       // 自定义分析行为名称

// sdk/app 信息
static NSString *p_sdkVersion = @"sdkv";                // sdk 版本号
static NSString *p_appVersion = @"appv";                // app 版本号
static NSString *p_appLanguage = @"appl";               // app 语言
static NSString *p_appName = @"appn";                   // APP 名称
static NSString *p_appId = @"aid";                      // APP id
static NSString *p_teamId = @"tid";                     // team id
static NSString *p_teamName = @"tname";                 // team name

// 设备信息
static NSString *p_mac = @"mac";                        // mac address
static NSString *p_deviceId = @"devid";                 // 设备唯一标识
static NSString *p_deviceType = @"devt";                // 设备类型 --- pc mac iphone android
static NSString *p_deviceModel = @"devm";               // 设备型号 --- 例如 "iPhone9,1" 就是 iPhone 7
static NSString *p_deviceFacture = @"devf";             // 厂家 --- Apple Samsung
static NSString *p_deviceNetType = @"dnt";              // 网络类型，0代表无网络，1代表Wifi，2手机流量(WWAN), 3其他 (iOS只有WiFi, WWAN, 无网络三种)
static NSString *p_deviceNetOperator = @"dno";          // 网络运营商，1代表中国移动，2代表中国联通，3代表中国电信，4代表未知
static NSString *p_osType = @"ost";                     // 操作系统
static NSString *p_osVersion = @"osv";                  // 系统版本

// 用户信息
static NSString *p_userId = @"uid";                     // 用户id
static NSString *p_userName = @"uname";                 // 用户名
static NSString *p_userPhoneNumber = @"upn";            // 用户手机号
static NSString *p_userSex = @"usex";                   // 用户性别
static NSString *p_userAge = @"uage";                   // 用户年龄
static NSString *p_longitude = @"lon";                  // 经度
static NSString *p_latitude = @"lat";                   // 纬度

// 其他
static NSString *p_accessModule = @"asm";               // 访问模块
static NSString *p_accessFunction = @"asf";             // 访问功能


/// 数据包装
static NSString *p_sessionId = @"sesid";                // 每次启动APP为一次回话, 分配一个sessionid, 暂时使用时间戳
static NSString *p_data = @"da";                        // da=(), da永远都是数组, 单条数据的key-value 也放在数组中 ({key:value})
static NSString *p_type = @"ty";                        // 判断上传的数据来源

/// type的取值
static NSString *p_type_deviceData = @"tydev";          // ty 的值, 代表上传基本信息
static NSString *p_type_eventData = @"tyeve";           // ty 的值, 代表上传事件信息
static NSString *p_type_pageData = @"typag";            // ty 的值, 代表上传页面访问信息

/// 数据示例

/*
 {
 da = (
 {
 alname = ZYVisualSelectorController;
 aname = "viewWillAppear:";
 cname = ZYVisualSelectorController;
 date = 1564385303;
 epath = "ZYVisualSelectorController/ZYVisualSelectorView";
 tag = 0;
 tname = ZYVisualSelectorController;
 }
 );
 devid = "D02B904E-4BA3-412E-936E-E2EA2EB338C6";
 sesid = "1564385303.385244";
 ty = tyeve;
 }
 */
