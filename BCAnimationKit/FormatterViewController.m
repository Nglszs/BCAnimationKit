//
//  FormatterViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/5.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "FormatterViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#define Numeber 11

@interface FormatterViewController ()<UITextFieldDelegate>
{
    UITextField *textFiled;
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;

    NSUInteger targetCursorPosition;
}
@end

@implementation FormatterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//输入格式化的难点在于当删除时怎么能保证输入依然正确，格式化其实很简单，只是插入空格而已
    
    textFiled = [[UITextField alloc] initWithFrame:CGRectMake((BCWidth - 200)/2, 100, 200, 50)];
    textFiled.backgroundColor = [UIColor cyanColor];
  
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.borderStyle = UITextBorderStyleRoundedRect;
    textFiled.enablesReturnKeyAutomatically = YES;
    textFiled.delegate = self;
    textFiled.placeholder = @"请输入电话号码";
   
    [self.view addSubview:textFiled];

    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //获取之间光标和起始位置有多少个字符
    targetCursorPosition =
    [textFiled offsetFromPosition:textFiled.beginningOfDocument
                       toPosition:textFiled.selectedTextRange.start];
    
    NSLog(@"--%ld",targetCursorPosition);
    if (string.length <= 0) {//删除时
        
        if (targetCursorPosition == 4 || targetCursorPosition == 9) {
            targetCursorPosition--;
            
        }
        
    } else {
        
        if (targetCursorPosition == 3 || targetCursorPosition == 8) {
            
            targetCursorPosition ++;
        }
        
        if (textFiled.text.length == 3) {
            textFiled.text = [textFiled.text stringByAppendingString:@" "];
           
           
            
        }
       
        if (textFiled.text.length == 8) {
            textFiled.text = [textFiled.text stringByAppendingString:@" "];
            
        }
    
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *deleteString = [textFiled.text stringByTrimmingCharactersInSet:set];
        
        if (deleteString.length >= 13) {
            textFiled.text = deleteString;
            
            //设置游标位置，如果不设置会自动跳到结尾，看自己需求
            if (targetCursorPosition == 9) {
                UITextPosition *targetPosition =
                [textFiled positionFromPosition:[textFiled beginningOfDocument]
                                         offset:8];
                
                [textFiled setSelectedTextRange:[textFiled textRangeFromPosition:targetPosition toPosition :targetPosition]
                 ];

            }
           
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
            animation.duration = 0.2;
            animation.fromValue = [NSNumber numberWithFloat:textField.center.x - 10];
            animation.toValue = [NSNumber numberWithFloat:textField.center.x + 10];
            animation.repeatCount = 1;
            animation.autoreverses = YES;
            animation.delegate = self;
            [textField.layer addAnimation:animation forKey:@"shake"];

            
            return NO;
        }
    
        
    
    }
    
    UITextPosition *targetPosition =
    [textFiled positionFromPosition:[textFiled beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textFiled setSelectedTextRange:[textFiled textRangeFromPosition:targetPosition toPosition :targetPosition]
     ];
    return YES;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    momAnimation.fromValue = [NSNumber numberWithFloat:-0.3];
//    momAnimation.toValue = [NSNumber numberWithFloat:0.3];
//    momAnimation.duration = 0.2;
//    momAnimation.repeatCount = 2;
//    momAnimation.autoreverses = YES;
//    momAnimation.delegate = self;
//    [textField.layer addAnimation:momAnimation forKey:@"animateLayer"];
    
   

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
