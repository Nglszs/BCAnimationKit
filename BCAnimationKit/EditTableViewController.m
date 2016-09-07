//
//  EditTableViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "EditTableViewController.h"

@implementation EditTableViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    //这里的tableview编辑模式并没有用tableview自带的编辑功能而是强行谢了一个，因为系统自带的太丑了
    
     buttonStateArr = [NSMutableArray array];
    _msgDataArray = [NSMutableArray array];
    _msgDeleteArray = [NSMutableArray array];
    
    
    NSArray *arr = @[@"下拉放大",@"导航栏渐变",@"上拉和下拉刷新",@"点击按钮弹出气泡",@"无限轮播",@"评星",@"输入格式化",@"发散按钮",@"播放Gif动画",@"图片浏览",@"禁止复制/粘贴",@"键盘自适应高度",@"图片裁剪",@"夜间模式",@"果冻动画",@"QQ电话动画",@"关机动画",@"3D浏览图片",@"重力及碰撞",@"Calayer及其子类",@"CollectionView浏览图片",@"辉光动画",@"放大动画",@"Tableview展开",@"聊天界面",@"语音转文字",@"数值改变动画",@"引导页",@"图片加载动画",@"转场动画",@"淘宝购物车",@"分段视图",@"文字转语音",@"添加图片",@"View绕某点转动",@"点赞动画",@"摇晃浏览图片",@"TableView效果",@"图表视图",@"显示网页上的图片",@"等待加载动画",@"自定义Pop动画",@"自定义Present动画",@"keynote动画",@"原生短信效果",@"数值滚动动画",@"购物车动画二",@"推出动画",@"TableView编辑模式"];
    
    [_msgDataArray addObjectsFromArray:arr];
    
    
    for (int i = 0; i < _msgDataArray.count; i ++) {//为了复用
        [buttonStateArr addObject:@"0"];
    }

    
    
    _systemMsgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight) style:UITableViewStylePlain];
    _systemMsgTableView.backgroundColor = [UIColor clearColor];
    _systemMsgTableView.delegate = self;
    _systemMsgTableView.dataSource = self;
    
    [self.view addSubview:_systemMsgTableView];

   
   //加在底部的按钮
    footView = [[UIView alloc] initWithFrame:CGRectMake(0,BCHeight - 40, BCWidth, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    
    selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.frame = CGRectMake(16, 11, 55, 28);
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitle:@"全不选" forState:UIControlStateSelected];
    [selectAllBtn setTitleColor:DefaultColor forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:selectAllBtn];
    
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    deleteBtn.frame = CGRectMake(BCWidth - 16 - 100, 11, 100, 28);
    [deleteBtn setTitle:[NSString stringWithFormat:@"删除 %lu",(unsigned long)_msgDeleteArray.count] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:DefaultColor forState:UIControlStateNormal];
    [footView addSubview:deleteBtn];
    deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
  
    footView.hidden = YES;
    [self.view addSubview:footView];


}



#pragma mark - UITableView Delegate & Datasrouce

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return isEdit == YES?50:0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(BCWidth - 16 - 48, 11, 48, 28);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:DefaultColor forState:UIControlStateNormal];
    btn.titleLabel.font = text12Font;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = DefaultColor.CGColor;
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    
    return headView;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   
    return _msgDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   static NSString *identify = @"identify1";
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        //长按手势
        UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressedAct:)];
        longPressed.minimumPressDuration = 1;
        [cell.contentView addGestureRecognizer:longPressed];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
    }
    
    
    
    
    
    
       
    NSString *tempInfo = [_msgDataArray objectAtIndex:indexPath.row];
    
    [cell setContentForCellWith:tempInfo isEdit:isEdit];
    
    cell.markButton.selected = [[buttonStateArr objectAtIndex:indexPath.row] integerValue];//这句代码是为了解决重用的问题
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
  
       if (isEdit) {
        
        
        
        
       EditTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.markButton.selected = !cell.markButton.selected;
        if (cell.markButton.selected) {
            
            [buttonStateArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
            
            [self.msgDeleteArray addObject:[self.msgDataArray objectAtIndex:indexPath.row]];
        } else {
            
            [self.msgDeleteArray removeObject:[self.msgDataArray objectAtIndex:indexPath.row]];
            
            [buttonStateArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        
        [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",_msgDeleteArray.count] forState:UIControlStateNormal];
        
        
    } else {
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}




#pragma mark 长按手势和按钮点击事件

//取消按钮
- (void)selectedBtn:(UIButton *)button {
    
    isEdit = NO;
    footView.hidden = YES;
    _systemMsgTableView.frame = CGRectMake(0, 0, BCWidth, BCHeight);
    [_systemMsgTableView reloadData];
    
}
//长按
-(void)longPressedAct:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:_systemMsgTableView];
        NSIndexPath * indexPath = [_systemMsgTableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        
        [self.msgDeleteArray removeAllObjects];
        isEdit = YES;
        
        _systemMsgTableView.frame = CGRectMake(0, 0, BCWidth, BCHeight - 50);
        [_systemMsgTableView reloadData];
        footView.hidden = NO;
    }
}

//全选

- (void)selectAllBtnClick:(UIButton *)button {
    
    [self.msgDeleteArray removeAllObjects];
    
    button.selected = !button.selected;
    if (button.selected) {
        for (int i = 0; i < self.msgDataArray.count; i ++) {//全选
            
            
            
            
            
            [buttonStateArr replaceObjectAtIndex:i withObject:@"1"];
            
            
        }
        
        
        [self.msgDeleteArray addObjectsFromArray:self.msgDataArray];
        
        [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",_msgDeleteArray.count] forState:UIControlStateNormal];
        
        
        
        
    } else {//全不选
        
        for (int i = 0; i < self.msgDataArray.count; i ++) {
            [buttonStateArr replaceObjectAtIndex:i withObject:@"0"];
            
            
        }
        [self.msgDeleteArray removeAllObjects];
        
        [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",_msgDeleteArray.count] forState:UIControlStateNormal];
        
    }
    
    
    [_systemMsgTableView reloadData];
    
}
//删除
- (void)deleteClick:(UIButton *) button {
    
    if (isEdit) {
        //删除
        
        if (_msgDataArray.count == _msgDeleteArray.count) {
            isEdit = NO;
            footView.hidden = YES;
            _systemMsgTableView.frame = CGRectMake(0, 0, BCWidth, BCHeight);
            
        }
        
        [self.msgDataArray removeObjectsInArray:self.msgDeleteArray];
        [self.msgDeleteArray removeAllObjects];
        
        [buttonStateArr removeAllObjects];
        for (int i = 0; i < _msgDataArray.count; i ++) {//每删除一次将状态重新复制一次
            [buttonStateArr addObject:@"0"];
        }
        
        [_systemMsgTableView reloadData];
        
        
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        
        
    }
    else return;
}




#pragma mark cell代理
- (void)clickCell:(EditTableViewCell *)cell {

   NSIndexPath *indexPath = [_systemMsgTableView indexPathForCell:cell];
    
    if (cell.markButton.selected) {
        
        [self.msgDeleteArray addObject:[self.msgDataArray objectAtIndex:indexPath.row]];
        [buttonStateArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
        
    } else {
        
    [self.msgDeleteArray removeObject:[self.msgDataArray objectAtIndex:indexPath.row]];
        [buttonStateArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
        
    }


    [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",_msgDeleteArray.count] forState:UIControlStateNormal];
    
    
}
@end
