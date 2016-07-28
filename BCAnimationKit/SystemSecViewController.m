//
//  SystemSecViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SystemSecViewController.h"
#import "SystemPushTranistion.h"
@interface SystemSecViewController ()

@end

@implementation SystemSecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
 
}
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [[SystemPushTranistion new] initWithTransitionType:operation == UINavigationControllerOperationPush ?  MoveTransitionTypePush: MoveTransitionTypePop];
}


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
