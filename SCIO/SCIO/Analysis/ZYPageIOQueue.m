//
//  ZYPageIOQueue.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/7/22.
//  Copyright © 2019 Daniel Chuang. All rights reserved.
//

#import "ZYPageIOQueue.h"

@interface ZYPageIOQueue ()
@property (nonatomic,strong) NSMutableArray *queueArray;
@end

@implementation ZYPageIOQueue

+ (instancetype)shareQueue {
    static ZYPageIOQueue * instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [ZYPageIOQueue new];
    });
    return instacne;
}

- (NSMutableArray *)queueArray {
    if (!_queueArray) {
        _queueArray = @[].mutableCopy;
    }
    return _queueArray;
}

- (BOOL)addPageInfo:(NSDictionary *)info {
    if (self.queueArray.count > 30) {
        return false;
    }
    [self.queueArray addObject:info];
    return true;
}

- (NSArray *)pageInfoArray {
    return self.queueArray.copy;
}

@end
