//
//  SystemPopViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SystemPopViewController.h"
#import "SystemSecViewController.h"
@interface SystemPopViewController ()

@end

@implementation SystemPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GreenColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    SystemSecViewController *sec = [[SystemSecViewController alloc] init];
    self.navigationController.delegate = sec;
    [self.navigationController pushViewController:sec animated:YES];

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
