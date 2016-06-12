//
//  BCClearCache.h
//  BCAnimationKit
//
//  Created by Jack on 16/6/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCClearCache : NSObject

/**
 这个方法要传入要清除缓存的路径，并返回当前文件夹下的大小

 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;


/**
 判断是否清除成功
 */

+ (BOOL)clearCacheWithFilePath:(NSString *)path;
@end
