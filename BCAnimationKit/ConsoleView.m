//
//  ConsoleView.m
//  BCAnimationKit
//
//  Created by Jack on 16/12/8.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ConsoleView.h"

@implementation ConsoleView
{
    NSTimer *timer;
}
- (instancetype)initWithFrame:(CGRect)frame {

    if (self == [super initWithFrame:frame]) {
        [self becomeFirstResponder];
        UIView *backview = [[UIView alloc] initWithFrame:self.bounds];
        backview.backgroundColor = [UIColor cyanColor];
        backview.alpha = .25;
        [self addSubview:backview];
        [self initView];
    }
    return self;
}

- (void) initView {

    _logView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, BCWidth - 20, 200)];
    _logView.backgroundColor = [UIColor blackColor];
    _logView.textColor = [UIColor whiteColor];
    [self addSubview: _logView];
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePaths = [docDir stringByAppendingPathComponent:@"jack.log"];
    NSData *data = [NSData dataWithContentsOfFile:filePaths];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    self.logView.text = result;
    
    [self.logView scrollRectToVisible:CGRectMake(0, self.logView.contentSize.height-15, self.logView.contentSize.width, 10) animated:YES];

    [self timerAction];
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];

    
    
    
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame=CGRectMake(0, 5, 40, 20);
    closeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLoggerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    
//    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeSystem];
//    deleteBtn.frame=CGRectMake(BCWidth - 50, 5, 40, 20);
//    deleteBtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [deleteBtn setTitle:@"清空" forState:UIControlStateNormal];
//    [deleteBtn addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:deleteBtn];

}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}


- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)deleteBtn{
    
    
    self.logView.text = nil;
}
- (void)timerAction{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
}

-(void)readd{
    
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePaths = [docDir stringByAppendingPathComponent:@"jack.log"];
    NSData *data = [NSData dataWithContentsOfFile:filePaths];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    self.logView.text = result;
    [self.logView scrollRectToVisible:CGRectMake(0, self.logView.contentSize.height-15, self.logView.contentSize.width, 10) animated:YES];
}

-(void)closeLoggerView{
    [self removeFromSuperview];
   
    [timer invalidate];
    timer = nil;
}



@end
