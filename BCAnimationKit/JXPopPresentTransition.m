//
//  JXPopPresentedTransition.m
//  JXNavigationTransition
//
//  Created by jiaxin on 15/12/2.
//  Copyright © 2015年 jiaxin. All rights reserved.
//

#import "JXPopPresentTransition.h"

@interface JXPopPresentTransition ()

@property (nonatomic, assign) JXPopPresentTransitionType type;

@end

@implementation JXPopPresentTransition

+ (instancetype)transitionWithTransitionType:(JXPopPresentTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(JXPopPresentTransitionType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type) {
        case JXPopPresentTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case JXPopPresentTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
        default:
            break;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //这里的fromVC是navigationcontroller!!!
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //containerView用来添加将要显示的东西，fromVC不用添加，如果添加了，dismiss的时候会被移除掉
    UIView *containerView = [transitionContext containerView];
    
  
   [containerView addSubview:toVC.view];
    toVC.view.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(containerView.frame), 300);
    
    
    fromVC.view.layer.zPosition = -400;
    toVC.view.layer.zPosition = 400;
    
    [UIView animateWithDuration:.25 animations:^{//先倾斜在缩小
        CATransform3D t1 = CATransform3DIdentity;
        t1.m34 = 1.0/-900;
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
        t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
        fromVC.view.layer.transform = t1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.25 animations:^{
            CATransform3D t2 = CATransform3DIdentity;
            t2.m34 = 1.0/-900;
            t2 = CATransform3DTranslate(t2, 0, -fromVC.view.frame.size.height * 0.08, 0);
            t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
            fromVC.view.layer.transform = t2;
            
        }];
        
    }];
    

    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
          
        
              toVC.view.transform = CGAffineTransformMakeTranslation(0, -300);
        
        
                     }
                     completion:^(BOOL finished) {
                         //如果要可交互，就必须要判断是否cancelled，cancelled之后就进行复原操作
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
    
    
    [UIView animateWithDuration:0.25 animations:^{//底部vc回复原状
        CATransform3D t1 = CATransform3DIdentity;
        t1.m34 = 1.0/-900;
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
        t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
        toVC.view.layer.transform = t1;
        
        
    } completion:^(BOOL finished){
        
        
        [UIView animateWithDuration:.25 animations:^{
            
            toVC.view.layer.transform = CATransform3DIdentity;
            
            
            
        }];
    }];

    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                       
                         fromVC.view.transform  = CGAffineTransformIdentity;
                        
                     }
                     completion:^(BOOL finished) {
                        // 如果要可交互，也要判断，成功之后也要去除多余的控件
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         
                     }];
}

@end






