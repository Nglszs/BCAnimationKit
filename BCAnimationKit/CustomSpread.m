//
//  CustomSpread.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CustomSpread.h"
#import "TransformViewController.h"
#import "SecondViewController.h"
@implementation CustomSpread
- (instancetype)initWithTransitionType:(AnimationType)type {
    
    if (self = [super init]) {
        
        self.transitionType = type;
    }
    return self;
}

//设置动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    return 1.f;
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


- (void)transitionPush:(id<UIViewControllerContextTransitioning>)transitionContext {

    
    //如果这里的viewcontroller写成某一类的话，那他支队某一类有效，参见keynote动画
    SecondViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
       [[transitionContext containerView] addSubview:toViewController.view];

    //动画放大的点CGRectMake(BCWidth - 10, 10, 10, 10),这是左上角
    CGRect testRect = CGRectMake(BCWidth/2, BCHeight/2, 10, 10);//这个以中心点
    
//    CGRect tempRect = CGRectInset(testRect, -1000, -1000);
//    CGPathRef startPath = CGPathCreateWithEllipseInRect(tempRect, NULL);
//    CGPathRef endPath   = CGPathCreateWithEllipseInRect(testRect, NULL);
//    
//    CAShapeLayer *showLayer = [CAShapeLayer layer];
//    showLayer.path = startPath;
//    toViewController.view.layer.mask = showLayer;
//    
//    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//    pingAnimation.fromValue = (__bridge id)(endPath);
//    pingAnimation.toValue  = (__bridge id)(startPath);
//    pingAnimation.duration  = 1;
//    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pingAnimation.delegate = self;
//    [pingAnimation setValue:transitionContext forKey:@"animate1"];
//    [showLayer addAnimation:pingAnimation forKey:@"BackPath"];
//    
//    CGPathRelease(startPath);
//    CGPathRelease(endPath);

    CGPoint clickedPoint = testRect.origin;
    CGRect rect = CGRectMake(clickedPoint.x - 3, clickedPoint.y - 3, 6, 6);
    //因为用户点击的位置随意，所以暴力将展开的圆的半径设置为800
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedPoint.x - 800, clickedPoint.y - 800, 1600, 1600) cornerRadius:800];
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3];
    //把layer的path设置end状态的path，这也是动画结束时候的状态
    layer.path = endPath.CGPath;
    toViewController.view.layer.mask = layer;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleAnimation.fromValue = (__bridge id)(path.CGPath);
    circleAnimation.toValue = (__bridge id)(endPath.CGPath);
    circleAnimation.duration = [self transitionDuration:transitionContext];
    circleAnimation.delegate = self;
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [circleAnimation setValue:transitionContext forKey:@"transitionContext"];
    [layer addAnimation:circleAnimation forKey:@"circle"];
    
}

- (void)transitionPop:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    SecondViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    TransformViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
     [[transitionContext containerView] insertSubview:toViewController.view atIndex:0];//这句话千万不能少
    CGRect testRect = CGRectMake(BCWidth/2, BCHeight/2, 10, 10);//这个以中心点
    
    
    //下面动画有两种方式，貌似后者性能更好，这里先用后面的
    
    
//    CGRect tempRect = CGRectInset(testRect, -600, -600);
//        CGPathRef startPath;
//        CGPathRef endPath;
//    
//    
//        startPath = CGPathCreateWithEllipseInRect(tempRect, NULL);
//        endPath = CGPathCreateWithEllipseInRect(testRect, NULL);
//    
//        CAShapeLayer *showLayer = [CAShapeLayer layer];
//        showLayer.path = endPath;
//        fromViewController.view.layer.mask = showLayer;
//        CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//        pingAnimation.fromValue = (__bridge id)(startPath);
//        pingAnimation.toValue  = (__bridge id)(endPath);
//        pingAnimation.delegate = self;
//        pingAnimation.duration  = 1;
//        pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        [pingAnimation setValue:transitionContext forKey:@"animate2"];
//        [showLayer addAnimation:pingAnimation forKey:@"StartPath"];
//        
//        CGPathRelease(startPath);
//        CGPathRelease(endPath);
    
    CGPoint clickedPoint = testRect.origin;
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedPoint.x - 800, clickedPoint.y - 800, 1600, 1600) cornerRadius:800];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedPoint.x - 3, clickedPoint.y - 3, 6, 6) cornerRadius:3];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = endPath.CGPath;
    fromViewController.view.layer.mask = layer;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleAnimation.delegate = self;
    circleAnimation.fromValue = (__bridge id)(startPath.CGPath);
    circleAnimation.toValue = (__bridge id)(endPath.CGPath);
    circleAnimation.duration = [self transitionDuration:transitionContext];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [circleAnimation setValue:transitionContext forKey:@"transitionContext"];
    [layer addAnimation:circleAnimation forKey:@"circleDismiss"];


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

@end
