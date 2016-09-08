//
//  CarouselViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CarouselViewController.h"
#define BCCount 5
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
    
    //轮播两种方式，第一种是首尾加上图片，如果显示3个image，那其实是创建了5个，第二种，就是每次滑动都将当前的imageview重新添加到视图当中，显示几个image就创建几个image
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"无限轮播";
    
    testScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight/2)];
    testScrollview.pagingEnabled = YES;
    testScrollview.showsHorizontalScrollIndicator = NO;
    testScrollview.showsVerticalScrollIndicator = NO;
    testScrollview.delegate = self;
    testScrollview.contentSize = CGSizeMake(BCWidth * BCCount, BCHeight/2);
    [self.view addSubview:testScrollview];
    
    
    NSArray *arr = @[@"head.jpg",@"bc.jpg",@"bc1.jpg",@"head.jpg",@"bc.jpg"];//这里创建5个图片
    for (int i = 0; i < arr.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BCWidth * i, 0, BCWidth, BCHeight/2)];
        imageView.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        [testScrollview addSubview:imageView];
        
    }
    
    
    [testScrollview setContentOffset:CGPointMake(BCWidth, 0) animated:YES];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    pageControl.center = self.view.center;
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [pageControl addTarget:self action:@selector(changePageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];

    
    //开启定时器
   
    [self loadTime];

}

- (void)loadTime {
    
    testTime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(pageChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:testTime forMode:NSRunLoopCommonModes];

}
- (void)pageChanged{
    
    NSInteger page = pageControl.currentPage;
    page++;
    if (page == 4) {//当到了第四页，偷偷回到第二张图一，page至为0
        page = 0;
        [testScrollview scrollRectToVisible:CGRectMake(testScrollview.contentSize.width - 2 * testScrollview.bounds.size.width, 0, testScrollview.bounds.size.width, testScrollview.bounds.size.height) animated:NO];
    }
    
    [testScrollview scrollRectToVisible:CGRectMake((page+1) * testScrollview.bounds.size.width, 0, testScrollview.bounds.size.width, testScrollview.bounds.size.height) animated:YES];
    
    
}
#pragma mark  UIPageControl点击事件
- (void)changePageControl:(UIPageControl *)page {

    [testScrollview scrollRectToVisible:CGRectMake(testScrollview.bounds.size.width *(pageControl.currentPage+1), 0, testScrollview.bounds.size.width, testScrollview.bounds.size.height) animated:YES];

}

#pragma mark UIScrollView代理

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [testTime invalidate];
    testTime = nil;


}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    
        [self loadTime];
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        //用户滑到一号位置，显示第三张图，必须跳转到倒数第二个3.png
        [scrollView scrollRectToVisible:CGRectMake(scrollView.contentSize.width - 2 * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height) animated:NO];
    }
    //用户滑到最后位置，显示第一张图，必须跳转到第二个1.png
    if (scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.size.width) {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height) animated:NO];
        
    }
    
    NSInteger page = scrollView.contentOffset.x /self.view.frame.size.width;
    [pageControl setCurrentPage:page-1];
    
    
}// called when scroll view grinds to a halt


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

#pragma mark  第二种实现的方法，这个比第一个方便

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    testScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight/2)];
//    testScrollview.pagingEnabled = YES;
//    testScrollview.showsHorizontalScrollIndicator = NO;
//    testScrollview.showsVerticalScrollIndicator = NO;
//    testScrollview.delegate = self;
//    testScrollview.contentSize = CGSizeMake(BCWidth * 3, BCHeight/2);
//    [self.view addSubview:testScrollview];
//    imagearr = [[NSMutableArray alloc] init];
//    NSArray *arr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
//    for (int i = 0; i < 3; i ++) {
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BCWidth * i, 0, BCWidth, BCHeight/2)];
//        imageView.image = [UIImage imageNamed:[arr objectAtIndex:i]];
//        imageView.tag = 10000 + i;
//        [testScrollview addSubview:imageView];
//        
//        [imagearr addObject:imageView];
//    }
//    
//    
//    //这里不再加上点击事件
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    pageControl.center = self.view.center;
//    pageControl.numberOfPages = 3;
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    [self.view addSubview:pageControl];
//    
//    currentView = [[NSMutableArray alloc] init];
//    currentPage = 0;
//    
//    [self loadDta];
//    
//    [self loadTime];
//    
//}
//
//- (void)loadTime {
//    
//    testTime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(pageChanged) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:testTime forMode:NSRunLoopCommonModes];
//    
//}
//
//- (void)pageChanged{
//    
//    
//    
//    [testScrollview setContentOffset:CGPointMake(BCWidth * 2, 0) animated:YES];
//    
//    
//}
//
//
//- (void)loadDta {
//    
//    
//    pageControl.currentPage = currentPage;
//    
//    NSArray *subViews = [testScrollview subviews];
//    
//    if([subViews count] != 0) {
//        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
//    
//    //获得当前要展示的image
//    
//    [self getDisplayImagesWithCurpage:currentPage];
//    for (int i = 0; i < 3; i++) {
//        UIImageView *showImage = [currentView objectAtIndex:i];
//        showImage.frame = CGRectMake(BCWidth * i, 0, BCWidth, BCHeight/2);
//        
//        
//        //可以在这里加上手势
//        [testScrollview addSubview:showImage];
//        
//        
//        
//    }
//    
//    [testScrollview setContentOffset:CGPointMake(testScrollview.frame.size.width, 0)];
//    
//    
//    
//}
//
//
//- (void)getDisplayImagesWithCurpage:(NSInteger)page {
//    
//    NSInteger pre = [self validPageValue:currentPage -1];
//    NSInteger last = [self validPageValue:currentPage +1];
//    
//    
//    
//    [currentView removeAllObjects];
//    // NSLog(@"%ld--%ld--%ld",pre,page,last);
//    
//    [currentView addObject:[imagearr objectAtIndex:pre]];
//    [currentView addObject:[imagearr objectAtIndex:page]];
//    [currentView addObject:[imagearr objectAtIndex:last]];
//    
//    
//}
//
//- (NSInteger)validPageValue:(NSInteger)value {
//    
//    
//    
//    if(value == -1) value = 3 - 1 ;
//    if(value == 3) value = 0;
//    
//    return value;
//    
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    NSInteger pointSet = scrollView.contentOffset.x;
//    if (pointSet >= BCWidth * 2) {
//        currentPage = [self validPageValue:currentPage + 1];
//        [self loadDta];
//        
//    }
//    
//    
//    if (pointSet <= 0) {
//        currentPage = [self validPageValue:currentPage - 1];
//        [self loadDta];
//    }
//    
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//    [testTime invalidate];
//    testTime = nil;
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    
//    [self loadTime];
//    
//}


#pragma mark  第三种实现的方法

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
    //加上colle两个代理即可 不需要其他
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsZero;
//    
//    //设置item大小
//    layout.itemSize = CGSizeMake(BCWidth, BCHeight/2);
//    layout.minimumLineSpacing = 0;
//    
//    testCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight/2) collectionViewLayout:layout];
//    testCollectionView.delegate = self;
//    testCollectionView.dataSource = self;
//    testCollectionView.backgroundColor = [UIColor whiteColor];
//    testCollectionView.showsHorizontalScrollIndicator = NO;
//    testCollectionView.showsVerticalScrollIndicator = NO;
//    testCollectionView.pagingEnabled = YES;
//    testCollectionView.bounces = NO;
//    [testCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
//    [self.view addSubview:testCollectionView];
//    
//    //这里不再加上点击事件
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    pageControl.center = self.view.center;
//    pageControl.numberOfPages = 3;
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    [self.view addSubview:pageControl];
//    
//    currentView = [[NSMutableArray alloc] init];
//    currentPage = 0;
//    
//    imagearr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
//    
//    [self loadTime];
//    
//}
//
//- (void)loadTime {
//    
//    testTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pageChanged) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:testTime forMode:NSRunLoopCommonModes];
//    
//}
//- (void)removeTimer
//{
//    // 停止定时器
//    [testTime invalidate];
//    testTime = nil;
//}
//- (NSIndexPath *)resetIndexPath
//{
//    // 获取当前展示的位置
//    NSIndexPath *currentIndexPath = [[testCollectionView indexPathsForVisibleItems] lastObject];
//    // 得到最中间那组的位置
//    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:10/2];
//    [testCollectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    return currentIndexPathReset;
//}
//- (void)pageChanged{
//    
//    
//    
//    // 1.显示回最中间那组的数据
//    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
//    
//    // 2.计算出下一个需要展示的位置
//    NSInteger nextItem = currentIndexPathReset.item + 1;
//    NSInteger nextSection = currentIndexPathReset.section;
//    if (nextItem == imagearr.count) {
//        nextItem = 0;
//        nextSection++;
//    }
//    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
//    
//    // 3.滚动到下一个位置
//    [testCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    
//    
//}
//
//
//#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return imagearr.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 10;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.backgroundColor = [UIColor purpleColor];
//    imageView.image = [UIImage imageNamed:imagearr[indexPath.item]];
//    
//    imageView.frame = CGRectMake(0, 0 , cell.frame.size.width, cell.frame.size.height);
//    [cell.contentView addSubview:imageView];
//    
//    return cell;
//}
//
//
//#pragma mark  - UICollectionViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self removeTimer];
//}
//
///**
// *  停止拖拽调用
// */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self loadTime];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % imagearr.count;
//    pageControl.currentPage = page;
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSLog(@"点击了");
//    
//}
//

#pragma mark 当把定时器封装成一个view时。要在自定义view内部实现下面方法

//在VC中使用自定义view轮播图，当vc出栈时他会立即执行dealloc，但此时自定义view里的定时器并没有释放，所以必须用下面的方法。

//但是如果当前vc有定时器而且没释放，那vc不会走dealloc，这两个就这个区别。。。很奇怪

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    
//    if (!newSuperview) {
//        NSLog(@"释放定时器");
//        
//        [time invalidate];
//        time = nil;
//        
//    }
//    
//}



@end
