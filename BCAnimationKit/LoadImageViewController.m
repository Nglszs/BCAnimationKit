//
//  LoadImageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/31.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "LoadImageViewController.h"
#import "UIImageView+LoadImage.h"
@interface LoadImageViewController ()
{
    NSTimer *time;
    UIImageView *_imageView;
    CGFloat testFloat;
}
@end

@implementation LoadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((BCWidth - 200)/2, 200, 200, 200)];
    
    _imageView.image = [UIImage imageNamed:@"bc.jpg"];//默认图片
    _imageView.layer.masksToBounds = YES;
    [self.view addSubview:_imageView];
    
    time = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(loadAnimation) userInfo:nil repeats:YES];

    
    testFloat = 0;
}


- (void)loadAnimation {
    testFloat += .1;
    
   
    if (testFloat > 1.1) {//这里让他多执行一次是为了执行加载完成的动画
        [time invalidate];
        time = nil;
    } else {
        
    [_imageView loadImageViewAnimation:testFloat];
    
    
    }

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
