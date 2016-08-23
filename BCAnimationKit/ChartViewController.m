//
//  ChartViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ChartViewController.h"
#import "BCChartView.h"
@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    BCChartView *chartView = [[BCChartView alloc] initWithFrame:CGRectMake(0, 100, BCWidth, 200)];
  
    [self.view addSubview:chartView];

    [self loadShapeView];
    
    
}


- (void)loadShapeView {

    //用贝塞尔曲线来画扇形，实际上画的是圆，因为半径为边线中间到原点的距离，所以设置半径为线宽的一半，这样线宽就覆盖了中间填充部分的颜色，形成扇形。
    UIBezierPath *bezierPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake((self.view.frame.size.width)/2, 400) radius:60 startAngle:0 endAngle:M_PI/3*4 clockwise:YES];
    
    CAShapeLayer *shanxingLayer = [CAShapeLayer layer];
    //这里设置填充线的宽度
    shanxingLayer.lineWidth = 120;
    //设置拐角样式
    shanxingLayer.lineCap = kCALineCapButt;
    //绘制的线的颜色
    shanxingLayer.strokeColor = [[UIColor redColor] CGColor];
    //填充色设置为nil是为了防止填充色混淆，因为这个本身实际上是画圆，第一步有解释
    shanxingLayer.fillColor = nil;
    //路径
    shanxingLayer.path = bezierPath.CGPath;    [self.view.layer addSublayer:shanxingLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //设置绘制动画持续的时间
    animation.duration = 1;
    //速度控制函数
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //起始值
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    //结束值
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    //是否翻转绘制
 
    //当前对象在非active时间段的行为
    animation.fillMode = kCAFillModeForwards;

    //animation.beginTime = CACurrentMediaTime() + 2;
    [shanxingLayer addAnimation:animation forKey:@"strokeEnd"];
    //表示绘制到百分比多少就停止，这个我们用1表示完全绘制
    shanxingLayer.strokeEnd=1.0f;

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
