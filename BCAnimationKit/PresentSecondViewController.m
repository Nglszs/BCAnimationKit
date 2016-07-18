//
//  PresentSecondViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/18.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "PresentSecondViewController.h"

@interface PresentSecondViewController ()

@end

@implementation PresentSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *vv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    vv.image = [UIImage imageNamed:@"login.jpg"];
    [self.view addSubview:vv];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [self dismissViewControllerAnimated:YES completion:nil];
});
   


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
