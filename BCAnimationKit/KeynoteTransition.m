//
//  KeynoteTransition.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "KeynoteTransition.h"
#import "KeynoteViewController.h"
#import "KeynoteSecondViewController.h"
@implementation KeynoteTransition

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

    KeynoteSecondViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    KeynoteViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
 NSArray *imageArr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];

    //获取cell上的imageview
    
    UITableViewCell *cell = [fromViewController.testTableView cellForRowAtIndexPath:fromViewController.clickIndexPath];
    
    UIImageView *cellImageV = [cell.contentView viewWithTag:100];
    
    
    //过渡用的imageview
    UIImageView *transitionImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[fromViewController.clickIndexPath.row%3]]]];

    transitionImageV.frame = [cellImageV convertRect:cellImageV.bounds toView:[transitionContext containerView]];
    [[transitionContext containerView] addSubview:transitionImageV];
    
    //动画开始
    cellImageV.hidden = YES;
    toViewController.view.alpha = 0;
    toViewController.ImageV.hidden = YES;
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
        transitionImageV.frame = [toViewController.ImageV convertRect:toViewController.ImageV.bounds toView:[transitionContext containerView]];
        toViewController.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        toViewController.ImageV.hidden = NO;
        transitionImageV.hidden = YES;

    }];
    
}


- (void)transitionPop:(id<UIViewControllerContextTransitioning>)transitionContext {
    KeynoteSecondViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    KeynoteViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
     //containerView会自动把当前环境的fromVC.view添加到index为0的位置，所以push或者pop的时候要把toVC.view添加到合适的层级
    UIView *containerView = [transitionContext containerView];
    
    
    //获取cell上的imageview
    
    UITableViewCell *cell = [toViewController.testTableView cellForRowAtIndexPath:toViewController.clickIndexPath];
    
    UIImageView *cellImageV = [cell.contentView viewWithTag:100];
    
    //获取过渡的imagev
      UIImageView *imageView = [containerView.subviews lastObject];
    
    //动画
    fromViewController.ImageV.hidden = YES;
    cellImageV.hidden = YES;
    imageView.hidden = NO;
    //toVC一定要添加到最底层，否则会遮盖imageView，而且在手势交互失败的时候，containerView会自动移除它
    [containerView insertSubview:toViewController.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromViewController.view.alpha = 0;
        imageView.frame = [cellImageV convertRect:cellImageV.bounds toView:containerView];
        
    }completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            imageView.hidden = YES;
            fromViewController.ImageV.hidden = NO;
        }else {
            [transitionContext completeTransition:YES];
            cellImageV.hidden = NO;
            [imageView removeFromSuperview];
        }
    }];

}
@end
