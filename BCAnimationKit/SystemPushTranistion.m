//
//  SystemPushTranistion.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SystemPushTranistion.h"

@implementation SystemPushTranistion
- (instancetype)initWithTransitionType:(AnimationType)type {
    
    if (self = [super init]) {
        
        self.transitionType = type;
    }
    return self;
}

//设置动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    return .5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    switch (self.transitionType) {
        case 0:
            [self transitionPush:transitionContext];
            break;
            
        default:
            [self transitionPop:transitionContext];
            break;
    }
    
    
    
}

//这个交互只适合某两个界面，不适合其他界面，因为这里的tovc和fromvc是要写死的
- (void)transitionPush:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //这里设置是从右到左，也可以自己设置各个方向，这里只写出一种
    CGRect rect0 = CGRectMake( screenWidth, 0, screenWidth, screenHeight);
    CGRect rect1 = CGRectMake(0, 0, screenWidth, screenHeight);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRect:rect0];
    UIBezierPath *endPath =[UIBezierPath bezierPathWithRect:rect1];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath; //动画结束后的值
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id)((endPath.CGPath));
    animation.duration = 1;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:animation forKey:@"NextPath"];
    
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    switch (self.transitionType) {
        case 0:
        {
            
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
            [transitionContext viewForKey:UITransitionContextToViewKey].layer.mask = nil;
            
        }
            break;
            
        default:
        {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            
            [transitionContext completeTransition:YES];
            
            
        }
            
            break;
    }
    
    
}

- (void)transitionPop:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    [[transitionContext containerView] insertSubview:toVC.view atIndex:0];//这句话千万不能少
    
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rect0 = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    CGRect rect1 = CGRectMake(0, 0, screenWidth, screenHeight);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRect:rect0];
    UIBezierPath *endPath =[UIBezierPath bezierPathWithRect:rect1];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    fromVC.view.layer.mask = maskLayer;
    maskLayer.path = startPath.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id)(endPath.CGPath);
    animation.toValue = (__bridge id)((startPath.CGPath));
    animation.duration = .5;
    animation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:animation forKey:@"BackPath"];
    
    
}

@end
