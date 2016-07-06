//
//  BCChartView.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCChartView.h"

#define ChartMargin 20 //底部的间隔
#define KMargin 10 //图标之间的间隔
#define CWidth 50 //柱状图宽度
#define CenterX (BCWidth - CWidth * 5 - KMargin * 4)/2 //为了让图表居中，也就是与x的距离

@implementation BCChartView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GreenColor;
        //这里由于x轴方向的间距是一样的，所以这里只设置y轴方向的数据
        
        
        [self initView];
  
    }

    return self;

}

- (void)initView {

    //下面是取出数组中的最大值
    CGFloat maxY = CGFLOAT_MIN;
    for (int i = 0; i < self.valueY.count; i ++) {
        if ([self.valueY[i] floatValue] > maxY) {
            maxY = [self.valueY[i] floatValue];
        }
    }

    CGFloat maxH = CGRectGetHeight(self.frame) - ChartMargin * 2;//整个图表高度
    
    CGFloat chartWidth = (CGRectGetWidth(self.frame) - ChartMargin * 2) / self.valueY.count;//图标宽度

    chartWidth = MIN(CWidth, chartWidth);//这里设置图表宽度为50，且最大是上面计算出来的
    
    
    //折线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(CenterX + chartWidth/2, ChartMargin + (1 - [self.valueY.firstObject floatValue] / maxY) * maxH)];
    
    
    
    //下面是所有图的集合花在一起
    for (int i = 0; i < self.valueY.count; i ++) {
        
       

       //柱状图
        CGPoint point = CGPointMake(CenterX + (chartWidth + KMargin) * (i + 1), ChartMargin + (1 - [self.valueY[i] floatValue] / maxY) * maxH);//这里就设置了和左边及底部的距离，都是用chartmargin来实现的
        
       
        
        CGRect rect = CGRectMake(point.x - chartWidth - KMargin , point.y, chartWidth, (CGRectGetHeight(self.frame) -  ChartMargin - point.y));
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = DefaultColor.CGColor;
        [self.layer addSublayer:layer];
        
        
        //添加数值
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rect) , CGRectGetMinY(rect) - 15, chartWidth, 10)];
        //这里也可以设置label的frame为rect，那么整个数值会显示在中间
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text =  [NSString stringWithFormat:@"%@",self.valueY[i]];
        [self addSubview:valueLabel];
        
        
        //添加点
        CAShapeLayer *spotLayer = [[CAShapeLayer alloc] init];
        spotLayer.frame = CGRectMake(point.x - chartWidth/2 - KMargin - 2.5, point.y - 2.5, 5, 5);
        spotLayer.backgroundColor = [UIColor redColor].CGColor;
        spotLayer.cornerRadius = 2.5;
        spotLayer.masksToBounds = YES;
        [self.layer addSublayer:spotLayer];

        
        //添加折线
       [linePath addLineToPoint:CGPointMake(point.x - chartWidth/2 - KMargin, point.y)];
       

    }
    
    //折线
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = linePath.CGPath;
    lineLayer.strokeColor = [UIColor redColor].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:lineLayer];

    
    
    

}

- (NSArray *)valueY {

    if (!_valueY) {
        
        _valueY = @[@2,@7,@10,@4,@1];
    }
    return _valueY;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
