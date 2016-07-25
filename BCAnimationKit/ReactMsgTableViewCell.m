//
//  ReactMsgTableViewCell.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ReactMsgTableViewCell.h"

@implementation ReactMsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.frame];
        label.text = @"原生短信效果";
        self.contentView.backgroundColor = RandomColor;
        [self.contentView addSubview:label];
        
      
        
     
    
}

    return self;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
