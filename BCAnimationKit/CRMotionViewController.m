//
//  CRMotionViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/27.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CRMotionViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface CRMotionViewController ()

{
    

}
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CRMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"首页图" ofType:@"png"];
    UIImage *newImage = [UIImage imageWithContentsOfFile:path];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, 562 * BCWidth /750)];
    _scrollView.center = self.view.center;
    [_scrollView setUserInteractionEnabled:NO];
   
    _scrollView.contentSize = CGSizeMake(newImage.size.width, 0);
    _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, 0);
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newImage.size.width, 562 * BCWidth /750)];
    _imageView.image = newImage;
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_scrollView addSubview:_imageView];
    
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
       
    [self startAccelerometer];
}
-(void)startAccelerometer
{
    
    
    __weak typeof(self) weakSelf = self;
    
    if (![_motionManager isGyroActive] && [_motionManager isGyroAvailable]) {
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            double gravityX = motion.gravity.x;
            double xTheta = atan2(gravityX,1.0)/M_PI * 360.0;//绕x方向旋转的角度
            
     
          NSInteger  tempValue = (weakSelf.scrollView.contentSize.width - weakSelf.scrollView.frame.size.width) / 180 * xTheta;
            
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut  animations:^{
                
                
                
        [weakSelf.scrollView setContentOffset:CGPointMake((weakSelf.scrollView.contentSize.width - weakSelf.scrollView.frame.size.width) / 2 + tempValue, 0) animated:NO];
                
            } completion:nil];
                       
            
            
        }];
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //停止加速仪更新
    [self.motionManager stopAccelerometerUpdates];
    
    
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
