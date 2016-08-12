//
//  ShimmerViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/24.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ShimmerViewController.h"

@interface ShimmerViewController ()

@end

@implementation ShimmerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
     self.view.backgroundColor = [UIColor blackColor];
    
    [self loadLabel];
    
    
    [self loadLabel1];


}


- (void)loadLabel {


    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    testLabel.center = self.view.center;
    testLabel.font = [UIFont boldSystemFontOfSize:14];
    testLabel.textColor = [UIColor colorWithRed:100/255.0 green:200/255.0 blue:100/255.0 alpha:1];
    testLabel.text = @"这是辉光动画";
    
    [self.view addSubview:testLabel];
    
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = testLabel.bounds;
    
    
    
    
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:100/255.0 green:200/255.0 blue:100/255.0 alpha:.3].CGColor,
                             (__bridge id)[UIColor colorWithRed:100/255.0 green:200/255.0 blue:100/255.0 alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:100/255.0 green:200/255.0 blue:100/255.0 alpha:.3].CGColor];
    
    
    gradientLayer.locations = @[@(-0.4), @(-0.2), @(0)];
    
    gradientLayer.startPoint = CGPointMake(0 , 0.5);
    gradientLayer.endPoint = CGPointMake(1 , 0.5);
    
    
    
    testLabel.layer.mask = gradientLayer;
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = 1.5;
    animation.repeatCount = INT16_MAX;
    animation.fromValue = @[@(-0.4), @(-0.2), @(0)];
    
    animation.toValue = @[@(1.0),@(1.2),@(1.4)];
    
    [gradientLayer addAnimation:animation forKey:@"shimmer animation"];




}

- (void)loadLabel1 {
    // title label
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.text = @"Tap To Full Screen";
    title.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:title];
    
    [self shimmerHeaderTitle:title];


}
- (void)shimmerHeaderTitle:(UILabel *)title {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        title.transform = CGAffineTransformMakeScale(0.98, 0.98);
        title.alpha = 0.3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            title.alpha = 1.0;
            title.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [weakSelf shimmerHeaderTitle:title];
        }];
    }];
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
