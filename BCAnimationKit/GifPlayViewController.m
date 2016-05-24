//
//  GifPlayViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "GifPlayViewController.h"
#import <ImageIO/ImageIO.h>
@interface GifPlayViewController ()
{

    size_t count;
    size_t playIndex;

    CGImageSourceRef readGif;
    NSDictionary *gifProperty;
    
    UIImageView *showImage;
    
    NSMutableArray *timeArray;
    NSMutableArray *imageArray;
    CGFloat totalTime;//总时间
    CAKeyframeAnimation *animation;

}
@end

@implementation GifPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    showImage.center = self.view.center;
    showImage.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:showImage];
    
    
    //播放动画可以webview或者uiimageview的动画，那些没什么好演示的，这里通过将动画文件读取到CGImageSourceRef，然后帧动画播放
    
    
    
    //这个对比webview的性能，还是好一点的，我增加了对内存的释放，现在百度依然可以看到过时的论调。
    
    timeArray = [NSMutableArray arrayWithCapacity:1];
    imageArray = [NSMutableArray arrayWithCapacity:1];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"美女" ofType:@"gif"];
    
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        //读取gif成图片数据
       readGif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], NULL);
        //gif中图片的个数
        count = CGImageSourceGetCount(readGif);
      
       //这里的难点在于获取每一帧的时间，因为gif可能每一帧的时间都不一样
        for (size_t i = 0; i < count; i ++) {
            
            @autoreleasepool {
                CGImageRef image = CGImageSourceCreateImageAtIndex(readGif, i, NULL);
                
                //添加图片
                [imageArray addObject:(__bridge UIImage *)(image)];
                CGImageRelease(image);
                //获取动画每一帧播放的时间
                NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(readGif, i, NULL);
                NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
                CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
                
                totalTime += time;//获取播放一次的总时间
                [timeArray addObject:[NSNumber numberWithFloat:time]];//每帧的时间
            }
        
            
        }
        
        
        [self playGif];
        
    } else {
    
        NSLog(@"当前路径错误");
    
    }








}


- (void)playGif {

    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray * times = [[NSMutableArray alloc]init];
    float currentTime = 0;
    //设置每一帧的时间占比
    for (int i = 0; i<imageArray.count; i++) {
       
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime += [timeArray[i] floatValue];
        
        
    }

    [animation setKeyTimes:times];
    [animation setValues:imageArray];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    animation.repeatCount= 2;
    //设置播放总时长
    animation.duration = totalTime;
    
  
    [showImage.layer addAnimation:animation forKey:@"jack"];
    
    
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        
        [showImage.layer removeAllAnimations];
        showImage.layer.contents = nil;
        CFRelease(readGif);
        
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
