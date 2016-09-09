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

/**
 *  这里方法目的跟上面一样也是删除字典里的空值
 *
 *  @return 字典
 */
- (NSDictionary *)deleteAllNullValue;


/**
 *  也是删除字典null
 *
 *  @param myDic 传入的字典
 *
 *  @return 返回没有null值的字典
 */
+(id)changeType:(id)myObj;
@end
