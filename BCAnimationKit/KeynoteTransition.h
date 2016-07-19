//
//  KeynoteTransition.h
//  BCAnimationKit
//
//  Created by Jack on 16/7/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,AnimationType) {
    
    MoveTransitionTypePush = 0,
    MoveTransitionTypePop
};
/**
 这里是将pop和push写在一起，不再像之前分两个类来写
 */
@interface KeynoteTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType transitionType;

- (instancetype)initWithTransitionType:(AnimationType)type;
@end
