//
//  UIButton+Common.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UIButton+Common.h"
#import <objc/runtime.h>
@implementation UIButton (Common)

#pragma mark 添加背景色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




#pragma mark 添加加载动画


//这个方法建议直接写在button的点击事件里，不要在用runtime
static void *maskKey = &maskKey;
static void *shapeKey = &shapeKey;
static void *frameKey = &frameKey;
- (UIView *)maskView {
    
    return objc_getAssociatedObject(self, &maskKey);
    
}


- (void)setMaskView:(UIView *)maskView {
    
    objc_setAssociatedObject(self, &maskKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (CAShapeLayer *)shapeLayer {
    
    return objc_getAssociatedObject(self, &shapeKey);
}

- (void)setShapeLayer:(CAShapeLayer *)shapeLayer {
    
    objc_setAssociatedObject(self, &shapeKey, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
//
//- (CGRect)reactRect {
//    
// 
//
//
//    return objc_getAssociatedObject(self, &frameKey);
//
//
//}

//- (void)setReactRect:(CGRect)reactRect {
//
//    objc_setAssociatedObject(self, &frameKey, @(reactRect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//
//}
- (void)addLoadingAnimation {//这个动画还是写在VC里比较好，这里只是单独写出来做个参考

    Method a = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod([self class], @selector(BC_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);

}

- (void)BC_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {

    [self loadAnimation];
    [self BC_sendAction:action to:target forEvent:event];
}

- (void)loadAnimation {

    self.selected = !self.selected;
    
    if (!self.selected) {
        
        [self.maskView.layer removeAllAnimations];
        
        
        
        
        [UIView animateWithDuration:.5 animations:^{
            
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            [self.maskView removeFromSuperview];
            
            self.maskView = nil;
            
            self.layer.bounds = CGRectMake(0, 0, 100, 50);
            
        }];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = [NSNumber numberWithFloat:25];
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.duration = 0.3;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:animation forKey:@"cornerRadius"];
        
        
        
        return;
    }
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:25];
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [UIView animateWithDuration:.5 animations:^{
        
        
        self.layer.bounds = CGRectMake(0, 0, 50, 50);//用layer的bound属性可以使view向中间收缩，如果用其他属性会使其向某一边收缩
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.layer.cornerRadius = 25;
        self.maskView.userInteractionEnabled = NO;
        self.maskView.clipsToBounds = YES;
        self.maskView.backgroundColor = self.backgroundColor;
        [self addSubview:self.maskView];
        
    } completion:^(BOOL finished) {
        
        
        
        UIBezierPath* path = [[UIBezierPath alloc] init];
        
        [path addArcWithCenter:CGPointMake(self.maskView.frame.size.width/2,self.maskView.frame.size.height/2) radius:20 startAngle:-M_PI_2 endAngle:(M_PI_2) clockwise:YES];
        
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 2;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        self.shapeLayer.path = path.CGPath;
        [self.maskView.layer addSublayer:self.shapeLayer];
        
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        
        [self.maskView.layer addAnimation:baseAnimation forKey:@"nil"];
        
        
        
    }];
    
    

}


#pragma mark 避免点击事件重复

static void *timeKey = &timeKey;
static void *timeKey1 = &timeKey1;
- (NSTimeInterval)acceptEventInterval{
    
    return [objc_getAssociatedObject(self, &timeKey) doubleValue];
    
}


- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    
    objc_setAssociatedObject(self, &timeKey, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSTimeInterval)acceptEventTime {

 return [objc_getAssociatedObject(self, &timeKey1) doubleValue];

}

- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime {

objc_setAssociatedObject(self, &timeKey1, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
- (void)avoidClick {
    
    
    
    Method a = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod([self class], @selector(avoid_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
    
    self.acceptEventInterval = 2;
  
}
- (void)avoid_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
  
   
    if (NSDate.date.timeIntervalSince1970 - self.acceptEventTime < self.acceptEventInterval) {
      
        NSLog(@"请不要频繁点击");
        return;
    }
    
    if (self.acceptEventInterval > 0)
    {
        self.acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self avoid_sendAction:action to:target forEvent:event];
    
}


@end
