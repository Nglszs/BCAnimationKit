//
//  CustomBrowseView.h
//  BCAnimationKit
//
//  Created by Jack on 16/6/21.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBrowseView : UIView
{

    NSInteger currentIndex;
    CGFloat resultValue;
}

@property (nonatomic, strong) UIImageView *backgroundImageV;
@property (nonatomic, strong) UIImageView *previousImageV;

@end
