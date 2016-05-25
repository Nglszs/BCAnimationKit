//
//  BCTableViewCell.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCTableViewCell.h"

@implementation BCTableViewCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        
        [self loadUI];
        self.contentView.backgroundColor = DefaultColor;
       
    }

    return self;

}


- (void)loadUI {


    //最上面的label
    
    _testLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, BCWidth - 16, 44)];
    _testLabel.font = [UIFont boldSystemFontOfSize:14];
    _testLabel.textColor = [UIColor whiteColor];
   
    [self.contentView addSubview:_testLabel];
    
    
    
    //展开显示的image
    _testImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, BCWidth, 100)];
    [self.contentView addSubview:_testImage];
    
    
    

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

