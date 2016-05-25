//
//  ViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/3.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ViewController.h"
#import "DropEnlargeViewControler.h"
#import "NavbarGradientViewController.h"
#import "SuspendViewController.h"
#import "RefreshViewController.h"
#import "CarouselViewController.h"
#import "StarViewController.h"
#import "FormatterViewController.h"
#import "DiffuseButtonViewController.h"
#import "GifPlayViewController.h"
#import "ClickImageViewController.h"
#import "NonCopyViewController.h"
#import "KeyboardViewController.h"
#import "CorpImageViewController.h"
#import "NightModelViewController.h"
#import "SpringViewController.h"
#import "QQPhoneViewController.h"
#import "TurnOffViewController.h"
#import "CubeViewController.h"
#import "GravityViewController.h"
#import "CalayerViewController.h"
#import "CollectionViewController.h"
#import "ShimmerViewController.h"
#import "ScaleViewController.h"
#import "TableScaleViewController.h"
@interface ViewController ()
{

    UITableView *testTableView;
    NSArray *testArray;
    UIImageView *headImage;
    BOOL isFristLoad;//加个动画
    NSUInteger currentIndex;
    
    NSUInteger testType;//动画类型
   }
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFristLoad = YES;
    testType = arc4random_uniform(10);
    self.title = @"动画";
   
    //此项目的目地是为了将一些常用的功能封装起来，供大家直接使用或者学习
    
    
    testTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    testTableView.tableFooterView = [UIView new];
   
    testTableView.rowHeight = 44;
    [self.view addSubview:testTableView];

     testArray = @[@"下拉放大",@"导航栏渐变",@"上拉和下拉刷新",@"点击按钮弹出气泡",@"无限轮播",@"评星",@"输入格式化",@"发散按钮",@"播放Gif动画",@"图片浏览",@"禁止复制/粘贴",@"键盘自适应高度",@"图片裁剪",@"夜间模式",@"果冻动画",@"QQ电话动画",@"关机动画",@"3D浏览图片",@"重力及碰撞",@"Calayer及其子类",@"CollectionView浏览图片",@"辉光动画",@"放大动画",@"Tableview展开"];
    
    currentIndex = testTableView.bounds.size.height/44 - 2;
   }

#pragma mark  UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return testArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

static NSString *cellid = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14/2, 12)];
        rightImage.image = [UIImage imageNamed:@"icon_arrow_right_d"];
        cell.accessoryView = rightImage;
        cell.textLabel.textColor = DefaultColor;
        
    }
    
    if (indexPath.row > currentIndex) {//限制动画范围，只让当前屏幕显示的cell有动画
         isFristLoad = NO;
    }
    
       
       
    
    
   
    cell.textLabel.text = testArray[indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    switch (indexPath.row) {
        case 0:
        {
            //下拉放大
            [self.navigationController pushViewController:[DropEnlargeViewControler new] animated:NO];
        }
            break;
         case 1:
        {
            //导航栏渐变
            NavbarGradientViewController *navVC = [NavbarGradientViewController new];
            navVC.isGradient = YES;//yes 时为渐变，no为突变
            [self.navigationController pushViewController:navVC animated:NO];
            
        }
            break;
            
        case 2:
        {
            //刷新
        [self.navigationController pushViewController:[RefreshViewController new] animated:NO];
            break;
        }
            
        case 3:
        {
            //悬浮按钮
            [self.navigationController pushViewController:[SuspendViewController new] animated:NO];
            break;
        }
        case 4:
        {
            //轮播图
            [self.navigationController pushViewController:[CarouselViewController new] animated:NO];
            break;
        }
        case 5:{//评星
        
            [self.navigationController pushViewController:[StarViewController new] animated:NO];
            break;
        
        }
        case 6:{//输入格式化
            
            [self.navigationController pushViewController:[FormatterViewController new] animated:NO];
            break;
            
        }
        case 7:{//发散按钮
            
            [self.navigationController pushViewController:[DiffuseButtonViewController new] animated:NO];
            break;
            
        }
        case 8:{//播放gif动画
            
            [self.navigationController pushViewController:[GifPlayViewController new] animated:NO];
            break;
            
        }
        case 9:{//图片浏览
            
            [self.navigationController pushViewController:[ClickImageViewController new] animated:NO];
            break;
            
        }
        case 10:{//禁止复制
            
            [self.navigationController pushViewController:[NonCopyViewController new] animated:NO];
            break;
            
        }
        case 11:{//键盘自适应高度
            
            [self.navigationController pushViewController:[KeyboardViewController new] animated:NO];
            break;
            
        }
        case 12:{//图片裁剪
            
            [self.navigationController pushViewController:[CorpImageViewController new] animated:NO];
            break;
            
        }
        case 13:{//夜间模式
            
            [self.navigationController pushViewController:[NightModelViewController new] animated:NO];
            break;
            
        }
        case 14:{//果冻动画
            
            [self.navigationController pushViewController:[SpringViewController new] animated:NO];
            break;
            
        }
        case 15:{//QQ电话动画
            
            [self.navigationController pushViewController:[QQPhoneViewController new] animated:NO];
            break;
            
        }
        case 16:{//关机动画
            
            [self.navigationController pushViewController:[TurnOffViewController new] animated:NO];
            break;
            
        }
        case 17:{//3D
            
            [self.navigationController pushViewController:[CubeViewController new] animated:NO];
            break;
            
        }
        case 18:{//重力
            
            [self.navigationController pushViewController:[GravityViewController new] animated:NO];
            break;
            
        }
        case 19:{//calayer
            
            [self.navigationController pushViewController:[CalayerViewController new] animated:NO];
            break;
            
        }
        case 20:{//浏览图片
            
            [self.navigationController pushViewController:[CollectionViewController new] animated:NO];
            break;
            
        }
        case 21:{//辉光动画
            
            [self.navigationController pushViewController:[ShimmerViewController new] animated:NO];
            break;
            
        }
        case 22:{//放大动画
            
            [self.navigationController pushViewController:[ScaleViewController new] animated:NO];
            break;
            
        }
        case 23:{//tableview动画
            
            [self.navigationController pushViewController:[TableScaleViewController new] animated:NO];
            break;
            
        }

        default:
            break;
    }



}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (isFristLoad) {//动画只加载一次
       
        [self tableviewAnimation:tableView andCell:cell row:indexPath animationType:testType];
        
    }
    
    
    
    
}
#pragma mark 动画类型

- (void)tableviewAnimation:(UITableView *)tableView andCell:(UITableViewCell *)cell row:(NSIndexPath *)indexPath animationType:(NSUInteger)type {
    CGFloat tableWidth = tableView.bounds.size.width;
    CGFloat tableHeight = tableView.bounds.size.height;
    switch (type) {
            
        case 0://从上到下
        {
        
            
            cell.transform = CGAffineTransformMakeTranslation(0, -(tableHeight + cell.bounds.size.height));
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];

        }
            break;
        case 1://从下到上
        {
            
           
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case 2://从右到左
        {
           
            cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0);
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];

        
        }
            break;
        case 3://从左到右
        {
            
            cell.transform = CGAffineTransformMakeTranslation(-tableWidth, 0);
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
            
        }
            break;
        case 4://交叉动画
        {
           
            
                if (indexPath.row % 2 == 0) {
                    // left to right
                    cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0);
                } else {
                    // right to left
                    cell.transform = CGAffineTransformMakeTranslation(-tableWidth, 0);
                }
            

            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
            
        }
            break;
            
        case 5://交叉动画2
        {
            
            if (indexPath.row % 2 == 0) {
                // left to right
                cell.transform = CGAffineTransformMakeTranslation(tableWidth, tableHeight);
            } else {
                // right to left
                cell.transform = CGAffineTransformMakeTranslation(-tableWidth, tableHeight);
            }
            
            
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
            
        }
            break;
            
            case 6://3D
        {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -500;
            transform = CATransform3DTranslate(transform, -cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            transform = CATransform3DRotate(transform, M_PI/2, 0.0f, 1.0f, 0.0f);
            cell.layer.transform = CATransform3DTranslate(transform, cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            
            //下面两个时间都可以调整，看自己喜好
            [UIView animateWithDuration:.5 delay:0.005 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                
                
                
                
                cell.layer.transform = CATransform3DIdentity;
                cell.layer.opacity = 1.0f;
                
               
            } completion:^(BOOL finished) {
                
                
            }];
           
            
            
            
        }
            break;
            
            case 7://淡入,这个动画可以和前面移动的动画进行叠加
        {
            cell.layer.opacity = 0;
            
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                
                    cell.layer.opacity = 1.0f;
                
            } completion:^(BOOL finished) {
                
                
            }];

            
        }
            break;
            
        case 8://旋转加淡入
        {
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DTranslate(transform, -cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            transform = CATransform3DRotate(transform, -M_PI/2 * 2, 0.0f, 0.0f, 1.0f);
            cell.layer.transform = CATransform3DTranslate(transform, cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            cell.layer.opacity = 0;
            
            [UIView animateWithDuration:1.5 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                cell.layer.transform = CATransform3DIdentity;

                cell.layer.opacity = 1.0f;
                
            } completion:^(BOOL finished) {
                
                
            }];
            
            
        }
            break;
        case 9://跟3动画有些相似，这个是波浪形的动画
        {
            cell.layer.transform = CATransform3DMakeTranslation(-cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            [UIView animateWithDuration:1 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                
                cell.layer.transform = CATransform3DIdentity;
                
            } completion:^(BOOL finished) {
                
                
            }];
            
            
        }
            break;

            
        default:
            break;
    }
    
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
