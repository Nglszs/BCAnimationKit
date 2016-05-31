//
//  ValueChangeViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/30.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ValueChangeViewController.h"

@interface ValueChangeViewController ()
{
    NSTimer *testTimer;
    UILabel *testLabel;
    NSInteger timeIndex;
    
    NSInteger endFloat;
    NSInteger startFloat;

}
@end

@implementation ValueChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    testLabel.center = self.view.center;
    testLabel.backgroundColor = [UIColor greenColor];
    testLabel.textColor = DefaultColor;
    testLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:testLabel];
    
    startFloat = 78;
    timeIndex = 0;
    endFloat = 22;
    testTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeLabel) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        
        [testTimer invalidate];
        testTimer = nil;
        
    }

}
- (void)changeLabel {//方法执行20次也就是2s
    timeIndex ++;
    
    if (timeIndex > 10) {
        startFloat -= 13;
    } else {
        startFloat += 12;
        

    }
    
    testLabel.text = [NSString stringWithFormat:@"%ld",startFloat];
    if (timeIndex > 20) {//2s后，变为最终值
        [testTimer invalidate];
        testTimer = nil;
        testLabel.text = [NSString stringWithFormat:@"%ld",endFloat];
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
