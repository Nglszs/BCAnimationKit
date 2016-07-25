//
//  SecondViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/2.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomSpread.h"
#import "JXCircleSpreadTransition.h"
@interface SecondViewController ()
{

CGRect testRect;
}
@end

@implementation SecondViewController

//下面如果是用模态必须用的
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.transitioningDelegate = self;
//        self.modalPresentationStyle = UIModalPresentationCustom;
//    }
//    return self;
//}

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

#pragma 导航视图的代理
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [[CustomSpread new] initWithTransitionType:operation == UINavigationControllerOperationPush ?  SpreadTransitionTypePush: SpreadTransitionTypePop];
}




#pragma  mark 模态视图的代理

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return [JXCircleSpreadTransition transitionWithTransitionType:JXCircleSpreadTransitionTypePresent];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return [JXCircleSpreadTransition transitionWithTransitionType:JXCircleSpreadTransitionTypeDismiss];
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.clickedPoint = [[touches anyObject] locationInView:[touches anyObject].view];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
