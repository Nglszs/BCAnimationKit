//
//  NSMutableDictionary+Extension.m
//  LoanPro
//
//  Created by 秦茂军 on 16/8/17.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "NSDictionary+CrashIntercept.h"
#import <objc/message.h>
@implementation NSDictionary(CrashIntercept)
+ (void)load{
    
    Method originalMethod1 = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:));
    Method newMethod1 = class_getInstanceMethod(self, @selector(kpRemoveObjectForKey:));
    
    if (originalMethod1 &&newMethod1) {
        method_exchangeImplementations(originalMethod1, newMethod1);
    }
    
    
    Method originalMethod2 = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
    Method newMethod2 = class_getInstanceMethod(self, @selector(kpSetObject:forKey:));

    if (originalMethod2 &&newMethod2) {
        method_exchangeImplementations(originalMethod2, newMethod2);
    }
    
}

- (void)kpSetObject:(id)anObject forKey:(id<NSCopying>)aKey{
    
    
   
    if (aKey!=nil) {
        [self kpSetObject:anObject forKey:aKey];
    }
    else{
        NSLog(@"ERROR:存在key:nil<---->value:%@",anObject);
        return;
    }
    
    if(anObject&&aKey){
        [self kpSetObject:anObject forKey:aKey];
    }else{
        NSLog(@"ERROR:存在key:%@<------>value为nil",aKey);
    }
}

- (void)kpRemoveObjectForKey:(id)aKey{
    
    if(aKey){
        [self kpRemoveObjectForKey:aKey];
    }else{
        NSLog(@"ERROR:[__NSDictionaryM removeObjectForKey:]: key cannot be nil");
    }
}




@end
