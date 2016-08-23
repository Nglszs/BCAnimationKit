//
//  StarViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/5.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "StarViewController.h"

#define count  5

@interface StarViewController ()<UITextFieldDelegate>
{

    UILabel  *resultLabel;
    NSInteger shopNumber;
    UITextField *tf;
}
@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评星";
    
    //动画按钮
    UIButton * pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(100, 100, 100, 50);
    [pushBtn setTitle:@"点我" forState:UIControlStateNormal];
    [pushBtn setTitleColor:DefaultColor forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:RandomColor];
    [pushBtn addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [pushBtn addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
   
    [self.view addSubview:pushBtn];
    
    
    
   //评星
    for (int i = 0; i < count; i ++) {
        
        
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        starButton.tag = 10010 + i;
        starButton.frame = CGRectMake(100 + 42 * i, 200, 42, 42);
        [starButton setImage:[UIImage imageNamed:@"grade_star_path"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"grade_star_fill"] forState:UIControlStateSelected];
        [starButton setImage:[UIImage imageNamed:@"grade_star_fill"] forState:UIControlStateHighlighted | UIControlStateSelected];
        
        
        [starButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:starButton];

        
    }
   
    
    
    
    
    
    resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    resultLabel.center = self.view.center;
    resultLabel.font = text12Font;
    [self.view addSubview:resultLabel];
    
    
    
    // 兑换数量控制
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(100, 400, 28 * 3, 28)];
    tf.backgroundColor = [UIColor lightGrayColor];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.rightViewMode = UITextFieldViewModeAlways;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.delegate = self;
    [self.view addSubview:tf];

    UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(0, 0, 28, 28);
    reduceBtn.backgroundColor = [UIColor whiteColor];
    reduceBtn.tag = 9;
    [reduceBtn setImage:[UIImage imageNamed:@"btn_reduce1"] forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(exchangeNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    tf.leftView = reduceBtn;
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(50, 10, 28, 28);
    upBtn.tag = 10;
    upBtn.backgroundColor = [UIColor whiteColor];
    [upBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(exchangeNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    tf.rightView = upBtn;

    
    shopNumber = 1;
    
 tf.text = [NSString stringWithFormat:@"%ld",shopNumber];

}
#pragma  mark  按钮点击事件

//按钮的压下事件 按钮缩小
- (void)pressedEvent:(UIButton *)btn
{
    //缩放比例必须大于0，且小于等于1
    CGFloat scale = .9;
    
    [UIView animateWithDuration:.15 animations:^{
        
        btn.transform = CGAffineTransformMakeScale(scale, scale);
        
    }];
}


//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(UIButton *)btn
{
    [UIView animateWithDuration:.15 animations:^{
        
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    }];
}


#pragma mark textField代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (string.length <= 0) {
        if (textField.text.length <= 1) {
            return NO;
        }
        return YES;
    }
    
    if (![self isPureInt:string]) {//判断是否为数字
        
        NSLog(@"当前输入字符非字符串");
        
        return NO;
    }
    
   
    return YES;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
-(BOOL)IsChinese:(NSString *)str {//是否包含中文
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

- (void)exchangeNumberBtn:(UIButton *)btn {


    if (tf.editing) {
        [tf endEditing:YES];
    }
    
    if (btn.tag == 9) {
        
        shopNumber --;
        
        
        
    } else {
    
        shopNumber ++;
    
    }
    if (shopNumber <= 1 ) {
        
        shopNumber = 1;
        
    }

   
    tf.text = [NSString stringWithFormat:@"%ld",shopNumber];


}
- (void)clickButton:(UIButton *)sender {

   
    //似乎没有什么难点。自己想想就能解决
    
    NSInteger index = sender.tag - 10010 + 1;
    if (!sender.selected) {//点击的星未选中
        
        for (int i = 0; i < index; i ++) {
            UIButton *button = [self.view viewWithTag:10010 + i];
            button.selected = YES;
        }
        
    } else {//点击时已选中
    
        
        for (int page = (int)index ;page < count ; page ++) {
            UIButton *button = [self.view viewWithTag:10010 + page];
            button.selected = NO;
            
        }
    
    }

    
    //显示评分
    NSDictionary *stingDic = @{NSForegroundColorAttributeName:DefaultColor,NSFontAttributeName:NewText20Font};
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你当前的评分为: %ld 星",index]];
    
    [mutableString addAttributes:stingDic range:NSMakeRange(9, 1)];

    resultLabel.attributedText = mutableString;


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
