//
//  NSString+YMSafe.m
//  YunMuFocus
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "NSString+YMSafe.h"
#import <objc/runtime.h>
@implementation NSString (YMSafe)
#pragma mark Class Method

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzedMethod:@selector(hasSuffix:) withMethod:@selector(crashGuard_hasSuffix:)];
        [[self class] swizzedMethod:@selector(hasPrefix:) withMethod:@selector(crashGuard_hasPrefix:)];
    });
}

+(void)swizzedMethod:(SEL)originalSelector withMethod:(SEL )swizzledSelector {
    
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSCFConstantString"), originalSelector);
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSCFConstantString"), swizzledSelector);
    method_exchangeImplementations(fromMethod, toMethod);
}

#pragma mark Swizzled Method

-(BOOL)crashGuard_hasSuffix:(NSString *)str {
    if(!str){
        // 打印崩溃信息，栈信息 等
        NSLog(@"selector \"hasSuffix\" crash for the the suffix is nil!");
        return NO;
    } else {
        return [self crashGuard_hasSuffix:str];
    }
}

- (BOOL)crashGuard_hasPrefix:(NSString *)str {
    if(!str){
        // 打印崩溃信息，栈信息 等
        NSLog(@"selector \"hasPrefix\" crash for the the prefix is nil!");
        return NO;
    } else {
        return [self crashGuard_hasPrefix:str];
    }
}
@end
