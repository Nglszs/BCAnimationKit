//
//  TableAnimationViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/6/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//


#import <UIKit/UIKit.h>

// IMAGE_HEIGHT is higher than cell`s height

#define IMAGE_HEIGHT 300

#define IMAGE_OFFSET_SPEED 45

@interface RollingTableViewCell : UITableViewCell

// image used in the cell which will be having the parallax effect

@property (nonatomic, strong) UIImageView *bgImageView;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
