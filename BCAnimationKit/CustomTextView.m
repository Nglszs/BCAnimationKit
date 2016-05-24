//
//  CustomTextView.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/9.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView



- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        
        self.layer.cornerRadius = 9/2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = DefaultColor.CGColor;
        [self becomeFirstResponder];
        
        
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:@"请长按此textview会有惊喜"];
       
        //添加一张图片
        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        UIImage *creatImage = [UIImage imageNamed:@"head.jpg"];
        textAtt.image = creatImage;
        textAtt.bounds = CGRectMake(0, 0, 20, 20);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAtt ];
        [textStr appendAttributedString:imageStr];
        self.attributedText = textStr;
                                        
    }

    return self;

}

#pragma mark 重写三个方法，这也可以给label/button加上复制粘贴的功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {


    if (action == @selector(copy:)) {//这里我只重写一个拷贝
        return YES;
    } else {
    
        return [super canPerformAction:action withSender:sender];
    }


}

- (BOOL)canBecomeFirstResponder {

    return YES;
}

- (void)copy:(id)sender {//重写系统拷贝的方法

    if (!_isHavedCopyRight) {
        
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有权限复制" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [view show];
        
        
    } else {
    
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.text;
        
        
        NSLog(@"%@",[self textString]);
    }


}



-(NSString *)textString

{
    
    NSAttributedString * att = self.attributedText;
    
    
    
    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:att];
    
    
    __weak typeof(self) weakSelf = self;
   
    //枚举出所有的附件字符串
 
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
     
        //key-NSAttachment
   
        //NSTextAttachment value类型
     
        NSTextAttachment * textAtt = attrs[@"NSAttachment"];//从字典中取得那一个图片
      
        if (textAtt)
            
        {
           
           // UIImage * image = textAtt.image;
          
            NSString *text = [weakSelf stringFromImage];
           
            [resutlAtt replaceCharactersInRange:range withString:text];
            
        }
       
    }];
   
    return resutlAtt.string;
    
}
-(NSString *)stringFromImage
{
       
    return @"head.jpg";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
