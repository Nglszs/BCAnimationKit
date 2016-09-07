//
//  EditTableViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BaseViewController.h"
#import "EditTableViewCell.h"
@interface EditTableViewController : BaseViewController<EditCellDelegate>
{

    NSMutableArray *buttonStateArr;//为了解决重用的问题
    UIView *footView;//用来显示底部的一些按钮
    BOOL isEdit;//是否编辑
    UIButton *deleteBtn;//删除按钮
    UIButton *selectAllBtn;//全选按钮
}

@property (nonatomic, strong) NSMutableArray *msgDataArray;
@property (nonatomic, strong) NSMutableArray *msgDeleteArray;
@property (nonatomic, strong) UITableView *systemMsgTableView;
@end
