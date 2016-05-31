//
//  MessageFrame.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MessageModel.h"
@interface MessageFrame : NSObject


@property (nonatomic, assign, readonly) CGRect headImageFrame;
@property (nonatomic, assign, readonly) CGRect messageTextFrame;
@property (nonatomic, assign, readonly) CGRect timeFrame;

@property (nonatomic, strong) MessageModel *messageModel;


@property (nonatomic, assign, readonly) CGFloat cellHeight; //cell高度
@end
