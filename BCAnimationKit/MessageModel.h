//
//  MessageModel.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,MessageFrom) {
    
    MessageFromMe = 0,
    MessageFromOther
    
    
};

typedef NS_ENUM(NSInteger,MessageType) {
    
    MessageText,
    MessageImage,
    MessageVoice
    
    
};


@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *time;//时间

@property (nonatomic, copy) NSString *headImageName;//头像

@property (nonatomic, copy) NSString *messageTextContent;//文本内容



@property (nonatomic, assign) MessageFrom formType;
@property (nonatomic, assign) MessageType messageType;


+(instancetype)parseFromDict:(NSDictionary *)dic;
@end
