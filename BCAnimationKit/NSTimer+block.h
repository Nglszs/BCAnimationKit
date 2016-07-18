//
//  NSTimer+block.h
//  BCAnimationKit
//
//  Created by Jack on 16/7/14.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (block)

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;


+(instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
@end
