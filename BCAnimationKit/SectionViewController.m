//
//  SectionViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SectionViewController.h"
#import "BCSectionViewController.h"
@interface SectionViewController ()
{

    UILabel *userHeadImageView;
    CAShapeLayer *arcLayer;
}
@end

@implementation SectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //画圈动画
    userHeadImageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    userHeadImageView.center = self.view.center;
    userHeadImageView.layer.cornerRadius = 50;
    userHeadImageView.text = @"点击屏幕";
    userHeadImageView.clipsToBounds = YES;
    userHeadImageView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userHeadImageView];
    
    
    CGRect rect = userHeadImageView.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
   
    
    //这个弧线的原点是正右，
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:50 startAngle:-M_PI_2 endAngle:(M_PI_2 + M_PI) clockwise:YES];
    arcLayer = [CAShapeLayer layer];
    
    arcLayer.path = path.CGPath;
    
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = DefaultColor.CGColor;
    arcLayer.lineWidth = 5;
    
    
    [userHeadImageView.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];

}
- (void)drawLineAnimation:(CALayer*)layer {
    
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 2;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    bas.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:bas forKey:@"key"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 NSArray *titleArray = @[@"news",@"sport",@"music",@"movie"];
    
    NSMutableArray *controllersArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        UIViewController *vc1 = [[UIViewController alloc] init];
        vc1.view.backgroundColor = RandomColor;
        [controllersArray addObject:vc1];
    }

    NSArray *newArray = [NSArray arrayWithArray:controllersArray];
    
    BCSectionViewController *BCSection = [[BCSectionViewController alloc] initWithTitle:titleArray controller:newArray isNavController:YES];
    [self.navigationController pushViewController:BCSection animated:NO];
    

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
