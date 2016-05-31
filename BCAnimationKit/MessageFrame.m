//
//  MessageFrame.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//
#define TextWidth 200

#define kMargin 10 //间隔

#import "MessageFrame.h"

@implementation MessageFrame


- (void)setMessageModel:(MessageModel *)messageModel {


    _messageModel = messageModel;

    
    //计算时间位置
    
    _timeFrame = CGRectMake((BCWidth - 30)/2, 3, 30, 15);

    
    //计算头像位置，内容位置
    
     CGSize labelsize = [_messageModel.messageTextContent sizeWithFont:text12Font constrainedToSize:CGSizeMake(TextWidth,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    

    
    if (_messageModel.formType == MessageFromMe) {//如果自己发的，头像在右边
        
        _headImageFrame = CGRectMake(BCWidth - 16 - 40, 23, 40, 40);
        
        
        
        _messageTextFrame = CGRectMake(( CGRectGetMinX(_headImageFrame) - kMargin - labelsize.width - kContentLeft - kContentRight), 23, labelsize.width + kContentLeft + kContentRight, labelsize.height + kContentTop + kContentBottom);
        
        
              
    } else {
    
        _headImageFrame = CGRectMake(16, 23, 40, 40);
         _messageTextFrame = CGRectMake( CGRectGetMaxX(_headImageFrame), 23, labelsize.width + kContentLeft + kContentRight, labelsize.height + kContentTop + kContentBottom);
    
    }
    
    
    
    _cellHeight = MAX(CGRectGetMaxY(_messageTextFrame), 73);
    

}
@end
