//
//  ViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/3.
//  Copyright © 2016年 毕研超. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
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
#import "MessageViewController.h"
#import "SpeechViewController.h"
#import "ValueChangeViewController.h"
#import "ShowPageViewController.h"
#import "LoadImageViewController.h"
#import "TransformViewController.h"
#import "PuchaseCarViewController.h"
#import "SectionViewController.h"
#import "SpeechToTextViewController.h"
#import "AddPhotoViewController.h"
#import "CustomViewController.h"
#import "ClickAttentionViewController.h"
#import "CRMotionViewController.h"
#import "TableAnimationViewController.h"
#import "ChartViewController.h"
#import "WebImageViewController.h"



@interface ViewController ()
{

    UITableView *testTableView;
    NSArray *testArray;
    UIImageView *headImage;
    BOOL isFristLoad;//加个动画
    NSUInteger currentIndex;
    NSUInteger testType;//动画类型
    
    CGFloat motionOffset;
    NSTimer *time;

}


@property (strong,nonatomic) CMMotionManager *motionManager;//重力滚动相关
@property (nonatomic, assign) NSInteger maximumOffset;//最大偏移
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

     testArray = @[@"下拉放大",@"导航栏渐变",@"上拉和下拉刷新",@"点击按钮弹出气泡",@"无限轮播",@"评星",@"输入格式化",@"发散按钮",@"播放Gif动画",@"图片浏览",@"禁止复制/粘贴",@"键盘自适应高度",@"图片裁剪",@"夜间模式",@"果冻动画",@"QQ电话动画",@"关机动画",@"3D浏览图片",@"重力及碰撞",@"Calayer及其子类",@"CollectionView浏览图片",@"辉光动画",@"放大动画",@"Tableview展开",@"聊天界面",@"语音转文字",@"数值改变动画",@"引导页",@"图片加载动画",@"转场动画",@"淘宝购物车",@"分段视图",@"文字转语音",@"添加图片",@"View绕某点转动",@"点赞动画",@"摇晃浏览图片",@"TableView效果",@"图表视图",@"显示网页上的图片"];
    
    
    
    currentIndex = testTableView.bounds.size.height/44 - 2;
    
    
    
//    //跳转到上次缓存的界面
//    NSString *skipVC = [[NSUserDefaults standardUserDefaults] objectForKey:@"MAIN"];
//    if (skipVC != nil) {
//        
//        UIViewController *newVC = [NSClassFromString(skipVC) new];
//        [self.navigationController pushViewController:newVC animated:NO];
//        
//        //每跳转一次 清空一次
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MAIN"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        
//    }
// 
//
    
    //这个是用重力来控制列表的滑动，这里已经不用，还有些瑕疵

  // [self initMotion];
   
   }

#pragma mark 重力滚动相关
- (void)initMotion {

    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    
    
   time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(RoundRobinTableview) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
  
}

- (void)RoundRobinTableview {

    if (testTableView.isDragging || testTableView.isDecelerating) {
        
        [self.motionManager stopDeviceMotionUpdates];
        
        
    } else {
        
       
            
            [self startAccelerometer];

      
        
    }
    
}

-(void)startAccelerometer
{
    
    
    
    
     if (![_motionManager isGyroActive] && [_motionManager isGyroAvailable]) {
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
       // double gravityX = motion.gravity.x;
        double gravityY = motion.gravity.y;
        //double gravityZ = motion.gravity.z;
        
        
       
        
        double motionDataY = atan2(gravityY,1.0)/M_PI * 360.0;//绕y方向旋转的角度
        //double xTheta = atan2(gravityX,1.0)/M_PI * 360.0;//绕x方向旋转的角度
        
        
        
       
        
        motionOffset = _maximumOffset/ 90 * motionDataY;
        
       
        
        if (motionDataY > -30) {
            
            motionOffset = 64;
            
        } else if (motionDataY <= -60) {
        
            motionOffset = -_maximumOffset;
        
        }
        
        NSLog(@"%.2f==%.2f",motionOffset,motionDataY);
     
       [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^{
        
           [testTableView setContentOffset:CGPointMake(0, -motionOffset) animated:NO];
           
           
       } completion:nil];
        
        
    }];

     }
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _maximumOffset = testTableView.contentSize.height - testTableView.frame.size.height;
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    //停止加速仪更新
    [self.motionManager stopAccelerometerUpdates];


}



-(void)receiveNotification:(NSNotification *)notification
{
    if ([notification.name
         isEqualToString:UIApplicationDidEnterBackgroundNotification])
    {
        [self.motionManager stopDeviceMotionUpdates];
        
    }else{
        
        [self startAccelerometer];
        
    }}

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
        
        //这里对图片进行渲染成其他颜色
        UIImage *image = [[UIImage imageNamed:@"icon_arrow_right_d"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //UIImageRenderingModeAlwaysTemplate的意思始终根据Tint Color绘制图片，忽略图片的颜色信息
        
        
        [rightImage setImage:image];
        [rightImage setTintColor:RandomColor];
        
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
            
            //由于CATranstion的私有API里的动画并不能通过审核，这里用uiview 的动画来实现
            [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
            [self.navigationController pushViewController:[FormatterViewController new] animated:NO];
            } completion:nil];
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
        case 24:{//聊天界面
            
            [self.navigationController pushViewController:[MessageViewController new] animated:NO];
            break;
            
        }
        case 25:{//语音转文字
            
            [self.navigationController pushViewController:[SpeechViewController new] animated:NO];
            break;
            
        }
            
        case 26:{//数值动画
            
            [self.navigationController pushViewController:[ValueChangeViewController new] animated:NO];
            break;
            
        }
        case 27:{//引导页
            
            [self.navigationController pushViewController:[ShowPageViewController new] animated:NO];
            break;
            
        }
        case 28:{//图片加载动画
            
            [self.navigationController pushViewController:[LoadImageViewController new] animated:NO];
            break;
            
        }
        case 29:{//转场动画
            
            CATransition *testAnimation = [CATransition animation];
            testAnimation.duration = .5;
            
            //这些开放的api均支持方向设置
            //testAnimation.type = kCATransitionPush;//新视图退出旧视图,可以用来实现类似于presentate的效果
            // testAnimation.type = kCATransitionFade;//淡入
            testAnimation.type = kCATransitionMoveIn;//新视图移动到旧视图
            //testAnimation.type = kCATransitionReveal;//移开旧视图推出新视图，最好配合左边和右边，这个和第一个有些类似，但实现思路不一样
            
            //下面是私有API
            //testAnimation.type = @"cube";//3D，支持方向
            //testAnimation.type = @"oglFlip";//翻转效果，类似于硬币，支持方向
            // testAnimation.type = @"suckEffect";//收缩到一个地方，不支持方向
            //testAnimation.type = @"rippleEffect";//水波动画，但不适合跳转控制器，适合普通页面，不支持方向
            //  testAnimation.type = @"pageCurl";//书本的翻页效果。支持方向
            // testAnimation.type = @"pageUnCurl";//也是翻页，支持方向
            //testAnimation.type = @"cameralIrisHollowOpen";//摄像头打开效果，不支持方向
            // testAnimation.type = @"cameraIrisHollowClose";//摄像头关闭效果，不支持方向
            
            
            
            testAnimation.subtype = kCATransitionFromRight;//动画开始位置
            testAnimation.removedOnCompletion = YES;
            [self.navigationController.view.layer addAnimation:testAnimation forKey:nil];
            [self.navigationController pushViewController:[TransformViewController new] animated:NO];
            break;
            
        }
        case 30:{//购物车动画
            
            [self.navigationController pushViewController:[PuchaseCarViewController new] animated:NO];
            break;
            
        }
        case 31:{//分段视图
            
            [self.navigationController pushViewController:[SectionViewController new] animated:NO];
            break;
            
        }
        case 32:{//文字转语音
            
            [self.navigationController pushViewController:[SpeechToTextViewController new] animated:NO];
            break;
            
        }
        case 33:{//添加图片
            
            [self.navigationController pushViewController:[AddPhotoViewController new] animated:NO];
            break;
            
        }
        case 34:{//自定义图片浏览
            
            [self.navigationController pushViewController:[CustomViewController new] animated:NO];
            break;
            
        }
        case 35:{//点赞动画
            
            [self.navigationController pushViewController:[ClickAttentionViewController new] animated:NO];
            break;
            
        }
        case 36:{//滚动图片
            
            [self.navigationController pushViewController:[CRMotionViewController new] animated:NO];
            break;
            
        }
        case 37:{//tableview动画
            
            [self.navigationController pushViewController:[TableAnimationViewController new] animated:NO];
            break;
            
        }
        case 38:{//网格视图
            
            [self.navigationController pushViewController:[ChartViewController new] animated:NO];
            break;
            
        }
        case 39:{//显示网页上的图片
            
            [self.navigationController pushViewController:[WebImageViewController new] animated:NO];
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
            
            case 6://3D，这个动画和万象城一样，不过万象城是没有delay时间的，而且duration都为.5
        {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -500;
            transform = CATransform3DTranslate(transform, -cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            transform = CATransform3DRotate(transform, M_PI/2, 0.0f, 1.0f, 0.0f);
            cell.layer.transform = CATransform3DTranslate(transform, cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
            
            //下面duration和delay时间可以自己调整，看自己需求
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

        case 10://放大
        {
            cell.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:1 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                
                cell.transform = CGAffineTransformMakeScale(1, 1);
                
            } completion:^(BOOL finished) {
                
                
            }];
            
            
        }
            break;
        case 11://逐渐放大,这个以后待改进，我想要的效果类似于滚轮那种，现在还没有实现
            
        {
             CGFloat gapX = CGRectGetMidY(self.view.frame) - CGRectGetMidY(cell.frame);
            // 根据间距值计算 cell的缩放比例
            CGFloat scale = 1 - ABS(gapX) / BCWidth;
            
            // 设置缩放比例
            cell.transform = CGAffineTransformMakeScale(scale, scale);
            
            [UIView animateWithDuration:1 delay:0.05 * indexPath.row usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
                
                cell.transform = CGAffineTransformMakeScale(1, 1);
                
            } completion:^(BOOL finished) {
                
                
            }];

            

            
        }
            break;

        default:
            break;
    }
    
  

}



- (void)dealloc {


    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
