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
    self.testImage.layer.borderColor = [UIColor redColor].CGColor;
    self.testImage.layer.borderWidth = 1;
}

@end
