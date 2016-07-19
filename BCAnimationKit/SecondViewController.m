//
//  SecondViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/2.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomSpread.h"
@interface SecondViewController ()
{

CGRect testRect;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     testRect = CGRectMake(BCWidth - 10, 10, 10, 10);
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.frame];
    iv.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:iv];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake((BCWidth - 100)/2, 80, 150, 50)];
    showLabel.text = @"这是第二界面";
    showLabel.textColor = DefaultColor;
    showLabel.font = NewText20Font;
    [self.view addSubview:showLabel];



}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [[CustomSpread new] initWithTransitionType:operation == UINavigationControllerOperationPush ?  SpreadTransitionTypePush: SpreadTransitionTypePop];
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
