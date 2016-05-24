//
//  NonCopyViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/9.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "NonCopyViewController.h"
#import "CustomTextView.h"
@interface NonCopyViewController ()

@end

@implementation NonCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:CGRectMake(20, 200, BCWidth - 40, 200)];
    
    textView.isHavedCopyRight = NO;
    
    [self.view addSubview:textView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];

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
