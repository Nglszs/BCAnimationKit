//
//  BCCollectionViewCell.m
//  new
//
//  Created by Jack on 16/6/16.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCCollectionViewCell.h"

@implementation BCCollectionViewCell

- (void)awakeFromNib {
    
   
   
    
    _kCheckButton = [[UIButton alloc] initWithFrame:CGRectMake(BCWidth/3 - 33, 5, 20, 20)];
   
    [_kCheckButton setBackgroundImage:[UIImage imageNamed:@"check_button_normal"] forState:UIControlStateNormal];
    [_kCheckButton setBackgroundImage:[UIImage imageNamed:@"check_button_selected"] forState:UIControlStateSelected];
    [_kCheckButton addTarget:self action:@selector(changeCheckBtnStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_kCheckButton];
    
}

- (void)changeCheckBtnStatus:(UIButton *)button {

    button.selected = !button.selected;

    [self.delegate clickCell:self];

}



@end
