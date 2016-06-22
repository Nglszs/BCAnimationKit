//
//  CubeViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/12.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CubeViewController.h"

@interface CubeViewController ()
{
    UIImageView *_imageView;
     NSInteger _currentIndex;
}
@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((BCWidth - 200)/2, 200, 200, 200)];
  
    _imageView.image = [UIImage imageNamed:@"bc.jpg"];//默认图片
    [self.view addSubview:_imageView];
    
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
}
#pragma mark 向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:YES];
}

#pragma mark 向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:NO];
}


#pragma mark 转场动画
-(void)transitionAnimation:(BOOL)isNext{
    
    
    //动画也可以用uiview的转场动画来实现
    //这个动画很强大，可以自己试试其他效果
    CATransition *transition=[[CATransition alloc]init];
    
   
    transition.type = @"cube";
    
    //设置子类型
    if (isNext) {
        transition.subtype = kCATransitionFromRight;
    }else{
        transition.subtype = kCATransitionFromLeft;
    }
    //设置动画时常
    transition.duration = 1.0f;
    
    //3.设置转场后的新视图添加转场动画
    _imageView.image = [self getImage:isNext];

    [_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
    
//    [UIView transitionWithView:_imageView duration:1 options:UIViewAnimationOption animations:^{
//        
//        
//    } completion:^(BOOL finished) {
//        
//    }];
}

-(UIImage *)getImage:(BOOL)isNext{
    NSArray *imageArr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
    if (isNext) {
        
        _currentIndex = (_currentIndex + 1) % imageArr.count;
        
    }else{
                
        _currentIndex = (imageArr.count + _currentIndex - 1) % imageArr.count;
        
    }
    NSString *imageName = imageArr[_currentIndex];
    return [UIImage imageNamed:imageName];
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
