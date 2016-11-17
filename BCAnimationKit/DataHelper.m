//
//  DataHelper.m
//  XiuRen
//
//  Created by 曾强泉 on 13-12-9.
//  Copyright (c) 2013年 yixun. All rights reserved.
//

#import "DataHelper.h"


@implementation DataHelper
- (instancetype)initWithNSDictionary:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        _attributes = attributes;
    }
    return self;
}

-(NSString *)getStringForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSString *strValue =[_attributes objectForKey:key];
        if (!strValue || [strValue isEqual:[NSNull null]]) {
            strValue = @"";
        }
        return strValue;
    }
    else
    {
        return @"";
    }
}

-(CGFloat)getFloatForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSNumber *numValue =[_attributes objectForKey:key];
        if (!numValue || [numValue isEqual:[NSNull null]]) {
            return 0;
        }
        return numValue.floatValue;
    }
    else
    {
        return 0;
    }
}

-(NSInteger)getIntegerForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSNumber *numValue =[_attributes valueForKey:key];
        if (numValue) {
            return numValue.integerValue;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

-(int)getIntForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSNumber *numValue =[_attributes valueForKey:key];
        if (numValue) {
            return numValue.intValue;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

-(NSNumber *)getNumberForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSNumber *numValue =[_attributes valueForKey:key];
        if (numValue) {
            return numValue;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

-(BOOL)getBOOLForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSNumber *numValue =[_attributes valueForKey:key];
        if (numValue) {
            return numValue.boolValue;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

-(NSArray *)getArrayForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSArray *arrValue =[_attributes valueForKey:key];
        if (arrValue && [arrValue isKindOfClass:[NSArray class]]) {
            return arrValue;
        }
        else
        {
            return [[NSArray alloc]init];
        }
    }
    else
    {
        return [[NSArray alloc]init];
    }
}

-(NSDictionary *)getDictionaryForKey:(NSString *)key
{
    if ([_attributes isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicValue =[_attributes valueForKey:key];
        if (dicValue && [dicValue isKindOfClass:[NSDictionary class]]) {
            return dicValue;
        }
        else
        {
            return [[NSDictionary alloc]init];
        }
    }
    else
    {
        return [[NSDictionary alloc]init];
    }
}

-(NSArray *)getStringArrayForKey:(NSString *)key
{
    NSArray *originalArray = [self getArrayForKey:key];
    if (originalArray && originalArray.count>0) {
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:originalArray.count];
        for (int i=0; i<originalArray.count; i++) {
            NSString* strCover = originalArray[0];
            if (strCover) {
                [newArray addObject:strCover];
            }
        }
        return newArray;
    }
    else
    {
        return [[NSArray alloc]init];
    }

}
@end
