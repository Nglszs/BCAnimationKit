//
//  DropEnlargeViewControler.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "DropEnlargeViewControler.h"

@implementation DropEnlargeViewControler
- (void)viewDidLoad {

    [super viewDidLoad];

    
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BCWidth, BCHeight - 64) style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    testTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:testTableView];
    
    testTableView.contentInset = UIEdgeInsetsMake(BCImageOriginHight - 64, 0, 0, 0);
    
   
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCImageOriginHight)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        UIImage *newImage = [self creatBlur:[UIImage imageNamed:@"head.jpg"]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            headImage.image = newImage;
            cornerImage.image = [UIImage imageNamed:@"head.jpg"];
            
            NSLog(@"加载成功");
            
        });
    });
    
    
    
    cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake((BCWidth -100)/2, 50, 100, 100)];
    cornerImage.layer.cornerRadius = 50;
    cornerImage.clipsToBounds = YES;
    
   
    [headImage addSubview:cornerImage];
   // [testTableView addSubview:headImage];//会随着tableview滚动，这种适合下拉放大，不适合上拉缩小，如果用这种实现下拉放大，那就得参考改变headimage起点也为负的-height，同时改变tableview的inset为hegiht
      [self.view insertSubview:headImage belowSubview:testTableView];//这个就不会
    
    
    

}

- (void)viewWillAppear:(BOOL)animated {//导航栏透明
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];


}

- (void)viewWillDisappear:(BOOL)animated {//恢复原样
    [super viewWillDisappear:animated];
    
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
  


}
#pragma mark  UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = @"下拉放大和上拉缩小";
    
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    CGFloat Value = scrollView.contentOffset.y;
    
    
    if (Value <= -236) {//下拉限制滚动范围,计算方法根据下面缩放比例
        
        Value = -236;
        testTableView.contentOffset = CGPointMake(0, Value);
    }
    
    //这里136是初始偏移量
   if (Value <= -136) {//放大
        
        headImage.frame = CGRectMake(0, 0, BCWidth,-(Value + 136) + BCImageOriginHight);
        
        CGFloat zoomValue = MIN(1.0, ABS(Value + 136)/100);
      
       

        
        cornerImage.frame = CGRectMake((BCWidth - 100 * (1 + zoomValue))/2, (CGRectGetHeight(headImage.frame)  -100 *(1 + zoomValue))/2, 100 * (1 + zoomValue), 100 *(1 + zoomValue));
        
        
        cornerImage.layer.cornerRadius =  100 *(1 + zoomValue)/2;
        
        
       
   } else {//缩小
    
       
       if (Value >= 0) {
           
           headImage.frame = CGRectMake(0, 0, BCWidth,64);
           cornerImage.frame = CGRectMake((BCWidth - 50)/2, (64 -50)/2, 50, 50);
           cornerImage.layer.cornerRadius =  25;
           return;

       }
       headImage.frame = CGRectMake(0, 0, BCWidth,-(Value + 136) + BCImageOriginHight);
       CGFloat zoomValue = MIN(0.5, (Value + 136)/200);//这里本来是100，但这里为了减小缩小的速率，所以只能增大分母了
       
       

       cornerImage.frame = CGRectMake((BCWidth - 100 * (1 - zoomValue))/2, (CGRectGetHeight(headImage.frame)  -100 *(1 - zoomValue))/2, 100 * (1 - zoomValue), 100 *(1 - zoomValue));
       
       
       cornerImage.layer.cornerRadius =  100 *(1 - zoomValue)/2;

   }
    
       
}

#pragma mark 模糊处理


//此方法较慢
- (UIImage *)creatBlur:(UIImage *)oldImage {
    
    /**
     CIGaussianBlur 高斯模糊
     CIBoxBlur 均值模糊  iOS9以后
     CIDiscBlur 环形卷积模糊 9以后
     CIMedianFilter 中指模糊 9 不能设置radius
     CIMotionBlur 运动模糊 9
     */
     
     
     
   
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:oldImage.CGImage];
    CGImageRef renderImage;
    //iOS 8以后的模糊生成方法,iOS8以前的自行百度
    if (NSFoundationVersionNumber >= 1140.11) {
        CIImage *filtered = [inputImage imageByClampingToExtent];
        
        filtered = [filtered imageByApplyingFilter:@"CIGaussianBlur" withInputParameters:@{kCIInputRadiusKey:@20}];
        
        filtered = [filtered imageByCroppingToRect:inputImage.extent];
        
        renderImage = [context createCGImage:filtered fromRect:inputImage.extent];
        
        
    }
    
    UIImage *newImage = [UIImage imageWithCGImage:renderImage];
    CGImageRelease(renderImage);
    
    return newImage;
}


@end
