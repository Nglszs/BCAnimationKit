//
//  CalayerViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/23.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CalayerViewController.h"

@interface CalayerViewController ()

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;


@property (nonatomic , strong) UIImageView *imageView;
@end

@implementation CalayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这里只介绍几个常用的layer，其余的自行了解
    
    _imageView = [[UIImageView alloc] init];
     [self.view addSubview:_imageView];
    
    
    UISegmentedControl *testSegment = [[UISegmentedControl alloc] initWithItems:@[@"CAGradientLayer",@"CAReplicatorLayer",@" CAEmitterLayer"]];
    testSegment.frame = CGRectMake(16, 100, BCWidth - 32, 44);
    testSegment.selectedSegmentIndex = 0;
    if (testSegment.selectedSegmentIndex == 0) {
        [self loadCAGradientLayer];
    }
    [testSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    testSegment.tintColor = DefaultColor;
    testSegment.layer.cornerRadius = 9/2;
    testSegment.clipsToBounds = YES;
    [testSegment addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:testSegment];


}
- (void)changeValue:(UISegmentedControl *)segment {
    
    
   
    NSInteger Index = segment.selectedSegmentIndex;
    
    switch (Index) {
        case 0:
            [self loadCAGradientLayer];
            break;
        case 1:
            [self loadCAReplicatorLayer];
            break;
        case 2:
            [self loadCAEmitterLayer];
            break;
        default:
            break;
    }
    
}

- (void)loadCAGradientLayer {

    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    testLabel.center = self.view.center;
    testLabel.font = [UIFont boldSystemFontOfSize:14];
    testLabel.text = @"这是渐变色测试";
    [self.view addSubview:testLabel];
    
    //这个是背景色渐变
    //    CAGradientLayer *layer = [CAGradientLayer layer];
    //    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,
    //                     (__bridge id)[UIColor orangeColor].CGColor,
    //                     (__bridge id)DefaultColor.CGColor];
    //    layer.locations = @[@(.25),@(.5),@(.75)];
    //    layer.startPoint = CGPointMake(0, 0);
    //    layer.endPoint = CGPointMake(1, 1);
    //    layer.frame = testLabel.bounds;
    //    [testLabel.layer addSublayer:layer];
    
    
    // 这个是字体渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = testLabel.frame;
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor,
                             (__bridge id)DefaultColor.CGColor];
    
    gradientLayer.locations = @[@(.25),@(.5),@(.75)];
    
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = testLabel.layer;
    testLabel.frame = gradientLayer.bounds;


}


- (void)loadCAReplicatorLayer {

    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.bounds = self.view.bounds;
    _replicatorLayer.position = self.view.center;
    _replicatorLayer.preservesDepth = YES;
    [_replicatorLayer addSublayer:_imageView.layer];
    [self.view.layer addSublayer:_replicatorLayer];

    [self animation2];
}


- (void)loadCAEmitterLayer {//烟花动画，参考别人的demo



    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode = kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape = kCAEmitterLayerLine;
    fireworksEmitter.renderMode	= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
 
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 1.0;
    rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
    rocket.velocity			= 380;
    rocket.velocityRange	= 100;
    rocket.yAcceleration	= 75;
    rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
    rocket.scale			= 0.2;
    rocket.color			= [[UIColor redColor] CGColor];
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    rocket.spinRange		= M_PI;		// slow spin
    
    
    
    
    CAEmitterCell *burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;		// shifting
    burst.blueSpeed			=+1.5;		// shifting
    burst.greenSpeed		=+1.0;		// shifting
    burst.lifetime			= 0.35;
    
    // and finally, the sparks
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.25;
    spark.spin				= 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
    
    fireworksEmitter.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells	= [NSArray arrayWithObject:burst];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:fireworksEmitter];


}
#pragma mark CAReplicatorLayer 三个动画
- (void)animation1{//复制
    
    _imageView.frame = CGRectMake(10, 200, 100, 100);
    _imageView.image =[UIImage imageNamed:@"head.jpg"];
    self.replicatorLayer.instanceDelay = 1;
    self.replicatorLayer.instanceCount = 4;
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(120, 0, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"instanceTransform"];
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(100, 0, 0)];
    [self.replicatorLayer addAnimation:animation forKey:nil];
}

- (void)animation2{//旋转
    
    _imageView.frame = CGRectMake(172, 200, 20, 20);
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    
    CGFloat count = 15.0;
    self.replicatorLayer.instanceDelay = 1.0 / count;
    self.replicatorLayer.instanceCount = count;

    //这里只是缩小，但是视觉上的效果是旋转
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / count, 0, 0, 1.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
   
    
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [_imageView.layer addAnimation:animation forKey:nil];
}

- (void)animation3{//移动
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = CGRectMake(20, 650, 15, 15);
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.layer.cornerRadius = 7.5;
    _imageView.layer.masksToBounds = YES;
    
    CGFloat count = 30.0;
    CGFloat duration = 3;
    self.replicatorLayer.instanceDelay = duration / count;
    self.replicatorLayer.instanceCount = count;
    self.replicatorLayer.instanceAlphaOffset = 0.1;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 650)];
    [path addLineToPoint:CGPointMake(20, 100)];
    [path addCurveToPoint:CGPointMake(200, 400) controlPoint1:CGPointMake(200, 20) controlPoint2:CGPointMake(20, 400)];
    [path addLineToPoint:CGPointMake(355, 100)];
    [path addLineToPoint:CGPointMake(250, 400)];
    [path addLineToPoint:CGPointMake(400, 500)];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = CGPathCreateCopyByTransformingPath(path.CGPath, NULL);
    keyFrameAnimation.duration = duration;
    keyFrameAnimation.repeatCount = 20;
    [_imageView.layer addAnimation:keyFrameAnimation forKey:nil];
    
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
