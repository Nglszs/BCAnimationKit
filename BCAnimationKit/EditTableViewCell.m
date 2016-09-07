//
//  EditTableViewCell.m
//  BCAnimationKit
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
                [self initView];
    }

    return self;
}

- (void)initView {

    _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    _markButton.frame = CGRectMake(16,(50 - 21)/2 ,21 , 21);
    
    [_markButton setBackgroundImage:[UIImage imageNamed:@"icon_oval_select"] forState:UIControlStateNormal];
    [_markButton setBackgroundImage:[UIImage imageNamed:@"icon_oval_selected"] forState:UIControlStateSelected];
    [_markButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview: _markButton];


    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_markButton.frame) + 10 + 16, 0, BCWidth, 50)];
 
    nameLabel.font = [UIFont systemFontOfSize:17];
    
    nameLabel.textColor = [UIColor blackColor];

    [self.contentView addSubview:nameLabel];
    
}


- (void)setContentForCellWith:(NSString *)tempInfo isEdit:(BOOL)editing {



    if (!editing) {//这里根据是否编辑来调整按钮，也可以hidden
        
        _markButton.frame = CGRectZero;
        
    } else {
        
        _markButton.frame = CGRectMake(16,(50 - 21)/2 ,21 , 21);
        
    }



    nameLabel.text = tempInfo;
    nameLabel.frame = CGRectMake(CGRectGetWidth(_markButton.frame) + 10 + 16 , 0, BCWidth, 50);


}




- (void)changeState:(UIButton *)button {
    button.selected = !button.selected;

    [self.delegate clickCell:self];
}




@end
