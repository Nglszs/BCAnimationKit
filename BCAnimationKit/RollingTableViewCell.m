//
//  TableAnimationViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//


#import "RollingTableViewCell.h"

@interface RollingTableViewCell ()



@end

@implementation RollingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = COLOR(83, 68, 62, 1);
        self.clipsToBounds = YES;
        [self setupImageView];
    }
    
    return self;
}


//每次cell重用时会调用这个方法
- (void)prepareForReuse {//这里解决复用产生的图片短暂停留

    [super prepareForReuse];
    self.bgImageView.image = nil;

}
#pragma mark - Setup Method
- (void)setupImageView
{
   
    
    // add image subview
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, BCWidth, IMAGE_HEIGHT)];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;

    self.bgImageView.clipsToBounds = NO;
    [self addSubview:self.bgImageView];
}



- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view {
    
    //偏移量
    CGFloat cellOffset = tableView.contentOffset.y - self.frame.origin.y;
    
    CGFloat yOffset = (cellOffset / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    
    CGRect frame = self.bgImageView.bounds;
    self.bgImageView.frame = CGRectOffset(frame, 0, yOffset);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
