//
//  Car1ViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/26.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "Car1ViewController.h"
#import "JXPopPresentTransition.h"
@interface Car1ViewController ()<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tap;
}
@end

@implementation Car1ViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //重写init方法并在里面签订协议，这样就可以触发协议方法，返回自定义对象
        self.transitioningDelegate = self;
        //modalPresentationStyle设置为UIModalPresentationCustom后，就跟导航控制器转场动画一样，对于fromVC的添加和移除由系统完成
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor cyanColor];
    
   tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hehe1:)];
   
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    
    

}

//划定区域让点击在空白上才dismiss，其他则不动
- (void)hehe1:(UITapGestureRecognizer *)pp {
    
    
    CGPoint point = [pp locationInView:self.view];
    

    //这里由于手势是加在keywindow上的，如果把计算时在view上，那空白区域的y值肯定是小于0的，
    if (point.y <= 0) {
      
        [self dismissViewControllerAnimated:YES completion:^{
            
            [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:tap];
        }];
    }

}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [JXPopPresentTransition transitionWithTransitionType:JXPopPresentTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [JXPopPresentTransition transitionWithTransitionType:JXPopPresentTransitionTypeDismiss];
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
