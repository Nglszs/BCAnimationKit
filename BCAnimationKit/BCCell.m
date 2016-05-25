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
    self.testImage.layer.shouldRasterize = YES;
    
    
}

@end
