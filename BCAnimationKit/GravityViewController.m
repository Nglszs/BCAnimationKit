//
//  GravityViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/23.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *testView;
@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //就提供下面几种行为,其他的自己了解
    UISegmentedControl *testSegment = [[UISegmentedControl alloc] initWithItems:@[@"下落",@"碰撞",@"捕捉",@"附着"]];
    testSegment.frame = CGRectMake(16, 100, BCWidth - 32, 44);
    testSegment.selectedSegmentIndex = 0;
    if (testSegment.selectedSegmentIndex == 0) {
        UIGravityBehavior *testGravity = [[UIGravityBehavior alloc] initWithItems:@[self.testView]];
        
        //[self.animator addBehavior:testGravity];
    }
    testSegment.tintColor = DefaultColor;
    testSegment.layer.cornerRadius = 9/2;
    testSegment.clipsToBounds = YES;
    [testSegment addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:testSegment];
    
    
        
}
/**
 
 所有的行为都是可以组合的
 
 */
- (void)changeValue:(UISegmentedControl *)segment {
    
    
     [self.animator removeAllBehaviors];//移除之前所有的行为
    NSInteger Index = segment.selectedSegmentIndex;
    
    
    
    
    switch (Index) {
        case 0://重力
        {
            //重力行为，当然也可以重力和其他行为叠加
            UIGravityBehavior *testGravity = [[UIGravityBehavior alloc] initWithItems:@[self.testView]];
            //重力加速度
            testGravity.magnitude = 1;
            
            //重力方向
            //testGravity.angle = M_PI_4;
            [self.animator addBehavior:testGravity];
        
        }
            break;
            
        case 1://碰撞
        {
            UIGravityBehavior *testGravity = [[UIGravityBehavior alloc] initWithItems:@[self.testView]];
            
            UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.testView]];
            
           //以线为边界
//            CGPoint startP = CGPointMake(0, 160);
//            CGPoint endP = CGPointMake(320, 400);
//            [collision addBoundaryWithIdentifier:@"line1" fromPoint:startP toPoint:endP];
//            CGPoint startP1 = CGPointMake(320, 0);
//            [collision addBoundaryWithIdentifier:@"line2" fromPoint:startP1 toPoint:endP];
            
            
            
            //以圆为边界
//            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 320)];
//            [collision addBoundaryWithIdentifier:@"circle" forPath:path];
            
           
            
            //以当前视图边框为边界
            collision.translatesReferenceBoundsIntoBoundary = YES;
           
            //开始仿真
            [self.animator addBehavior:testGravity];
            [self.animator addBehavior:collision];
        
        }
            break;
            
            case 2://捕捉,让物体迅速冲到某一位置，并震荡
        {
            
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.testView snapToPoint:CGPointMake(200, 500)];
            snap.damping = .5;//震荡系数
            
            [self.animator addBehavior:snap];
        }
            break;
            
            case 3://附着
        {
            UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.testView attachedToAnchor:CGPointMake(300, 900)];
            [attachmentBehavior setLength:300];
            [attachmentBehavior setDamping:0.5];
            attachmentBehavior.frequency = .8;
            [self.animator addBehavior:attachmentBehavior];
            
        }
            break;
        default:
            break;
    }





}


- (UIDynamicAnimator *)animator {

    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }

    
    return _animator;
}

- (UIView *)testView {

    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
        _testView.backgroundColor = [UIColor orangeColor];
        _testView.transform = CGAffineTransformRotate(_testView.transform, 45);//增加一个角度让行为更有意思
        [self.view addSubview:_testView];
    }


    return _testView;
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
