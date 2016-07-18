//
//  CustomPresentViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/18.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CustomPresentViewController.h"
#import "PresentSecondViewController.h"
#import "FYLoginTranslation.h"

@interface CustomPresentViewController ()<UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) FYLoginTranslation* login;
@property (strong, nonatomic) UIButton* btn;
@end

@implementation CustomPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.btn.center = self.view.center;
    [_btn setTitle:@"登录" forState:UIControlStateNormal];
    _btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btn];
    [_btn addTarget:self action:@selector(presentSecond) forControlEvents:UIControlEventTouchUpInside];

}

- (void)presentSecond {
    PresentSecondViewController *second = [[PresentSecondViewController alloc] init];
    second.transitioningDelegate = self;
    [self presentViewController:second animated:YES completion:nil];
    
    
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
     [self.login stopAnimation];
    
});
    
}
- (FYLoginTranslation *)login
{
    if (!_login) {
        _login = [[FYLoginTranslation alloc] initWithView:self.btn];
    }
    return _login;
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.login.reverse = YES;
    return self.login;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.login.reverse = NO;
    return self.login;
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
