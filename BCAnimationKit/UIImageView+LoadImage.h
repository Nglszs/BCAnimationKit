//
//  UIImageView+LoadImage.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/31.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)


@property (nonatomic, strong) CAShapeLayer *outLayer;//外面的覆盖层
@property (nonatomic, strong) CAShapeLayer *inLayer;//里面的动画层


- (void)loadImageViewAnimation:(CGFloat)angle;
@end
