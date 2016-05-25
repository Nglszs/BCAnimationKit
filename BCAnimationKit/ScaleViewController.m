//
//  ScaleViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/24.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ScaleViewController.h"

@interface ScaleViewController ()
{

    UILabel *testLabel;
    UILabel *fontLabel;
    UIImageView *_imageView;
}
@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    testLabel.center = self.view.center;
    testLabel.font = [UIFont boldSystemFontOfSize:14];
    testLabel.textColor = DefaultColor;
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.text = @"放大动画";
    testLabel.transform = CGAffineTransformMakeScale(.3, .3);
    
    fontLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    fontLabel.center = self.view.center;
    fontLabel.textAlignment = NSTextAlignmentCenter;
    fontLabel.font = [UIFont boldSystemFontOfSize:14];
    fontLabel.textColor = GreenColor;
    fontLabel.transform = CGAffineTransformMakeScale(.3, .3);
    fontLabel.text = @"放大动画";
    [self.view addSubview:testLabel];
    [self.view addSubview:fontLabel];
    
    
    testLabel.alpha = 0;
    fontLabel.alpha = 0;


    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((BCWidth - 100)/2, 400, 100, 100)];
    _imageView.image = [UIImage imageNamed:@"bc.jpg"];//默认图片
    [self.view addSubview:_imageView];
    
    
        //动画
    
    [UIView animateWithDuration:1 delay:1 usingSpringWithDamping:.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        testLabel.alpha = 1;
        fontLabel.alpha = 1;
        testLabel.transform = CGAffineTransformMakeScale(1, 1);
        fontLabel.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:2 delay:0.5 usingSpringWithDamping:.7 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            
            fontLabel.alpha = 0;
            fontLabel.transform = CGAffineTransformMakeScale(3, 3);
            
//            _imageView.alpha = 0;
//            _imageView.transform = CGAffineTransformMakeScale(2, 2);
        } completion:^(BOOL finished) {
            
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
