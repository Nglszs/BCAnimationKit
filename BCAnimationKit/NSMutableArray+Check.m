//
//  NSMutableArray+Check.m
//  BCAnimationKit
//
//  Created by Jack on 16/8/11.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "NSMutableArray+Check.h"

@implementation NSMutableArray (Check)
- (id)objectAtIndexCheck:(NSUInteger)index
{
    //使用方法
//     [_datasourceArray objectAtIndex:indexPath.row] 改为
//   [_datasourceArray objectAtIndexCheck:indexPath.row] 就可以了
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end
