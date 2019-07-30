//
//  MethodSwizzingTool.m
//  OneKeyAnalysis
//
//  Created by sandy on 2018/7/4.
//  Copyright © 2018年 sandy. All rights reserved.
//

#import "MethodSwizzingTool.h"
#import <objc/runtime.h>

@implementation MethodSwizzingTool


+(void)swizzingForClass:(Class)class originalSel:(SEL)originalSelector swizzingSel:(SEL)swizzingSelector
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method  swizzingMethod = class_getInstanceMethod(class, swizzingSelector);
    
    BOOL addMethod = class_addMethod(class,
                                     originalSelector,
                                     method_getImplementation(swizzingMethod),
                                     method_getTypeEncoding(swizzingMethod));
    
    if (addMethod) {
        class_replaceMethod(class,
                            swizzingSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        
        method_exchangeImplementations(originalMethod, swizzingMethod);
    }
}


+(void)swizzingForOriginalClass:(Class)class originalSel:(SEL)originalSelector swizzingClass:(Class)sClass swizzingSel:(SEL)swizzingSelector
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzingMethod = class_getInstanceMethod(sClass, swizzingSelector);
    
    // 如果未实现, 添加方法
    BOOL addMethod = class_addMethod(class,
                                     originalSelector,
                                     method_getImplementation(swizzingMethod),
                                     method_getTypeEncoding(swizzingMethod));
    
    // 如果添加成功, 替换swizzingSelector的实现
    if (addMethod) {
        class_replaceMethod(sClass,
                            swizzingSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        // 如果已经实现, 直接替换
        method_exchangeImplementations(originalMethod, swizzingMethod);
    }
}

+ (BOOL)addMethodForClass:(Class)class sel:(SEL)selector impClass:(Class)iClass impSelector:(SEL)iSelector {
    Method addMethod = class_getInstanceMethod(iClass, iSelector);
    
    BOOL suc = class_addMethod(class,
                               selector,
                               method_getImplementation(addMethod),
                               method_getTypeEncoding(addMethod));
    return suc;
}
    
+ (void)addAssociatedObject:(id)obj key:(const char *)key value:(id)value {
    objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
    
+ (id)associatedValueWithObject:(id)obj key:(const char *)key {
    return objc_getAssociatedObject(obj, key);
}

@end
