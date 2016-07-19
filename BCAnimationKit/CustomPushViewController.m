//
//  CustomPushViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/18.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CustomPushViewController.h"
#import "PopControllerAnimation.h"
#import "PushControllerAnimation.h"
@interface CustomPushViewController ()<UINavigationControllerDelegate>

@end

@implementation CustomPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //如果需要全局都使用这种动画，最好将下面的代理方法写在appdelegate里面，这里写在vc中，然后退出此界面会调用系统默认的动画
    
    
    self.navigationController.navigationBarHidden = YES;
    
    if (self.navigationController.viewControllers.count == 2) {//这里由于每次都push自身，所以防止代码多次重复添加，跳转其他界面或者写在appdelegate里都不要进行判断
        self.navigationController.delegate = self;
    }
    
    self.view.backgroundColor = RandomColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(push:)];
    [self.view addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, 300)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"head.jpg"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, BCWidth, 30)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击屏幕跳转";
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((BCWidth - 100)/2, BCHeight - 100, 100, 50);
    [button setTitle:@"返回动画" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
- (void)push:(UITapGestureRecognizer *)tap
{
    CustomPushViewController *vc =[[CustomPushViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  push新的动画代理

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [PushControllerAnimation new];
    }
    else if(operation == UINavigationControllerOperationPop)
    {
        return [PopControllerAnimation new];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated {//恢复原样
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count == 1) {
        
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.delegate = nil;
    }

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
