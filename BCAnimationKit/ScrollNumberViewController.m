//
//  ScrollNumberViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/26.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ScrollNumberViewController.h"
#import "NumberView.h"
@interface ScrollNumberViewController ()
{

    NumberView *numberView;
}
@end

@implementation ScrollNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    numberView = [[NumberView alloc] initViewFrame:CGRectMake(0, 0, 200, 100) andValue:@(arc4random_uniform(3000))];
    numberView.center = self.view.center;
    [numberView startAnimation];
    [self.view addSubview:numberView];

  

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [numberView startAnimation];

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
