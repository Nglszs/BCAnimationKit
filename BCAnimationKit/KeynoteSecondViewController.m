//
//  KeynoteSecondViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "KeynoteSecondViewController.h"
#import "KeynoteTransition.h"
@interface KeynoteSecondViewController ()

@end

@implementation KeynoteSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    //这里为了让左划手势有效
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
   UIImageView *_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _headerImageView.backgroundColor = [UIColor lightGrayColor];
    _headerImageView.center = self.view.center;
    _headerImageView.image = _headerImage;
    _ImageV = _headerImageView;
    [self.view addSubview:_headerImageView];
    
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_headerImageView.frame), BCWidth, 50)];
    ll.numberOfLines = 0;
    ll.text = @"这种效果类似于图片浏览的效果，不同的是这里是跳转到下一界面";
    [self.view addSubview:ll];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [[KeynoteTransition new] initWithTransitionType:operation == UINavigationControllerOperationPush ?  MoveTransitionTypePush: MoveTransitionTypePop];
}

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    return nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
