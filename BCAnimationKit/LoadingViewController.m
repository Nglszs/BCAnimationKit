//
//  LoadingViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/13.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "LoadingViewController.h"
#import <math.h>
@interface LoadingViewController ()


@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self animation1];
    [self animation2];
    [self animation3];
    [self animation4];
    [self animation5];
    [self animation6];
    
    
}
- (void)animation1 {

    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = CGPointMake(100, 150);
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = 1.0/6;//这里必须是精度为0.1
    replicatorLayer.masksToBounds   = YES;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0);//间隔
    [self.view.layer addSublayer:replicatorLayer];
   
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 10, 10);
    layer.position = CGPointMake((CGRectGetWidth(replicatorLayer.frame) - 40)/2, replicatorLayer.frame.size.height/2 );
    layer.cornerRadius = 5;
    layer.backgroundColor = GreenColor.CGColor;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    [replicatorLayer addSublayer:layer];
  
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [layer addAnimation:animation forKey:nil];

}

- (void)animation2 {

   
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = CGPointMake(250, 150);
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.masksToBounds   = YES;
    replicatorLayer.instanceDelay = 1.0 / 10;
    replicatorLayer.instanceCount = 10;
   
    [self.view.layer addSublayer:replicatorLayer];
    //这里只是缩小，但是视觉上的效果是旋转
    replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / 10, 0, 0, 1.0);//设置每个副本的位置
    

    
    
    CALayer *layer = [CALayer layer];
    layer.frame =  CGRectMake(25, 15, 10, 10);

    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    [replicatorLayer addSublayer:layer];
    
    

    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    
    
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [layer addAnimation:animation forKey:nil];


}

- (void)animation3 {


    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = CGPointMake(100, 300);
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.masksToBounds   = YES;
   
    [self.view.layer addSublayer:replicatorLayer];
    
    
    
    CGFloat count = 4;
    CGFloat lineH = 50;
    CGFloat lineMarginX = 30;
    CGFloat lineInter = 10;
    CGFloat lineW = 5;
    
    //2.创建CALayer对象
    CALayer *lineLayer        = [CALayer layer];
    lineLayer.bounds          = CGRectMake(0, 0, lineW, lineH);
    lineLayer.position        = CGPointMake(lineMarginX +lineW, CGRectGetHeight(replicatorLayer.frame) - lineH/2);
    lineLayer.backgroundColor = RandomColor.CGColor;
    
    [replicatorLayer addSublayer:lineLayer];
    
    
    replicatorLayer.instanceCount = count;
     replicatorLayer.instanceDelay = 0.5 / count;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(lineInter, 0, 0);
    
    
    
    //3.设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.toValue           = @(lineH*0.4);
    animation.duration          = 0.5;
    animation.autoreverses      = YES;
    animation.repeatCount       = MAXFLOAT;
    
    [lineLayer addAnimation:animation forKey:nil];
    
   

}

- (void)animation4 {

    //声明容器
    CALayer *containerLayer = [CALayer layer];//这个动画最好配底色为粉色,然后layer为白色，我这里改为绿色适应白色底
    containerLayer.frame = CGRectMake(0, 0, 100, 100);
    containerLayer.position = CGPointMake(250, 300);
  
    [self.view.layer addSublayer:containerLayer];
    
    CGFloat width = CGRectGetWidth(containerLayer.frame);
    CGFloat height = CGRectGetHeight(containerLayer.frame)/2;
    
    //声明顶部的layer
    UIBezierPath *pathTop = [UIBezierPath bezierPath];
    [pathTop moveToPoint:CGPointZero];
    [pathTop addLineToPoint:CGPointMake(width, 0)];    [pathTop addLineToPoint:CGPointMake(width / 2.0f, height)];
    [pathTop addLineToPoint:CGPointMake(0, 0)];
    [pathTop closePath];
    
    
    CAShapeLayer *_topLayer = [CAShapeLayer layer];
    _topLayer.frame = CGRectMake(0, 0, width, height);
    _topLayer.path = pathTop.CGPath;
    _topLayer.fillColor = [UIColor greenColor].CGColor;
    _topLayer.strokeColor = [UIColor whiteColor].CGColor;
    _topLayer.lineWidth = 0.0f;
    _topLayer.anchorPoint = CGPointMake(0.5f, 1);
    _topLayer.position = CGPointMake(width / 2.0f, height);
    [containerLayer addSublayer:_topLayer];
    
    //声明底部的layer
    UIBezierPath *pathBottom = [UIBezierPath bezierPath];
    [pathBottom moveToPoint:CGPointMake(width / 2, 0)];
    [pathBottom addLineToPoint:CGPointMake(width, height)];
    [pathBottom addLineToPoint:CGPointMake(0, height )];
    [pathBottom addLineToPoint:CGPointMake(width / 2, 0)];
    
    [pathBottom closePath];
    
   
   CAShapeLayer *_bottomLayer = [CAShapeLayer layer];
    _bottomLayer.frame = CGRectMake(0, height, width, height);
    _bottomLayer.path = pathBottom.CGPath;
    _bottomLayer.fillColor = [UIColor greenColor].CGColor;
    _bottomLayer.strokeColor = [UIColor whiteColor].CGColor;
    _bottomLayer.lineWidth = 0.0f;
    _bottomLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
    _bottomLayer.position = CGPointMake(width / 2.0f, height * 2.0f);
    _bottomLayer.transform = CATransform3DMakeScale(0, 0, 0);
    
    [containerLayer addSublayer:_bottomLayer];

    //声明线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width / 2, 0)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    
    // Line Layer
    CAShapeLayer *_lineLayer = [CAShapeLayer layer];
    _lineLayer.frame = CGRectMake(0, height, width, height);
    _lineLayer.strokeColor = [UIColor greenColor].CGColor;
    _lineLayer.lineWidth = 1.0;
    _lineLayer.lineJoin = kCALineJoinMiter;
    _lineLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil];
    _lineLayer.lineDashPhase = 3.0f;
    _lineLayer.path = path.CGPath;
    _lineLayer.strokeEnd = 0.0f;
    
    [containerLayer addSublayer:_lineLayer];
    
    
    //给每个layer添加动画
    
    CAKeyframeAnimation  *_topAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    _topAnimation.duration = 3.5;
    _topAnimation.repeatCount = HUGE_VAL;
    _topAnimation.keyTimes = @[@0.0f, @0.9f, @1.0f];
    _topAnimation.values = @[@1.0f, @0.0f, @0.0f];
    [_topLayer addAnimation:_topAnimation forKey:@"TopAnimatin"];
    
    
    CAKeyframeAnimation *_bottomAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    _bottomAnimation.duration = 3.5;
    _bottomAnimation.repeatCount = HUGE_VAL;
    _bottomAnimation.keyTimes = @[@0.1f, @0.9f, @1.0f];
    _bottomAnimation.values = @[@0.0f, @1.0f, @1.0f];
    [_bottomLayer addAnimation:_bottomAnimation forKey:@"BottomAnimation"];
    
   CAKeyframeAnimation *_lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    _lineAnimation.duration = 3.5;
    _lineAnimation.repeatCount = HUGE_VAL;
    _lineAnimation.keyTimes = @[@0.0f, @0.1f, @0.9f, @1.0f];
    _lineAnimation.values = @[@0.0f, @1.0f, @1.0f, @1.0f];
    [_lineLayer addAnimation:_lineAnimation forKey:@"LineAnimation"];
    
    
   CAKeyframeAnimation *_containerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    _containerAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2f :1 :0.8f :0.0f];
    _containerAnimation.duration = 3.5;
    _containerAnimation.repeatCount = HUGE_VAL;
    _containerAnimation.keyTimes = @[@0.8f, @1.0f];
    _containerAnimation.values = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:M_PI]];

     [containerLayer addAnimation:_containerAnimation forKey:@"ContainerAnimation"];
}

- (void)animation5 {
    
    CALayer *superLayer = [CALayer layer];
    superLayer.frame = CGRectMake(0, 0, 100, 100);
    superLayer.position = CGPointMake(100, 450);
    superLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    superLayer.cornerRadius = 10;
    [self.view.layer addSublayer:superLayer];
    
    //圆球
    CALayer *ball1 = [CALayer layer];
    ball1.frame = CGRectMake(15, (100 - 10)/2, 10, 10);
    ball1.backgroundColor = [UIColor redColor].CGColor;
    ball1.cornerRadius = 5;
    [superLayer addSublayer:ball1];
    
    CALayer *ball2 = [CALayer layer];
    ball2.frame = CGRectMake(45, (100 - 10)/2, 10, 10);
    ball2.backgroundColor = [UIColor greenColor].CGColor;
    ball2.cornerRadius = 5;
    [superLayer addSublayer:ball2];
    
    CALayer *ball3 = [CALayer layer];
    ball3.frame = CGRectMake(75, (100 - 10)/2, 10, 10);
    ball3.backgroundColor = [UIColor orangeColor].CGColor;
    ball3.cornerRadius = 5;
    ball3.masksToBounds = YES;
    [superLayer addSublayer:ball3];

    //添加动画
    //  取得围绕中心轴的点
    CGPoint centerPoint = CGPointMake(50 , 50);
    
    //  获得第一个圆的中点
    CGPoint centerBall1 = ball1.position;
    
    //  获得第三个圆的中点
    CGPoint centerBall2 = ball3.position;

    //第一个圆动画
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:centerBall1];
    [path1 addArcWithCenter:centerPoint radius:10 startAngle:M_PI endAngle:2*M_PI clockwise:NO];//10为球的宽度
    
    UIBezierPath *path11 = [UIBezierPath bezierPath];
    [path11 addArcWithCenter:centerPoint radius:10 startAngle:0 endAngle:M_PI clockwise:NO];
    [path1 appendPath:path11];
    
    CAKeyframeAnimation *animation1=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.path = path1.CGPath;
 
    animation1.calculationMode = kCAAnimationCubic;
    animation1.repeatCount = MAXFLOAT;
    animation1.duration = 1;
    animation1.autoreverses = YES;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [ball1 addAnimation:animation1 forKey:@"animation"];
    
    
    //第二个
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:centerBall2];
    [path2 addArcWithCenter:centerPoint radius:10 startAngle:0 endAngle:M_PI clockwise:NO];
    UIBezierPath *path21 = [UIBezierPath bezierPath];
    [path21 addArcWithCenter:centerPoint radius:10 startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    [path2 appendPath:path21];
    
    // 2.2 第2个圆的动画
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.path = path2.CGPath;
   
    animation2.calculationMode = kCAAnimationCubic;
    animation2.repeatCount = MAXFLOAT;
    animation2.duration = 1;
    animation2.autoreverses = YES;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [ball3 addAnimation:animation2 forKey:@"rotation"];


}

- (void)animation6 {
    
    //sin(2* M_PI / 6 * i) * 45
    //cos(2 * M_PI / 6 * i) * 45
    
       

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
