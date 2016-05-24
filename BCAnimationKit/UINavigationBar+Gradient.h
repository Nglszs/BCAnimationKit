//
//  UINavigationBar+Gradient.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Gradient)
//分类增加一个属性
@property (nonatomic, strong) UIView *maskView;

- (void)setNavbarBackgroundColor:(UIColor *)color;
- (void)resetNavbarColor;
@end
