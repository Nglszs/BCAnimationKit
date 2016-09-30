//
//  UIButton+Adapter.m
//  BCAnimationKit
//
//  Created by Jack on 16/9/30.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UIButton+Adapter.h"
#import <objc/runtime.h>
@implementation UIButton (Adapter)
+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
        Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
        method_exchangeImplementations(imp, myImp);
        
    });
    
    
    
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.titleLabel.tag != 333){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize * Multiple];
        }
    }
    return self;
}
@end
