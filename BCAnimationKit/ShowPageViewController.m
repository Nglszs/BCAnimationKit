//
//  ShowPageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/31.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ShowPageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ShowPageViewController ()

{
    UIScrollView *testScrollview;
    UIPageControl *pageControl;
    NSTimer *testTime;
    UIImageView *_imageView;

}

@property(nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property(nonatomic, strong) AVAudioSession *avaudioSession;
@end

@implementation ShowPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实现一引导页，其实就是轮播图加播放视频
    
    
    //不影响其他播放器
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
  
    
    //播放视频
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
   
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [_moviePlayer play];
    [_moviePlayer.view setFrame:self.view.bounds];
    
    [self.view addSubview:_moviePlayer.view];
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayer setFullscreen:YES];
    
    [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];

    //监听播放状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
    
    
    
    //轮播切换文字
    
    UIView *alphaView = [[UIView alloc] initWithFrame:BCScreen];
    alphaView.backgroundColor = [UIColor clearColor];
    [_moviePlayer.view addSubview:alphaView];
    
    //添加轮播及登录注册按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.frame = CGRectMake((BCWidth/2 - RealValue(150))/2, BCHeight - 70, RealValue(150), 44);
    startButton.layer.cornerRadius = 5;
    startButton.alpha = .4;
    startButton.backgroundColor = [UIColor blackColor];
    [startButton setTitle:@"注册" forState:UIControlStateNormal];
    [alphaView addSubview:startButton];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    finishButton.frame = CGRectMake((BCWidth/2 - RealValue(150))/2 + BCWidth/2, BCHeight - 70, RealValue(150), 44);
    finishButton.layer.cornerRadius = 5;
    finishButton.alpha = .4;
    finishButton.backgroundColor = [UIColor whiteColor];
    [finishButton setTitle:@"登录" forState:UIControlStateNormal];
    [alphaView addSubview:finishButton];
    
    
    //产品的图标
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keep6@2x"]];
    _imageView.center = self.view.center;
    [alphaView addSubview:_imageView];

    //轮播
    testScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight - 70)];
    testScrollview.pagingEnabled = YES;
    testScrollview.showsHorizontalScrollIndicator = NO;
    testScrollview.showsVerticalScrollIndicator = NO;
    testScrollview.delegate = self;
    testScrollview.contentSize = CGSizeMake(BCWidth * 4, BCHeight/2);
    [alphaView addSubview:testScrollview];
    
    
    NSArray *arr = @[@"每个动作都精确规范",@"规划陪伴你的训练过程",@"分享汗水后你的性感",@"全程记录你的健身数据"];
    for (int i = 0; i < 4; i ++) {
        
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(BCWidth * i, CGRectGetHeight(testScrollview.frame) - 100, BCWidth, 44)];
        showLabel.text = [arr objectAtIndex:i];
        showLabel.textColor = [UIColor whiteColor];
        showLabel.textAlignment = NSTextAlignmentCenter;
        [testScrollview addSubview:showLabel];
        
    }
    
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((BCWidth - 44)/2, CGRectGetHeight(testScrollview.frame) - 50, 44, 44)];
    
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [alphaView addSubview:pageControl];

    //定时器
    [self setupTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        
        [testTime invalidate];
        testTime = nil;
        
    }
    
}
#pragma mark 轮播图相关
-(void)setupTimer{
    
    testTime = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:testTime forMode:NSRunLoopCommonModes];
    
}

-(void)pageChanged:(UIPageControl *)pageC{
    
    CGFloat x = (pageC.currentPage) * [UIScreen mainScreen].bounds.size.width;
    
    [testScrollview setContentOffset:CGPointMake(x, 0) animated:YES];
    
    
}

-(void)timerChanged{
    NSInteger page  = (pageControl.currentPage +1) %4;
    
    pageControl.currentPage = page;
    
    [self pageChanged:pageControl];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = testScrollview.contentOffset.x / testScrollview.bounds.size.width;
    pageControl.currentPage = page;
    
    if (page == - 1)
    {
        pageControl.currentPage = 3;// 序号0 最后1页
    }
    else if (page == 4)
    {
        pageControl.currentPage = 0; // 最后+1,循环第1页
        [testScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [testTime invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self setupTimer];
    
}



-(void)playbackStateChanged{
    
    
    //取得目前状态
    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
    
    //状态类型
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放中");
            break;
            
        case MPMoviePlaybackStatePaused:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"播放被中断");
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"往前快转");
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"往后快转");
            break;
            
        default:
            NSLog(@"无法辨识的状态");
            break;
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
