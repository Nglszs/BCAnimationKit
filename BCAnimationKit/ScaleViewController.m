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
     UIImageView *_imageView1;
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


    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    _imageView.image = [UIImage imageNamed:@"bc.jpg"];//默认图片
    [self.view addSubview:_imageView];
    
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(220, 400, 100, 100)];
    _imageView1.image = [UIImage imageNamed:@"bc1.jpg"];//默认图片
    [self.view addSubview:_imageView1];
    
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
            

            
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
    
  
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //这是uiview的转场动画和前面的有所不同，他还有UIView transitionFromView可以使用，注意动画里的枚举，下面是一个翻转的动画，可以常用uiview的转场动画
        [UIView transitionWithView:_imageView duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft  animations:^{
            
            _imageView.image = [UIImage imageNamed:@"bc1.jpg"];
        } completion:^(BOOL finished) {
            
        }];

        
        
        [UIView transitionWithView:_imageView1 duration:2 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
            
            _imageView1.image = [UIImage imageNamed:@"head.jpg"];
        } completion:^(BOOL finished) {
            
        }];
        
        
        
        //下面方法是模仿弹窗效果
//        [UIView animateWithDuration:1 animations:^{
//            _imageView1.transform = CGAffineTransformMakeScale(1.2, 1.2);
//        } completion:^(BOOL finished) {
//            
//            [UIView animateWithDuration:1 animations:^{
//                _imageView1.transform = CGAffineTransformScale(_imageView1.transform, .2, .2);
//
//            }];
//            
//        }];
//
});
    
    

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
