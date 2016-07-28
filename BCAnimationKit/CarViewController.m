//
//  CarViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/26.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CarViewController.h"
#import "Car1ViewController.h"

@interface CarViewController ()<UIGestureRecognizerDelegate>


@end

@implementation CarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GreenColor;
   

    //这个可以用来改变返回按钮
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
//                                initWithTitle:@"hehe"
//                                style:UIBarButtonItemStylePlain
//                                target:self
//                                action:@selector(hehe)];
//    self.navigationItem.leftBarButtonItem = leftBtn;


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
    Car1ViewController *presentVC = [Car1ViewController new];
    
    [self presentViewController:presentVC animated:YES completion:nil];

    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]){
        
        return NO;
        
    }
    
    return YES;
    
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
