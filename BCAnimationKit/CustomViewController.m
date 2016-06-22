//
//  CustomViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/21.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomBrowseView.h"
@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    CustomBrowseView  *customView = [[CustomBrowseView alloc] initWithFrame:BCScreen];
    [self.view addSubview:customView];


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
