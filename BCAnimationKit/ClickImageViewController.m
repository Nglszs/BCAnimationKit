//
//  ClickImageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ClickImageViewController.h"
#define BCTime  0.8
#define BCCount 2

#define BCTag 10086
@interface ClickImageViewController ()<UIScrollViewDelegate>
{
    UIImageView *clickImage;
    NSArray *imageArray;
    UIScrollView *backgroundView;
    UIScrollView *contentScrollView;
    
    CGRect newRect;
    CGFloat imageWidth;
    CGFloat imageHeight;
    UIWindow *showWindow;
    NSInteger index;
    CGFloat offset;
}


@end

@implementation ClickImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   //大概花了两三天的时间去做这个功能，这是我目前为止花费时间最长的功能，但是仍然有部分缺陷
    imageArray = @[@"bc1.jpg",@"head.jpg"];
    for (int i = 0; i < BCCount; i ++) {
        
        //这里自己封装的时候，完全可以继承imageview然后在内部添加点击事件即可，我这里简单使用
       UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100 + 220 * i, 200, 200)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = BCTag + i;
        
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        
        [imageView addGestureRecognizer:tap];
        
    }

    
   
    
    
    

}

- (void)tapGesture:(UITapGestureRecognizer *)sender {

    
    
    UIImageView *newImage = (UIImageView *)sender.view;
    showWindow = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[UIScrollView alloc] initWithFrame:BCScreen];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    backgroundView.delegate = self;
    backgroundView.pagingEnabled = YES;
    backgroundView.contentSize = CGSizeMake(BCWidth * BCCount, BCHeight);
    
   [backgroundView setContentOffset:CGPointMake(BCWidth * (newImage.tag - BCTag), 0) animated:YES];
    
    
    for (int i = 0; i < BCCount; i ++) {
        
        //加关闭手势
        UITapGestureRecognizer *shutGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shutView:)];
        shutGesture.numberOfTapsRequired = 1;
        
        //双击放大
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BCWidth * i, 0, BCWidth, BCHeight)];
        scrollView.delegate = self;
        scrollView.tag = 10000 + i;
        scrollView.minimumZoomScale = .6;
        scrollView.maximumZoomScale = 3;
       
        scrollView.zoomScale = 1.0;
        //添加手势
        [scrollView addGestureRecognizer:shutGesture];
        [scrollView addGestureRecognizer:doubleTapGestureRecognizer];
        [shutGesture requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        
        UIImageView *showImage = (UIImageView *)[self.view viewWithTag:BCTag + i];
        
        
        
       CGFloat tempWidth = showImage.image.size.width;
       CGFloat tempHeight = showImage.image.size.height;
       
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (BCHeight - BCWidth/tempWidth * tempHeight)/2, BCWidth, BCWidth/tempWidth * tempHeight)];
        
        
        imageView.tag = 10010 + i;
        imageView.image = showImage.image;
    
        
        
        if (showImage.tag == sender.view.tag) {
            
            index = i;
             newRect = [newImage convertRect:newImage.bounds toView:showWindow];
            imageView.frame = newRect;
            
            clickImage = imageView;
            
            [UIView animateWithDuration:BCTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                //图片居中,这里以宽度为填充标准
                
                
                imageView.frame = CGRectMake(0, (BCHeight - tempHeight * BCWidth / tempWidth)/2, BCWidth,tempHeight * BCWidth / tempWidth);
                
                
                
                backgroundView.alpha = 1;
                
                
            } completion:^(BOOL finished) {
                
            }];

        }
        
        [scrollView addSubview:imageView];
        
        [backgroundView addSubview:scrollView];
        
    }
    
        [showWindow addSubview:backgroundView];
    
    
}


- (void)shutView:(UITapGestureRecognizer *)tap {

   
    UIScrollView *sc = (UIScrollView *)tap.view;
    
    [UIView animateWithDuration:BCTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        sc.zoomScale = 1;
        clickImage.frame = newRect;
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        backgroundView = nil;
        clickImage = nil;
        
        
    }];
    

 

}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
   
    
   
   
    
    

    if (scrollView == backgroundView) {//移动时变回正常的比例

        index = scrollView.contentOffset.x/BCWidth + 10010;
        
        //获取当前显示的imageview
        clickImage = (UIImageView *)[backgroundView viewWithTag:index];
        UIImageView *newImage = (UIImageView *)[self.view viewWithTag:index + 76];
        newRect = [newImage convertRect:newImage.bounds toView:showWindow];
        
        
        for (UIScrollView *s in scrollView.subviews){
            if ([s isKindOfClass:[UIScrollView class]]){
                [s setZoomScale:1.0];
            }
        }

    }



}

- (void)doubleTap:(UITapGestureRecognizer *)gesture {

        UIScrollView *scrollview = (UIScrollView *)gesture.view;
      CGPoint touchPoint = [gesture locationInView:scrollview];
   
    if (scrollview.zoomScale <= 1.0) {
        
        //这里还有优化的余地，他不能居中
        CGFloat scaleX = touchPoint.x + scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + scrollview.contentOffset.y;//需要放大的图片的Y点
        [scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
      
    } else {
        [scrollview setZoomScale:1.0 animated:YES]; //还原
    }
    
    
}




#pragma mark 缩放代理
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    for (UIView *testView in scrollView.subviews) {
        return testView;
    }
   
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    
    
    [scrollView.subviews lastObject].center = [self centerOfScrollViewContent:scrollView];;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    
    
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
