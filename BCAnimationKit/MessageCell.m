//
//  MessageCell.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"


@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {



    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self loadMessageView];
    }


    return self;


}


- (void)loadMessageView {

   
    
    //时间
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.backgroundColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.layer.cornerRadius = 15/2;
    timeLabel.clipsToBounds = YES;
    [self.contentView addSubview:timeLabel];
    
    //头像
    headImage = [[UIImageView alloc] init];
    headImage.clipsToBounds = YES;
    [self.contentView addSubview:headImage];
    
  //聊天内容
    
    chatContent = [[UIButton alloc] init];
    chatContent.titleLabel.font = text12Font;
    chatContent.titleLabel.numberOfLines = 0;
    [chatContent setTitleColor:DefaultColor forState:UIControlStateNormal];
    [self.contentView addSubview:chatContent];
    
    
    
    
      

}

- (void)setMessageFrame:(MessageFrame *)messageFrame {

    
    _messageFrame = messageFrame;
    
     MessageModel *tempInfo = _messageFrame.messageModel;
    
    //时间
    
    timeLabel.text = tempInfo.time;
    timeLabel.frame = _messageFrame.timeFrame;
    
    //设置头像及尺寸
    headImage.image = [UIImage imageNamed:tempInfo.headImageName];
    headImage.layer.cornerRadius = 20;
    headImage.frame = _messageFrame.headImageFrame;
    
    //设置内容
    
    if (tempInfo.messageType == MessageText) {
        
        [chatContent setTitle:tempInfo.messageTextContent forState:UIControlStateNormal];
        chatContent.frame = _messageFrame.messageTextFrame;
    }
    
    
    //设置气泡背景
    if (tempInfo.formType == MessageFromMe) {
        
        
     
       
        chatContent.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);

        [chatContent setBackgroundImage:[[UIImage imageNamed:@"chatto_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(39.5, 42, 39.5, 50)] forState:UIControlStateNormal];
        
    } else {
        
        
        chatContent.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
        [chatContent setBackgroundImage:[[UIImage imageNamed:@"chatfrom_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 48, 39, 44)] forState:UIControlStateNormal];
        
        
    }

    //设置内容
    
    
    



}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
