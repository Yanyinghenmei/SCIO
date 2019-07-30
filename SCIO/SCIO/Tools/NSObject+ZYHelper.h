//
//  NSObject+ZYHelper.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/6.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZYHelper)


/**
 //判断页面是否实现了某个sel

 @param sel SEL 对象
 @param class 类名
 @return true:已实现, false:未实现
 */
- (BOOL)isContainSel:(SEL)sel inClass:(Class)class;
@end

NS_ASSUME_NONNULL_END
