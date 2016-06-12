//
//  PuchaseCarViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/2.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "PuchaseCarViewController.h"
#import "AppDelegate.h"
@interface PuchaseCarViewController ()
{

    UIView *newView;
    BOOL isAnimation;
    UIView *bottomView;

}
@end

@implementation PuchaseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DefaultColor;
  
    isAnimation = YES;
    
    UIWindow *key = [UIApplication sharedApplication].keyWindow;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BCHeight, BCWidth, BCHeight - 300)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [key addSubview:bottomView];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
   
    AppDelegate *newApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    newApp.window.backgroundColor = [UIColor blackColor];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
    AppDelegate *newApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    newApp.window.backgroundColor = [UIColor whiteColor];
    
    
    if (![self.navigationController.viewControllers containsObject:self]) {
         [bottomView removeFromSuperview];
        bottomView = nil;
        [self.view.layer removeAllAnimations];
    }
    
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    isAnimation = !isAnimation;
    if (isAnimation) {//恢复原样
        
        //导航栏隐藏看自己的需求
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        [UIView animateWithDuration:.5 animations:^{
            bottomView.frame = CGRectMake(0, BCHeight, BCWidth, BCHeight - 300);
        }];
        
        
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D t1 = CATransform3DIdentity;
            t1.m34 = 1.0/-900;
            t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
            t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
            self.view.layer.transform = t1;
            
            
        } completion:^(BOOL finished){
            
            
            [UIView animateWithDuration:.25 animations:^{
                self.view.layer.transform = CATransform3DIdentity;
                
                
                
            }];
        }];
        
    } else {//点击缩小时的动画
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        
        //底部bottomview移动的动画
        [UIView animateWithDuration:.5 animations:^{//这里的时间要和，缩小动画的时间一致
           bottomView.frame = CGRectMake(0, 300, BCWidth, BCHeight - 300);
        }];

        [UIView animateWithDuration:.25 animations:^{
            
            
            
            CATransform3D t1 = CATransform3DIdentity;
            t1.m34 = 1.0/-900;
            t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
            t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
            self.view.layer.transform = t1;
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CATransform3D t2 = CATransform3DIdentity;
                t2.m34 = 1.0/-900;
                t2 = CATransform3DTranslate(t2, 0, -self.view.frame.size.height * 0.08, 0);
                t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
                self.view.layer.transform = t2;
                
                
                
                
            }];
            
        }];
        
    }
}

- (void)dealloc {

    NSLog(@"购物车已释放");
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
