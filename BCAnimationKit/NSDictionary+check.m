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

@end
