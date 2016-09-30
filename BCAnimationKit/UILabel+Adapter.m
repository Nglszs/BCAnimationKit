//
//  UILabel+Adapter.m
//  BCAnimationKit
//
//  Created by Jack on 16/9/30.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UILabel+Adapter.h"
#import <objc/runtime.h>
@implementation UILabel (Adapter)

+(void)load {
    
    //全局适配字体
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        //获得viewController的生命周期方法的selector
//        SEL systemSel = @selector(willMoveToSuperview:);
//        //自己实现的将要被交换的方法的selector
//        SEL swizzSel = @selector(myWillMoveToSuperview:);
//        //两个方法的Method
//        Method systemMethod = class_getInstanceMethod([self class], systemSel);
//        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
//        
//        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
//        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
//        if (isAdd) {
//            //如果成功，说明类中不存在这个方法的实现
//            //将被交换方法的实现替换到这个并不存在的实现
//            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//        } else {
//            //否则，交换两个方法的实现
//            method_exchangeImplementations(systemMethod, swizzMethod);
//        }
      
        
        
#pragma mark 第二种写法
//        Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//        Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//        method_exchangeImplementations(imp, myImp);
    });
    
    
}

- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    
    [self myWillMoveToSuperview:newSuperview];
    //    if ([self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
    //不改变button的title字体设置的，在这里你可以判断那种类型的改哪种不改，比如说你不想改button的字体，把这一句解注释即可
    //        return;
    //    }
    if (self) {
        if (self.tag == 10086) {
            
                self.font  = [UIFont systemFontOfSize:self.font.pointSize * Multiple];
        }
    }
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize * Multiple];
        }
    }
    return self;
}


@end
