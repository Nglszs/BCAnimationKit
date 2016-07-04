//
//  BCCell.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/24.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCCell.h"

@implementation BCCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.testImage.layer.borderWidth = 3;
    self.testImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //去掉锯齿
    self.testImage.layer.shouldRasterize = YES;
    self.testImage.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    
}

@end
