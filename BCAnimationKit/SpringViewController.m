//
//  SpringViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/11.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SpringViewController.h"
#define OriginRect CGRectMake(0, 0, BCWidth, 200)

#define TestHeight OriginRect.size.height
@interface SpringViewController ()
{
    CADisplayLink *displayLink;
    CGFloat tempPoint;
    
    UIView *testView;//过渡用的view
}
@property (nonatomic, strong) CAShapeLayer *testShapeLayer;
@end

@implementation SpringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //果冻实现原理就是在拖拽手势结束时。利用CADisplayLink获取过渡view的y值，然后改变path
    
    //声明定时器
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.paused = YES;
   
    //添加一个layer
    [self.view.layer addSublayer:self.testShapeLayer];
    
    //注册通知
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
    
    //声明过渡用的view
    testView = [[UIView alloc] init];
    [self.view addSubview:testView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        
        //释放定时器
        [displayLink invalidate];
        displayLink = nil;
    }


}

- (CAShapeLayer *)testShapeLayer {

    if (!_testShapeLayer) {
        
        //CAShapeLayer 必须给path
        _testShapeLayer = [CAShapeLayer layer];
        _testShapeLayer.frame = OriginRect;
        _testShapeLayer.fillColor = [UIColor orangeColor].CGColor;
      
        
        UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:OriginRect];
        _testShapeLayer.path = bPath.CGPath;
    }

    return _testShapeLayer;

}
- (void)panAction:(UIPanGestureRecognizer *)pan {

    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:pan.view];

        if (point.y > TestHeight) {//加上限制条件
        
            [self changePath:point.y];
            testView.frame = CGRectMake(BCWidth/2, point.y, 1, 1);
            
    
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
     
            displayLink.paused = NO;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        testView.frame = CGRectMake(BCWidth/2, TestHeight, 1, 1);
        
        
    } completion:^(BOOL finished) {
       
            displayLink.paused = YES;
        
       
    
    }];
    
    
    
    }
    
    
    
 }

- (void)calculatePath
{
    //必须找个媒介，使layer得形变成果冻效果，这里以一个透明的view为媒介
    CALayer *layer = testView.layer.presentationLayer;
    tempPoint =  layer.position.y;
    [self changePath:tempPoint];
}


#pragma mark 改变layer的形状
- (void)changePath:(CGFloat)point {
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointMake(0, 0)];
    [tPath addLineToPoint:CGPointMake(BCWidth, 0)];
    [tPath addLineToPoint:CGPointMake(BCWidth,  TestHeight)];
    
    //以中心点为弧线
    [tPath addQuadCurveToPoint:CGPointMake(0, TestHeight) controlPoint:CGPointMake(BCWidth/2, point)];
    [tPath closePath];
    self.testShapeLayer.path = tPath.CGPath;
    
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
