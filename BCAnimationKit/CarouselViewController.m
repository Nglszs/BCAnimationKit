//
//  CarouselViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CarouselViewController.h"
#define BCCount 3
#define BCFloat  45
@interface CarouselViewController ()<UIScrollViewDelegate>
{
    UIScrollView *testScrollview;
    UIPageControl *pageControl;
    NSTimer *testTime;
    CGFloat lastPoint;
}
@end

@implementation CarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"无限轮播";
    
    testScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight/2)];
    testScrollview.pagingEnabled = YES;
    testScrollview.showsHorizontalScrollIndicator = NO;
    testScrollview.showsVerticalScrollIndicator = NO;
    testScrollview.delegate = self;
    testScrollview.contentSize = CGSizeMake(BCWidth * BCCount, BCHeight/2);
    [self.view addSubview:testScrollview];
    
    
    NSArray *arr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
    for (int i = 0; i < BCCount; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BCWidth * i, 0, BCWidth, BCHeight/2)];
        imageView.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        [testScrollview addSubview:imageView];
        
    }
    
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    pageControl.center = self.view.center;
    pageControl.numberOfPages = BCCount;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor cyanColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [pageControl addTarget:self action:@selector(changePageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];

    
    //开启定时器
   
    [self loadTime];

}

- (void)loadTime {
    
    testTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pageChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:testTime forMode:NSRunLoopCommonModes];

}
- (void)pageChanged{
    
    //获取当前页面的索引
    NSInteger currentPage = pageControl.currentPage;
    //获取偏移量
    CGPoint offset = testScrollview.contentOffset;
    //
    if (currentPage >= BCCount - 1) {
        //将其设置首张图片的索引
        currentPage = 0;
        //恢复偏移量
        offset.x = 0;
        //NSLog(@"offset%f",offset.x);
    }else{
        //当前索引+1
        currentPage ++;
        //设置偏移量
        
        offset.x += BCWidth;
        
        //NSLog(@"offset.x====%f",offset.x);
    }
    //设置当前页
    pageControl.currentPage = currentPage;
    //设置偏移后的位置 加上动画过度
    [testScrollview setContentOffset:offset animated:YES];
   
    
}
#pragma mark  UIPageControl点击事件
- (void)changePageControl:(UIPageControl *)page {

    switch (page.currentPage) {
        case 0:
        {
        
            [testScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
           case 1:
            
        {
            
        [testScrollview setContentOffset:CGPointMake(BCWidth, 0) animated:YES];
        }
            break;
        default:
        {
        [testScrollview setContentOffset:CGPointMake(BCWidth * (BCCount - 1), 0) animated:YES];
        
        }
            break;
    }
    

}

#pragma mark UIScrollView代理

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    lastPoint = scrollView.contentOffset.x;

    [testTime invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    [self loadTime];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    
    //人为滑动时,让他可以首尾滑动,同时计算pagecontrol的位置
    
    
    NSInteger index = scrollView.contentOffset.x/BCWidth;
    
    if (scrollView.contentOffset.x >(BCWidth * 2 + BCFloat)) {
        
        index = 0;
         [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    } else if (scrollView.contentOffset.x < -BCFloat) {
        
        index = BCCount -1;
    [scrollView setContentOffset:CGPointMake(BCWidth * (BCCount - 1), 0) animated:YES];
        
    
    } else if (lastPoint < scrollView.contentOffset.x) {//向右滑
        
        index += 1;
    
    }
    pageControl.currentPage = index;

}

#pragma mark  释放time

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        
        [testTime invalidate];
        testTime = nil;
        
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
