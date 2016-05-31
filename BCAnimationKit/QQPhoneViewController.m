//
//  QQPhoneViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/11.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "QQPhoneViewController.h"

@interface QQPhoneViewController ()<CAAction>
{

    UIView  *showView;//显示的界面
    UIImageView *headImage;//头像
    UIButton *clickButton;//收起放大按钮（控制动画）
    BOOL isScale;//当前是不是最小话状态
   
   
}
@property (nonatomic, strong) CABasicAnimation *scaleAnimation;//缩小动画
@property (nonatomic, strong) CAKeyframeAnimation *moveAnimation;


@end

@implementation QQPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  

   //控件初始化
    showView = [[UIView alloc] initWithFrame:BCScreen];
   showView.backgroundColor = [UIColor colorWithRed:100/255.0 green:200/255.0 blue:100/255.0 alpha:1];
    
    [self.view addSubview:showView];
    
    
    
    
    
    clickButton = [[UIButton alloc] initWithFrame:CGRectMake(BCWidth / 2 - 50, BCHeight - 200, 100, 50)];
    [clickButton setTitle:@"收起" forState:UIControlStateNormal];
    [clickButton setTitleColor:DefaultColor forState:UIControlStateNormal];
    
    [clickButton addTarget:self action:@selector(startCustomAnimation) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:clickButton];
    
    
 
    
    //这个也可以加载showview上
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(BCWidth/2 - 50, 200, 100, 100)];
    headImage.layer.cornerRadius = 50;
    headImage.layer.masksToBounds = YES;
    headImage.image = [UIImage imageNamed:@"head.jpg"];
    [self.view addSubview:headImage];
    
    
}

//动画分为两部分，前半部分为转场动画，后半部分边移动变缩小动画
- (void)startCustomAnimation {
   
    isScale = NO;
    
    
    
   
        [self startAboveAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startBelowAnimation];

});
        
    
    
    
    
    
}


//点击头像时的返回动画
- (void)startOtherAnimation {

    headImage.userInteractionEnabled = NO;
    isScale = YES;
    

    [self startBelowAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAboveAnimation];
        
    });

    
    
}
//这个是界面缩小到imageview的动画
- (void)startAboveAnimation {

    // ---------------前半部分动画-----------------
    
    
   
    //转场动画
    CGRect tempRect = CGRectInset(headImage.frame, -600, -600);
    CGPathRef startPath;
    CGPathRef endPath;
    
    
       startPath = CGPathCreateWithEllipseInRect(tempRect, NULL);
        endPath = CGPathCreateWithEllipseInRect(headImage.frame, NULL);
   
     CAShapeLayer *showLayer = [CAShapeLayer layer];
       showLayer.path = endPath;
    showView.layer.mask = showLayer;
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath);
    pingAnimation.toValue  = (__bridge id)(endPath);
    pingAnimation.delegate = self;
    pingAnimation.duration  = 1;
    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [pingAnimation setValue:@"animate1" forKey:@"animate1"];
    [showLayer addAnimation:pingAnimation forKey:@"StartPath"];
    
    CGPathRelease(startPath);
    CGPathRelease(endPath);


}

//放大
- (void)backAboveAnimation {
    showView.hidden = NO;

    CGRect tempRect = CGRectInset(headImage.frame, -600, -600);
    CGPathRef startPath = CGPathCreateWithEllipseInRect(tempRect, NULL);
    CGPathRef endPath   = CGPathCreateWithEllipseInRect(headImage.frame, NULL);
    
    CAShapeLayer *showLayer = [CAShapeLayer layer];
    showLayer.path = startPath;
    showView.layer.mask = showLayer;
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(endPath);
    pingAnimation.toValue  = (__bridge id)(startPath);
    pingAnimation.delegate = self;
    pingAnimation.duration  = 1;
    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [pingAnimation setValue:@"animate2" forKey:@"animate2"];
    [showLayer addAnimation:pingAnimation forKey:@"BackPath"];
    
    CGPathRelease(startPath);
    CGPathRelease(endPath);



}
- (void)startBelowAnimation {

    // ---------------后半部分动画--------------------
    //抛物线动画
    _moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, headImage.layer.position.x, headImage.layer.position.y);//起始点
    
    CGPoint endPoint;
    if (isScale) {
        
        CGPathAddCurveToPoint(path, NULL, BCWidth - 50, BCHeight - 100, BCWidth - 100, 300, BCWidth/2 , 250);
        endPoint = CGPointMake(BCWidth/2 , 250);
    } else {
    
        CGPathAddCurveToPoint(path, NULL, BCWidth - 200, 250, BCWidth - 100, 300, BCWidth - 50, BCHeight - 100);
        endPoint = CGPointMake(BCWidth - 50, BCHeight - 100);
    }
    
    _moveAnimation.path = path;
    CGPathRelease(path);
    _moveAnimation.duration = 1.0f;
    [_moveAnimation setValue:[NSValue valueWithCGPoint:endPoint] forKey:@"move"];
    
    //缩放动画
    _scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
   
    NSNumber *startValue;
    NSNumber *endValue;
    if (isScale) {
        startValue = [NSNumber numberWithFloat:0.5];

        endValue = [NSNumber numberWithFloat:1.0];
        
    } else {
    
        startValue = [NSNumber numberWithFloat:1.0];
        endValue = [NSNumber numberWithFloat:0.5];
    }
    
    _scaleAnimation.fromValue = startValue;
    _scaleAnimation.toValue = endValue;
    _scaleAnimation.duration = 1.0f;
    [_scaleAnimation setValue:endValue forKey:@"scale"];
    
    
    //组动画
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration = 1.0f;
    groupAnnimation.delegate = self;
    groupAnnimation.removedOnCompletion = NO;
    groupAnnimation.fillMode = kCAFillModeForwards;
    groupAnnimation.animations = @[_moveAnimation, _scaleAnimation];
    [headImage.layer addAnimation:groupAnnimation forKey:@"group"];



}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
   
    if ([[anim valueForKey:@"animate1"] isEqualToString:@"animate1"]) {
        
    
        showView.hidden = YES;
      
        
    } else if ([[anim valueForKey:@"animate2"] isEqualToString:@"animate2"]) {
    
    
    
    } else {
        
    CAAnimationGroup *animationGroup = (CAAnimationGroup *)anim;
    CAKeyframeAnimation *keyframeAnimation = (CAKeyframeAnimation *)animationGroup.animations[0];
      CABasicAnimation *basicAnimation = (CABasicAnimation *)animationGroup.animations[1];
    
   CGPoint lastPoint =[[keyframeAnimation valueForKey:@"move"] CGPointValue];
    CGFloat toValue=[[basicAnimation valueForKey:@"scale"] floatValue];
    
   
    headImage.layer.position = lastPoint;
    headImage.transform = CGAffineTransformMakeScale(toValue, toValue);
        
        
        if (headImage.layer.position.y == (BCHeight - 100)) {
            headImage.userInteractionEnabled = YES;
            
           
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startOtherAnimation)];
            [headImage addGestureRecognizer:tap];
        }
 
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        
        [showView.layer removeAllAnimations];
        [headImage.layer removeAllAnimations];
        
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
       
        
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
