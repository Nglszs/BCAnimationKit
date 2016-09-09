//
//  NSDictionary+check.m
//  TheMixc
//
//  Created by Jack on 16/9/2.
//  Copyright © 2016年 fashionsfriend. All rights reserved.
//

#import "NSDictionary+check.h"
#import <objc/runtime.h>
@implementation NSDictionary (check)

+(void)load {


    Method imp = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(objectForKey:));
    
    Method imp1 = class_getInstanceMethod(self, @selector(checkDic:));
    
   
    if (imp && imp1) {
        
        //这个方法暂时有问题，先不用
       //  method_exchangeImplementations(imp, imp1);
       
    }
    


}

- (id)checkDic:(id)key {


    NSLog(@"又给字典赋值了");
    id tempStr = [self checkDic:key];
    if (tempStr == nil || tempStr == NULL) {
        return @"";
    }
    if ([tempStr isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([tempStr isEqualToString:@"<null>"]) {
        
        
        return @"";
    }
    if ([tempStr isEqualToString:@"(null)"]) {
        return @"";
    }
    if ([tempStr isKindOfClass:[NSNumber class]]) {
        return [tempStr stringValue];
    }
    
    if ([tempStr isKindOfClass:[NSDictionary class]]||[tempStr isKindOfClass:[NSArray class]]) {
        return tempStr;
    }
    
    return tempStr;




}



- (id)objectOrNilForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    
    return obj;

}

- (NSDictionary *)deleteAllNullValue{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}


+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}


+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}
//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}
//将Null类型的项目转化成@''
+(NSString *)nullToString
{
    return @"";
}
@end
