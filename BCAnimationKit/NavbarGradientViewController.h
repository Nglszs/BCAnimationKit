//
//  NavbarGradientViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BaseViewController.h"

@interface NavbarGradientViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger currentIndex;

}

/**
    这个属性让导航栏突变还是渐变，yes为渐变，no为突变
 */
@property (nonatomic, assign) BOOL isGradient;

@end
