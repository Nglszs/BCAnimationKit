//
//  MessageEnterView.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "MessageEnterView.h"

@implementation MessageEnterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {


    if (self = [super initWithFrame:frame]) {
        
    
        
        [self loadEnterView];
    }


    
    return self;
}


- (void)loadEnterView {

    //左边的按钮
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(6, (50 - 40)/2, 40, 40);
    leftBtn.tag = 10010;
    [leftBtn setImage:[UIImage imageNamed:@"icon_sendsound"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"icon_keyboard"] forState:UIControlStateSelected];
    [self addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间输入框
    
    _enterView = [[UITextView alloc] initWithFrame:CGRectMake(46, (50 - 40)/2, (BCWidth - 46 * 2 - 6), 40)];
    _enterView.layer.borderColor = DefaultColor.CGColor;
    _enterView.layer.borderWidth = 1;
    _enterView.layer.cornerRadius = 5;
    _enterView.clipsToBounds = YES;
    _enterView.backgroundColor = [UIColor whiteColor];
    _enterView.font = text12Font;
    _enterView.returnKeyType = UIReturnKeyDone;
    _enterView.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_enterView];

    //按住说话按钮
    
    clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = _enterView.frame;
    clickBtn.tag = 10011;
    clickBtn.backgroundColor = [UIColor clearColor];
    clickBtn.layer.cornerRadius = 5.0;
    clickBtn.layer.masksToBounds = YES;
    clickBtn.layer.borderWidth = 1;
    clickBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [clickBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clickBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    clickBtn.hidden = YES;
    [self addSubview:clickBtn];


    
    //右边的按钮
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    rightBtn.frame = CGRectMake(BCWidth - 40 - 6,(50 - 40)/2, 40, 40);
    rightBtn.tag = 10012;
    
    
    [rightBtn setImage:[UIImage imageNamed:@"icon_menu_more"] forState:UIControlStateNormal];
   
    [self addSubview:rightBtn];
    
    [rightBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //更多按钮
    
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, BCWidth, 50)];
    _moreView.hidden = YES;
    [self addSubview:_moreView];
   
    UIImageView *horImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, 1)];
    horImgView.backgroundColor = DefaultColor;
    [_moreView addSubview:horImgView];
    
    UIImageView *verImgView = [[UIImageView alloc] initWithFrame:CGRectMake(BCWidth/2 - 0.5, 0, 1, 50)];
    verImgView.backgroundColor = DefaultColor;
    [_moreView addSubview:verImgView];
    
    
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraBtn.frame = CGRectMake(0, 0, BCWidth/2, 50);
    [_cameraBtn setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
    [_moreView addSubview:_cameraBtn];
    
    
    _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoBtn.frame = CGRectMake(BCWidth/2, 0, BCWidth/2, 50);
    [_photoBtn setImage:[UIImage imageNamed:@"icon_photo"] forState:UIControlStateNormal];
    [self.moreView addSubview:_photoBtn];


}

- (void)clickButtonAction:(UIButton *)button {
    button.selected = !button.selected;

    switch (button.tag) {
        case 10010://左边按钮
        {
            if (button.selected) {
                clickBtn.hidden = NO;
                _enterView.hidden = YES;
            } else {
            
                clickBtn.hidden = YES;
                _enterView.hidden = NO;
                [_enterView becomeFirstResponder];
            }
        
        }
            break;
           
            
        case 10011:
        {
        
            if ([self.delegate respondsToSelector:@selector(voiceButton)]) {
                
                [self.delegate voiceButton];
            }

            
        }
            break;
            
            
        case 10012://右边按钮
        {
            
            CGFloat tempHeight;
            if (button.selected) {
                
                _moreView.hidden = NO;
                tempHeight = 100;
              
                
            } else {
                
                _moreView.hidden = YES;
                tempHeight = 50;

            }
            
            
            if ([self.delegate respondsToSelector:@selector(adjustViewFrame:)]) {
                
                [self.delegate adjustViewFrame:tempHeight];
            }
        }
            break;

        default:
            break;
    }

}
@end
