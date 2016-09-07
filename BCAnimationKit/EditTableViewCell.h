//
//  EditTableViewCell.h
//  BCAnimationKit
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EditTableViewCell;
@protocol EditCellDelegate <NSObject>

@required
- (void)clickCell:(EditTableViewCell *)cell;

@end
@interface EditTableViewCell : UITableViewCell
{

    UILabel *nameLabel;//显示内容
}

@property (nonatomic, weak) id <EditCellDelegate> delegate;

/**
 *  编辑模式时的按钮，这里写成属性是为了在vc里使用
 */
@property (nonatomic, strong) UIButton *markButton;
/**
 *  这个是为了给cell在编辑模式和正常模式下赋值
 *
 *  @param dataDic 内容
 *  @param editing 是否是编辑模式
 */
- (void)setContentForCellWith:(NSString *)dataDic isEdit:(BOOL) editing;

@end
