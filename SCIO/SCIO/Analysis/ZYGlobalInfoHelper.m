//
//  ZYGlobalInfoHelper.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/24.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import "ZYGlobalInfoHelper.h"
#import "Reachability.h"
#import <sys/sysctl.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static ZYGlobalInfoHelper *_helper = nil;

@interface ZYGlobalInfoHelper ()
@property (nonatomic,strong) Reachability *hostReach;
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,assign) NetworkStatus status;
@end

@implementation ZYGlobalInfoHelper

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [ZYGlobalInfoHelper new];
        
        [[NSNotificationCenter defaultCenter] addObserver:_helper selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        _helper.status = NotReachable;
        _helper.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [_helper.hostReach startNotifier];
    });
    return _helper;
}
    // kReachabilityChangedNotification observer
-(void)reachabilityChanged:(NSNotification *)note {
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    _status = [currReach currentReachabilityStatus];
}

- (NSString *)mac {
    return @"iOS设备无法获取正确的 Mac address";
}

- (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)osVersion {
    return [NSString stringWithFormat:@"iOS %.2f",[[[UIDevice currentDevice] systemVersion]   floatValue]];
}

- (NSString *)deviceModel {
    
    // Gets a string with the device model
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

- (NSString *)deviceNetType {
    return [NSString stringWithFormat:@"%zd",_status];
}

- (NSString *)deviceNetOperator {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    //当前手机所属运营商名称
    NSString *mobile;
    
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (carrier.isoCountryCode) {
        mobile = [carrier carrierName];
        if ([mobile isEqualToString:@"中国移动"]) {
            return @"1";
        } else if ([mobile isEqualToString:@"中国联通"]) {
            return @"2";
        } else if ([mobile isEqualToString:@"中国电信"]) {
            return @"3";
        }
    }
    return @"4";
}


- (NSString *)sdkVersion {
    return @"1.0";
}

- (NSString *)appVersion {
    // framework 中获取版本号的方法可能会变化, 到时候再说吧
    // app版本
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)appId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

- (NSString *)appName {
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (!name) {
        name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    return name;
}


- (NSString *)sessionId {
    if (!_sessionId) {
        _sessionId = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    }
    return _sessionId;
}

- (void)clearCurrentSessionId {
    _sessionId = nil;
}

- (NSString *)teamId {
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    // 读取application-identifier  注意描述文件的编码要使用:NSASCIIStringEncoding
    NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
    NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i < embeddedProvisioningLines.count; i++) {
        if ([embeddedProvisioningLines[i] rangeOfString:@"com.apple.developer.team-identifier"].location != NSNotFound) {
            NSString *tid = [self valueWithXmlString:embeddedProvisioningLines[i+1]];
            if (tid) {
                return tid;
            }
        }
    }
    return @"";
}

- (NSString *)teamName {
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    // 读取application-identifier  注意描述文件的编码要使用:NSASCIIStringEncoding
    NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
    NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i < embeddedProvisioningLines.count; i++) {
        if ([embeddedProvisioningLines[i] rangeOfString:@"TeamName"].location != NSNotFound) {
            NSString *tname = [self valueWithXmlString:embeddedProvisioningLines[i+1]];
            if (tname) {
                return tname;
            }
        }
    }
    return @"";
}

- (NSString *)valueWithXmlString:(NSString *)str {
    NSInteger fromPosition = [str rangeOfString:@"<string>"].location+8;
    
    NSInteger toPosition = [str rangeOfString:@"</string>"].location;
    
    NSRange range;
    range.location = fromPosition;
    range.length = toPosition - fromPosition;
    
    return [str substringWithRange:range];
}

@end






/*
 //    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1";
 //
 //    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3";
 //
 //    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
 //
 //    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
 //
 //    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
 //
 //    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
 //
 //    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
 //
 //    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
 //
 //    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
 //
 //    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
 //
 //    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
 //
 //    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
 //
 //    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
 //
 //    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";
 //
 //    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 Plus";
 //
 //    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
 //
 //    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
 //
 //    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
 //
 //    if ([platform isEqualToString:@"iPhone9,1"] || [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
 //
 //    if ([platform isEqualToString:@"iPhone9,2"] || [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
 //
 //    if ([platform isEqualToString:@"iPhone10,1"] || [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
 //
 //    if ([platform isEqualToString:@"iPhone10,2"] || [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
 //
 //    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
 //
 //    // iPot Touch======
 //
 //    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch";
 //
 //    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2";
 //
 //    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3";
 //
 //    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4";
 //
 //    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5";
 //
 //    // iPad======
 //
 //    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
 //
 //    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
 //
 //    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
 //
 //    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
 //
 //    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
 //
 //    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1";
 //
 //    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1";
 //
 //    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1";
 //
 //    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
 //
 //    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
 //
 //    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
 //
 //    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
 //
 //    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
 //
 //    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
 //
 //    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad air";
 //
 //    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad air";
 //
 //    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad air";
 //
 //    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2";
 //
 //    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2";
 //
 //    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
 //
 //    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3";
 //
 //    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3";
 //
 //    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
 //
 //    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad air 2";
 //
 //    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad air 2";
 //
 //    // 模拟器======
 //
 //    if ([platform isEqualToString:@"iPhone Simulator"] || [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
 //
 //    return @"型号未知";

 */
