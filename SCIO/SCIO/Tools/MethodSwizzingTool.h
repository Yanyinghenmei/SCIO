//
//  MethodSwizzingTool.h
//  OneKeyAnalysis
//
//  Created by sandy on 2018/7/4.
//  Copyright © 2018年 sandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodSwizzingTool : NSObject

+ (BOOL)addMethodForClass:(Class)class sel:(SEL)selector impClass:(Class)iClass impSelector:(SEL)iSelector;

+ (void)swizzingForClass:(Class)cls originalSel:(SEL)originalSelector swizzingSel:(SEL)swizzingSelector;

+ (void)swizzingForOriginalClass:(Class)cls originalSel:(SEL)originalSelector swizzingClass:(Class)sClass swizzingSel:(SEL)swizzingSelector;
    
    
+ (void)addAssociatedObject:(id)obj key:(const char *)key value:(id)value;
+ (id)associatedValueWithObject:(id)obj key:(const char *)key;
@end
