//
//  NSDictionary+check.h
//  TheMixc
//
//  Created by Jack on 16/9/2.
//  Copyright © 2016年 fashionsfriend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (check)


//直接用+load方法会崩溃，这里单独写一个方法
- (id)objectOrNilForKey:(id)key;
@end
