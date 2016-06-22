//
//  CustomBrowseView.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/21.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CustomBrowseView.h"

@implementation CustomBrowseView


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        
        _backgroundImageV = [[UIImageView alloc] initWithFrame:self.bounds];
       
        
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        
        visualView.frame = _backgroundImageV.frame;

        _backgroundImageV.image = [UIImage imageNamed:@"bc.jpg"];
        
        [_backgroundImageV addSubview:visualView];
        [self addSubview:_backgroundImageV];
        
        
        
        [self initImageView];
        
        
        
        //注册通知
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];

        
    }



    return self;

}



- (void)initImageView {

  
    _previousImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,200, 300)];
    _previousImageV.center = self.center;
    _previousImageV.image = [UIImage imageNamed:@"bc.jpg"];
    _previousImageV.layer.shouldRasterize = YES;
    [self addSubview:_previousImageV];
    

}

- (void)panAction:(UIPanGestureRecognizer *)pan {
   
    
    
    
    if (pan.state == UIGestureRecognizerStateChanged) {
     CGPoint  point = [pan translationInView:pan.view];
        
        
        
            if (point.x < 0) {
                
                //绕某点转动
                CGAffineTransform  trans  = CGAffineTransformMakeTranslation(100, 500);
                trans = CGAffineTransformRotate(trans,MAX(-M_PI_4, point.x/(M_PI *30)));
                trans = CGAffineTransformTranslate(trans,-100, -500);
                
                
                _previousImageV.transform = trans;
                resultValue = point.x;
            
            
            }
       
        
        
            } else if (pan.state == UIGestureRecognizerStateEnded) {
                
                
              
                if (resultValue > -15) {
                    _previousImageV.transform = CGAffineTransformIdentity;
                    
                   
                } else {
                
                    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.x"];
                    positionAnima.duration = 0.25;
                    positionAnima.fromValue = @(_previousImageV.center.x);
                    positionAnima.toValue = @(-100);
                    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                    positionAnima.delegate = self;
                    [_previousImageV.layer addAnimation:positionAnima forKey:nil];

                
                }
                
                
                
                resultValue = 0;
              
             
    }
    
    
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    if (flag) {
        
        _previousImageV.transform = CGAffineTransformIdentity;
        _previousImageV.image = [self getImage:YES];
        _backgroundImageV.image = _previousImageV.image;
        
    }


}

-(UIImage *)getImage:(BOOL)isNext {
    
    NSArray *imageArr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
    
       if (isNext) {
        
        currentIndex = (currentIndex + 1 ) % imageArr.count;
        
    }else{
        
        currentIndex = (imageArr.count + currentIndex - 1) % imageArr.count;
        
    }
    
   
        NSString *imageName = imageArr[currentIndex];
   
    
       return [UIImage imageNamed:imageName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
