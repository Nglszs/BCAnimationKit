//
//  NumberView.m
//  HEHEH
//
//  Created by Jack on 16/7/26.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "NumberView.h"

@implementation NumberView

- (instancetype)initViewFrame:(CGRect)frame andValue:(NSNumber *)value {

    
    self.tempValue = value;
    self.minLength = 3;
    numbersText = [NSMutableArray new];
    scrollLayers = [NSMutableArray new];
    scrollLabels = [NSMutableArray new];
    return [self initWithFrame:frame];

}
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
       self.backgroundColor = [UIColor blackColor]; 
        [self initView];
    }
    return self;

}

- (void)initView {

    NSString *textValue = [self.tempValue stringValue];
    
    //创建text
    
    //设置最小值
    for(NSInteger i = 0; i < (NSInteger)self.minLength - (NSInteger)[textValue length]; ++i){
        [numbersText addObject:@"0"];
     
    }
    
    for(NSUInteger i = 0; i < [textValue length]; i++){
       
        [numbersText addObject:[textValue substringWithRange:NSMakeRange(i, 1)]];
    }
    
   //创建滚动的layer
    CGFloat width = roundf(CGRectGetWidth(self.frame) / numbersText.count);
    CGFloat height = CGRectGetHeight(self.frame);
    
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(roundf(i * width), 0, width, height);
        [scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
    }

    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = scrollLayers[i];
        NSString *numberText = numbersText[i];
       
        [self createContentForLayer:layer withNumberText:numberText];
    }

    
    
}


- (void)createContentForLayer:(CAScrollLayer *)scrollLayer withNumberText:(NSString *)numberText
{

    NSInteger number = [numberText integerValue];
    NSMutableArray *textForScroll = [NSMutableArray new];
    
    for(NSUInteger i = 0; i < 10; ++i){
        [textForScroll addObject:[NSString stringWithFormat:@"%ld", (number + i) % 10]];
    }
    
    [textForScroll addObject:numberText];
 
 
    CGFloat height = 0;
    for(NSString *text in textForScroll){
        UILabel * textLabel = [self createLabel:text];
        textLabel.frame = CGRectMake(0, height, CGRectGetWidth(scrollLayer.frame), CGRectGetHeight(scrollLayer.frame));
        [scrollLayer addSublayer:textLabel.layer];
        [scrollLabels addObject:textLabel];
        height = CGRectGetMaxY(textLabel.frame);
    }

}
- (UILabel *)createLabel:(NSString *)text
{
    UILabel *view = [UILabel new];
    view.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    view.textAlignment = NSTextAlignmentCenter;
    view.textColor = [UIColor whiteColor];
    view.text = text;
    
    return view;
}
- (void)createAnimations
{
    CFTimeInterval duration = 1.5 - ([numbersText count] * .2);
    CFTimeInterval offset = 0;
    
    //这里设置每个scrolllayer的偏移量不同
    for(CALayer *scrollLayer in scrollLayers){
        CGFloat maxY = [[scrollLayer.sublayers lastObject] frame].origin.y;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration + offset;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        animation.fromValue = @0;
        animation.toValue = [NSNumber numberWithFloat:-maxY];
     
        
        [scrollLayer addAnimation:animation forKey:@"JTNumberScrollAnimatedView"];
        
        offset += .2;
    }
}

- (void)startAnimation {

    [self createAnimations];


}
@end
