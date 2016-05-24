//
//  KeyboardViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/10.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "KeyboardViewController.h"
#import "UIScrollView+UITouch.h"
@interface KeyboardViewController ()<UITextFieldDelegate>
{
    UIScrollView *mainScroll;
    CGFloat tempHeight;//获得每个textField的高度

}
@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    mainScroll = [[UIScrollView alloc] initWithFrame:BCScreen];
   
    mainScroll.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:mainScroll];
    //界面布局
    NSArray *titleArr = @[@"账号",@"密码"];
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, BCHeight - 300 + 100 * i, 50, 50)];
        label.textColor = [UIColor orangeColor];
        label.text = titleArr[i];
        [mainScroll addSubview:label];
        
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(80, BCHeight - 300 + 100 *i, 100, 50)];
        tf.tag = 10000 + i;
        tf.delegate = self;
        if (i == 0) {
            
            UIButton *done_button = [UIButton buttonWithType:UIButtonTypeCustom];
            done_button.backgroundColor = DefaultColor;
            done_button.frame = CGRectMake(0, 0, 60, 50);
            [done_button setTitle:@"下一步" forState:UIControlStateNormal];
            done_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            done_button.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 16);
            [done_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            done_button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            tf.inputAccessoryView = done_button;
            
            [done_button addTarget:self action:@selector(loginKeyboard) forControlEvents:UIControlEventTouchUpInside];
        }
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.backgroundColor = [UIColor lightGrayColor];
        [mainScroll addSubview:tf];
        
    }

    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark  键盘通知
- (void)keyboardWillShow:(NSNotification *)noti {

    //取得键盘的高度
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    __block UIScrollView *scroll = mainScroll;
    
    if (tempHeight - keyboardHeight < 0) {//被键盘挡住的需要调整高度，其余不需要调整
        

    
        [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
            
            

        //这里使用contentinset或者调整scrollview的frame也行，下面50代表textField的高度，19为键盘缓冲高度，可以自己设置
            
        [scroll setContentOffset:CGPointMake(0,keyboardHeight - tempHeight + 50 + 19 ) animated:YES];
        
            

    } completion:^(BOOL finished) {
        
    }];
    }
}


- (void)keyboardWillHidden:(NSNotification *)noti {

    __block UIScrollView *scroll = mainScroll;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
        [scroll setContentOffset:CGPointZero animated:YES];
        
        
    } completion:^(BOOL finished) {
        
    }];


}
#pragma mark 键盘上的 下一步按钮

- (void)loginKeyboard {

    UITextField *textField = (UITextField *)[mainScroll viewWithTag:10001];
    
    [textField becomeFirstResponder];



}



#pragma mark textField 代理

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    tempHeight = BCHeight - CGRectGetMaxY(textField.frame);
   
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [mainScroll endEditing:YES];

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
