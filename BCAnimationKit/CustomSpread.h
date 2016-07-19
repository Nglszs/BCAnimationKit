//
//  CustomSpread.h
//  BCAnimationKit
//
//  Created by Jack on 16/7/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,AnimationType) {
    
    SpreadTransitionTypePush = 0,
    SpreadTransitionTypePop
};
@interface CustomSpread : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType transitionType;

- (instancetype)initWithTransitionType:(AnimationType)type;

@end
