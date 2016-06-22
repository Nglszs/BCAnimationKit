//
//  UINavigationBar+Gradient.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UINavigationBar+Gradient.h"
#import <objc/runtime.h>
@implementation UINavigationBar (Gradient)

static void *maskKey = &maskKey;

- (UIView *)maskView {



    return objc_getAssociatedObject(self, &maskKey);

}


- (void)setMaskView:(UIView *)maskView {


    objc_setAssociatedObject(self, &maskKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);



}

- (void)setNavbarBackgroundColor:(UIColor *)color {


    if (!self.maskView) {
        
        //下面这两句让导航栏透明，这样就可以看见maskview的颜色了
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        
        
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        
        self.maskView.userInteractionEnabled = NO;
        [self insertSubview:self.maskView atIndex:0];
        
    }


    self.maskView.backgroundColor = color;

}

//当退出时，重置导航栏

- (void)resetNavbarColor {
    
    //让导航栏恢复原样
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    [self.maskView removeFromSuperview];
    self.maskView = nil;


}

@end
