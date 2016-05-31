//
//  MessageModel.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (instancetype)parseFromDict:(NSDictionary *)dic {


    MessageModel *userInfo = [[MessageModel alloc] init];
    userInfo.headImageName = dic[@"HeadImage"];
    userInfo.time = @"12:55";
    userInfo.messageTextContent = dic[@"Content"];
    userInfo.formType = [dic[@"FromType"] integerValue];
    userInfo.messageType = [dic[@"MsgType"] integerValue];
    return userInfo;
}

@end
