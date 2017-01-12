//
//  ClickAttentionViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/27.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ClickAttentionViewController.h"
#import "UIButton+Common.h"
@interface ClickAttentionViewController ()
{

    UILabel *showLabel;
}
@end

@implementation ClickAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton *testBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn1.frame = CGRectMake(100, 100, 100, 50);
    testBtn1.center = self.view.center;
    testBtn1.layer.borderColor = GreenColor.CGColor;
    testBtn1.layer.cornerRadius = 5;
    testBtn1.clipsToBounds = YES;
    testBtn1.layer.borderWidth = 2;
    testBtn1.tag = 10010;
    
    [testBtn1 avoidClick];//避免重复点击
   
    
    [testBtn1 setImage:[UIImage imageNamed:@"icon_apply"] forState:UIControlStateNormal];
    
    //这里如果不用3x的话，那么放大动画里的图片会模糊
    [testBtn1 setImage:[UIImage imageNamed:@"icon_applied@3x"] forState:UIControlStateSelected];
    
    [self.view addSubview:testBtn1];
    
    [testBtn1 addTarget:self action:@selector(animationWithButton:) forControlEvents:UIControlEventTouchUpInside];

  
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(testBtn1.frame) + 10, CGRectGetMidY(testBtn1.frame) - 25, 20, 20)];
    showLabel.text = @"+1";
    showLabel.textColor = [UIColor redColor];
    showLabel.alpha = 0;
    
    [self.view addSubview:showLabel];
    
}

- (void)animationWithButton:(UIButton *)btn {

    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
       
      //有时候用view.tranform并不能实现动画，可以用coreanimation来实现
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = .5;
        animation.autoreverses = YES;
        animation.delegate = self;
        animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
        [btn.imageView.layer addAnimation:animation forKey:nil];
        
        
        showLabel.alpha = 1;
        
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         showLabel.alpha = 0;
      
        
    } completion:^(BOOL finished) {
        
    }];
     
        
    }



}


#pragma mark 动画相关代理事件

- (void)animationDidStart:(CAAnimation *)anim {

    UIButton *btn = [self.view viewWithTag:10010];
    btn.userInteractionEnabled = NO;

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
   
    UIButton *btn = [self.view viewWithTag:10010];
    btn.userInteractionEnabled = YES;



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
