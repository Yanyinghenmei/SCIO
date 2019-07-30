//
//  ZYDefine.h
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/5.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#ifndef ZYDefine_h
#define ZYDefine_h

#ifdef DEBUG// 调试状态, 打开LOG功能
#define ZYLog(...) NSLog(__VA_ARGS__)
#define ZYPrintf(s,...) printf("\n>>> %s\n",[[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else// 发布状态, 关闭LOG功能
#define ZYLog(...)
#define ZYPrintf(...)
#endif


#endif /* ZYDefine_h */
