//
//  NSArray+check.m
//  BCAnimationKit
//
//  Created by Jack on 16/8/29.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "NSArray+check.h"
#import <objc/runtime.h>
@implementation NSArray (check)

//这个方法在有键盘的见面按home键会出现crash，所以可以使用其他方法
+ (void)load{
    //不可变数组
    Method originArrayIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
    Method newArrayIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(kpObjectAtIndex:));
    if(originArrayIndex&&newArrayIndex){
      //  method_exchangeImplementations(originArrayIndex, newArrayIndex);
    }
    
    //可变数组
    Method originMutableArrayIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
    Method newMutableArrayIndex = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(kpObjectAtIndexM:));
    if(originMutableArrayIndex&&newMutableArrayIndex){
      //  method_exchangeImplementations(originMutableArrayIndex, newMutableArrayIndex);
    }
    
}

- (id)kpObjectAtIndex:(NSUInteger)index{
    
    if(index >= self.count){
        NSLog(@"ERROR:不可变数组取值index:%ld 越界",index);
        return nil;
    }else{
        return [self kpObjectAtIndex:index];
    }
}

- (id)kpObjectAtIndexM:(NSUInteger)index{
    if (index<self.count) {
        return [self kpObjectAtIndexM:index];
    }
    NSLog(@"ERROR:可变数组取值index:%ld越界",index);
    return nil;
}


@end
