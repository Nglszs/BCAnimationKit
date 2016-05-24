//
//  DiffuseButtonViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/5.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "DiffuseButtonViewController.h"
#define BCTime 0.75
@interface DiffuseButtonViewController ()
{

    UIButton *mainButton;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;

}
@end

@implementation DiffuseButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //这些东西一点技术含量没有，纯属体力活，呵呵
    mainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    mainButton.center = self.view.center;
    mainButton.backgroundColor = [UIColor cyanColor];
    [mainButton setTitle:@"发散" forState:UIControlStateNormal];
    [mainButton setTitle:@"收回" forState:UIControlStateSelected];
    mainButton.layer.cornerRadius = 25;
    mainButton.layer.masksToBounds = YES;
    [mainButton addTarget:self action:@selector(clickMainButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainButton];
    
    
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn1.layer.cornerRadius = 25;
    btn1.clipsToBounds = YES;
    btn1.center = self.view.center;
    btn1.hidden = YES;
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"微博" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn2.layer.cornerRadius = 25;
    btn2.clipsToBounds = YES;
     btn2.center = self.view.center;
    btn2.hidden = YES;
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitle:@"qq" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn3.backgroundColor = [UIColor orangeColor];
    btn3.layer.cornerRadius = 25;
    btn3.clipsToBounds = YES;
     btn3.center = self.view.center;
    btn3.hidden = YES;
    [btn3 setTitle:@"微信" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    
}

- (void)clickMainButton {

    mainButton.selected = !mainButton.selected;
    
    if (mainButton.selected) {
        
        [UIView animateWithDuration:BCTime animations:^{
            btn1.hidden = NO;
            btn2.hidden = NO;
            btn3.hidden = NO;
            //这里也可以用animation动画来写，我这里简单写出怎么实现
            btn1.transform = CGAffineTransformTranslate(btn1.transform, -75, -100);
            btn2.transform = CGAffineTransformTranslate(btn2.transform, -100, 0);
            btn3.transform = CGAffineTransformTranslate(btn3.transform, -75, 100);
            mainButton.userInteractionEnabled = NO;
        } completion:^(BOOL finished) {
            

            mainButton.userInteractionEnabled = YES;

        
        }];
    } else {
    
    
        [UIView animateWithDuration:BCTime animations:^{
            
    
            btn1.transform = CGAffineTransformTranslate(btn1.transform, 75, 100);
             btn2.transform = CGAffineTransformTranslate(btn2.transform, 100, 0);
             btn3.transform = CGAffineTransformTranslate(btn3.transform, 75, -100);

            mainButton.userInteractionEnabled= NO;
        } completion:^(BOOL finished) {
            
            btn1.hidden = YES;
            btn2.hidden = YES;
            btn3.hidden = YES;
            mainButton.userInteractionEnabled = YES;
        }];

    
    
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
