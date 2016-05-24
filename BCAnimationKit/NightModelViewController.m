//
//  NightModelViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/11.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "NightModelViewController.h"
#import "AppDelegate.h"

@implementation NightModelViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
   //可以将当前的模式保存起来，方便重启应用时使用
    
    UISwitch *muteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    muteSwitch.center = self.view.center;
    muteSwitch.on = NO;
    muteSwitch.onTintColor = [UIColor greenColor];
    [muteSwitch addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventValueChanged];



    [self.view addSubview:muteSwitch];
    
    
    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake((BCWidth - 100)/2, BCHeight/2 - 200, 100, 50)];
    _showLabel.backgroundColor = [UIColor whiteColor];
    _showLabel.textColor = [UIColor blackColor];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.text = @"白天模式";
    [self.view addSubview:_showLabel];
    
    
}

- (void)changeModel:(UISwitch *)modelSwitch {

    AppDelegate *newAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (modelSwitch.on) {
        newAppDelegate.isNightModel = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:Night object:nil];
        
    } else {
        newAppDelegate.isNightModel = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:Day object:nil];
        
    }
    


}


#pragma mark 重写基类切换日夜间模式的方法

//这里我没有改变导航栏的颜色，需要的可以自己去改变,然后在其他界面都重写基类的方法即可实现日夜间模式，总感觉这种方法不够好

- (void)openNightModel {
    _showLabel.backgroundColor = [UIColor blackColor];
    _showLabel.textColor = [UIColor whiteColor];
    _showLabel.text = @"夜间模式";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
}
- (void)openDayModel {
    _showLabel.backgroundColor = [UIColor whiteColor];
    _showLabel.textColor = [UIColor blackColor];
    _showLabel.text = @"白天模式";
    self.view.backgroundColor = [UIColor whiteColor];
    
  

    
}
@end
