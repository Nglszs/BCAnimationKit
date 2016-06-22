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

    self.title = @"下拉放大";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    testTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    [self.view addSubview:testTableView];
    
    testTableView.contentInset = UIEdgeInsetsMake(BCImageOriginHight, 0, 0, 0);
    
   
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -BCImageOriginHight, BCWidth, BCImageOriginHight)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        UIImage *newImage = [self creatBlur:[UIImage imageNamed:@"head.jpg"]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            headImage.image = newImage;
            cornerImage.image = [UIImage imageNamed:@"head.jpg"];
            
        });
    });
    
    
    
    cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake((BCWidth -100)/2, 50, 100, 100)];
    cornerImage.layer.cornerRadius = 50;
    cornerImage.clipsToBounds = YES;
    
   
    [headImage addSubview:cornerImage];
    [testTableView addSubview:headImage];
    
    
    
    

}

#pragma mark  UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 22;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = @"下拉放大";
    
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    CGFloat Value = scrollView.contentOffset.y;
    
    NSLog(@"%.2f",Value);
    
    if (Value <= -350) {//限制滚动范围
        
        Value = -350;
        testTableView.contentOffset = CGPointMake(0, Value);
    }
    
    
    if (Value < -BCImageOriginHight ) {
        
        headImage.frame = CGRectMake(0, Value, BCWidth,-Value);
        
        CGFloat zoomValue = MIN(1.5, ABS(Value + 200)/100);
      
        

        
        cornerImage.frame = CGRectMake((BCWidth - 100 * (1 + zoomValue))/2, (-Value -100 *(1 + zoomValue))/2, 100 * (1 + zoomValue), 100 *(1 + zoomValue));
        cornerImage.layer.cornerRadius =  100 *(1 + zoomValue)/2;
        
        
        
        //如果将headimage设为tableview的headview，调用下面的放大来计算height，但是用headview时会出现遮挡cell的情况，所以这里换了种实现方法
        //CGFloat zoomValue = ABS(Value)/BCImageOriginHight;
        //  headImage.height = BCImageOriginHight * (1 + zoomValue);
        
    }
    
       
}

#pragma mark 模糊处理

- (UIImage *)creatBlur:(UIImage *)oldImage {
    
    
    
    
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
