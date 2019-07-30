//
//  NSObject+ZYKvcCrash.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/11.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "NSObject+ZYKvcCrash.h"
#import "ZYHeader.h"

@implementation NSObject (ZYKvcCrash)


/**
 注释因为kvc未发现对应key的崩溃
 */
- (id)valueForUndefinedKey:(NSString *)key {
    ZYPrintf(@"SCIO: undefine key :%@", key);
    return nil;
}
@end
