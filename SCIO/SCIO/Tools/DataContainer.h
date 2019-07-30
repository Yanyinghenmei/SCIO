//
//  DataContainer.h
//  OneKeyAnalysis
//
//  Created by sandy on 2018/7/19.
//  Copyright © 2018年 sandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataContainer : NSObject

@property(nonatomic,strong)NSDictionary * data;


/**
 数据缓存处理单例

 @return 单例
 */
+(instancetype)dataInstance;

@end
