//
//  BCSectionViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/6/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BaseViewController.h"

@interface BCSectionViewController : BaseViewController

/**
 传入标题，以及目标控制器,如果是模态则后面传入NO，否则YES
 */
- (instancetype)initWithTitle:(NSArray *)titleArray controller:(NSArray *)controllerArray isNavController:(BOOL)isNavVC;
@end
