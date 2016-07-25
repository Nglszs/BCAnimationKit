//
//  UIButton+Common.h
//  BCAnimationKit
//
//  Created by Jack on 16/7/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Common)

/**
 设置按钮不同状态下的背景图片
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 给按钮添加加载动画
 */
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGRect reactRect;//用来保存原始按钮的frame
- (void)addLoadingAnimation;


/**
 避免重复点击，如果需要所有的按钮都需要避免重复点击，那就写在+load方法种，否则单独写成一个方法，这里写成一个方法
 */

- (void)avoidClick;
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;//点击事件间隔
@property (nonatomic, assign) NSTimeInterval acceptEventTime;//用来计算时间的过渡量
@end
