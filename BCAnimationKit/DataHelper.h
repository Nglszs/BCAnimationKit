//
//  DataHelper.h
//  XiuRen
//
//  Created by 曾强泉 on 13-12-9.
//  Copyright (c) 2013年 yixun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DataHelper : NSObject
{
    NSDictionary *_attributes;
}
- (instancetype)initWithNSDictionary:(NSDictionary *)attributes;
-(NSString *)getStringForKey:(NSString *)key;
-(NSInteger)getIntegerForKey:(NSString *)key;
-(BOOL)getBOOLForKey:(NSString *)key;
-(NSArray *)getArrayForKey:(NSString *)key;
-(NSDictionary *)getDictionaryForKey:(NSString *)key;
-(CGFloat)getFloatForKey:(NSString *)key;
-(NSNumber *)getNumberForKey:(NSString *)key;
-(int)getIntForKey:(NSString *)key;
-(NSArray *)getStringArrayForKey:(NSString *)key;
@end
