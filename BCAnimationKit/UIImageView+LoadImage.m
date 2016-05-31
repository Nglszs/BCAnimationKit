//
//  UIImageView+LoadImage.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/31.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UIImageView+LoadImage.h"
#import <objc/runtime.h>
@implementation UIImageView (LoadImage)

static void *outKey = &outKey;
static void *inKey = &inKey;


- (CAShapeLayer *)outLayer {
    
    
    
    return objc_getAssociatedObject(self, &outKey);
    
}


- (void)setOutLayer:(CAShapeLayer *)outLayer {
    
    
    objc_setAssociatedObject(self, &outKey, outLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    
}


- (CAShapeLayer *)inLayer {

 return objc_getAssociatedObject(self, &inKey);

}

- (void)setInLayer:(CAShapeLayer *)inLayer {

    objc_setAssociatedObject(self, &inKey, inLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
}


- (void)loadImageViewAnimation:(CGFloat)angle {

    if (!self.outLayer) {
        
        self.outLayer = [CAShapeLayer layer];
        CGFloat  outRadius = MIN(self.bounds.size.width, self.bounds.size.height)/4;//中间空心圆的半径
        
        UIBezierPath *outPath = [UIBezierPath bezierPathWithRect:self.bounds];
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        UIBezierPath *holePath = [UIBezierPath bezierPathWithArcCenter:center radius:outRadius startAngle:M_PI_2 endAngle:-M_PI * 3 / 2 clockwise:NO];
        [outPath appendPath:holePath];
        
        self.outLayer.frame = self.bounds;
        self.outLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        self.outLayer.fillRule = kCAFillRuleEvenOdd;
        self.outLayer.path = outPath.CGPath;
        [self.layer addSublayer:self.outLayer];
        
    }
    
    if (!self.inLayer) {
        
        self.inLayer = [CAShapeLayer layer];
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGFloat holeRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 4.;
        holeRadius -= 1;//设置边缘线的宽度
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:holeRadius / 2. startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        [path closePath];
        
        self.inLayer.path = path.CGPath;
        self.inLayer.fillColor = [UIColor clearColor].CGColor;
        self.inLayer.lineWidth = holeRadius;
        self.inLayer.contentsGravity = @"center";
        self.inLayer.strokeEnd = 1.0;
        self.inLayer.strokeStart = 0.f;
        self.inLayer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        
        [self.layer addSublayer:self.inLayer];

        
    }


    self.inLayer.strokeStart = angle;
    
   
    if (angle >= 1.0) {//执行加载完成的动画
        
        
        [self.inLayer removeFromSuperlayer];
        
        CGFloat holeRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 4.;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat diaginal = sqrt(width * width + height * height);
        
        
        
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @(1);
        scale.toValue = @(diaginal / holeRadius);
        
        scale.duration = 2;
        //解决动画闪一下的动画
        scale.fillMode = kCAFillModeForwards;
        scale.removedOnCompletion = NO;
        scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.outLayer addAnimation:scale forKey:@"hehe"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.outLayer removeFromSuperlayer];
        });

        
    }
    

}
@end
