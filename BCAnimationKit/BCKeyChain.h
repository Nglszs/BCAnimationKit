//
//  BCKeyChain.h
//  BCAnimationKit
//
//  Created by Jack on 16/6/3.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCKeyChain : NSObject
/**
 保存一些信息到keychain里，keychain存储
 
 */
+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

//删除数据
+ (void)delete:(NSString *)service;

@end
