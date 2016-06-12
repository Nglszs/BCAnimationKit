//
//  SecondViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/2.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
{

CGRect testRect;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     testRect = CGRectMake(BCWidth - 10, 10, 10, 10);
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake((BCWidth - 100)/2, 80, 150, 50)];
    showLabel.text = @"这是第二界面";
    showLabel.textColor = DefaultColor;
    showLabel.font = NewText20Font;
    [self.view addSubview:showLabel];



}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    CGRect tempRect = CGRectInset(testRect, -1000, -1000);
    CGPathRef startPath = CGPathCreateWithEllipseInRect(tempRect, NULL);
    CGPathRef endPath   = CGPathCreateWithEllipseInRect(testRect, NULL);
    
    CAShapeLayer *showLayer = [CAShapeLayer layer];
    showLayer.path = startPath;
    self.view.layer.mask = showLayer;
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(endPath);
    pingAnimation.toValue  = (__bridge id)(startPath);
    pingAnimation.duration  = 1;
    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [pingAnimation setValue:@"animate2" forKey:@"animate2"];
    [showLayer addAnimation:pingAnimation forKey:@"BackPath"];
    
    CGPathRelease(startPath);
    CGPathRelease(endPath);
    
    
    
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
