//
//  UIView+hehe.m
//  hehe
//
//  Created by Jack on 16/9/30.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UIView+hehe.h"
#import <objc/runtime.h>

@implementation UIView (hehe)


+(void)load {
//这里为了设配屏幕
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        
        Method systemMethod = class_getInstanceMethod(self,systemSel);
        
        Method swizzMethod = class_getInstanceMethod(self,swizzSel);
        
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
       
//        if (isAdd) {
//            //如果成功，说明类中不存在这个方法的实现
//            //将被交换方法的实现替换到这个并不存在的实现
//            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//        } else {
//            //否则，交换两个方法的实现
//            method_exchangeImplementations(systemMethod, swizzMethod);
//        }
    });

   

}

- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    
    [self myWillMoveToSuperview:newSuperview];
    
    
    if (self) {
        if (self.tag == 100) {//这里限定适配view的条件，根据自己的需求
            CGRect rect = self.frame;
           
            self.frame = CGRectMake(rect.origin.x * Multiple, rect.origin.y *Multiple , rect.size.width == BCWidth?BCWidth:rect.size.width* Multiple, rect.size.height== BCHeight?BCHeight:rect.size.height *Multiple);
            
        }
    }
}
@end
