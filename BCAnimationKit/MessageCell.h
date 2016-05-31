//
//  MessageCell.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
@interface MessageCell : UITableViewCell

{
    UIImageView *headImage;
    UIButton *chatContent;
    UILabel *timeLabel;
    
   
}

@property (nonatomic, strong) MessageFrame *messageFrame;

@end
