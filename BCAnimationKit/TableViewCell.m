//
//  TableAnimationViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//


#import "TableViewCell.h"

@interface TableViewCell()

@end
@implementation TableViewCell

- (void)awakeFromNib {
    
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.image.image = nil;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
