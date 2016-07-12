//
//  UIViewController+Test.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/2.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UIViewController+Test.h"
#import "NightModelViewController.h"
#import <objc/runtime.h>
@implementation UIViewController (Test)


+ (void)load {

    //方法交换
    Method imp = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    Method imp1 = class_getInstanceMethod(self, @selector(whichView));
    
    method_exchangeImplementations(imp, imp1);

  
   
}




//这个用来实现监听那个界面浏览量,没打开一个界面将当前界面的信息上传服务器，也可以卸载baseviewcontroller里
- (void)whichView {

   // NSLog(@"当前的页面%@",NSStringFromClass([self class]));
    
    if ([NSStringFromClass([self class]) isEqualToString:@"NavbarGradientViewController"]) {
        
        
            NSLog(@"又进导航栏渐变界面了是吧");
    }
    
    [self whichView];




}


@end
