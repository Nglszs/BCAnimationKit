//
//  TurnOffViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/12.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "TurnOffViewController.h"

#define ANTime 0.8
@interface TurnOffViewController ()
{
    UIView *blackView;//黑色背景
    UIView *whiteView;
   
    CAShapeLayer *_shapeLayer;
    
}
@end

@implementation TurnOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 



//  
    blackView = [[UIView alloc]initWithFrame:BCScreen];
    blackView.backgroundColor = [UIColor blackColor];
    
    
    whiteView = [[UIView alloc]initWithFrame:BCScreen];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [blackView addSubview:whiteView];
    [self.view addSubview:blackView];
    
       NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startAboveAnimation) userInfo:nil repeats:NO];
  
}
- (void)startAboveAnimation {
   
   
    
    __weak typeof(self) weakSelf = self;
   [UIView animateWithDuration:ANTime animations:^{
       
       whiteView.transform = CGAffineTransformMakeScale(1, 0.003);
      
   } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:ANTime/2 animations:^{
          
          whiteView.transform = CGAffineTransformScale(whiteView.transform, .5, .5);

      } completion:^(BOOL finished) {
          
          [weakSelf.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
          [weakSelf.navigationController popViewControllerAnimated:YES];
              
          
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
