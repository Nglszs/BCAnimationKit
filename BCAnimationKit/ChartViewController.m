//
//  ChartViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ChartViewController.h"
#import "BCChartView.h"
@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    BCChartView *chartView = [[BCChartView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, 200)];
    chartView.center = self.view.center;
    [self.view addSubview:chartView];

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
