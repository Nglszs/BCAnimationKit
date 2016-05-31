//
//  SpeechViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/30.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SpeechViewController.h"
#import <iflyMSC/iflyMSC.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import "ISRDataHelper.h"
@interface SpeechViewController ()<IFlySpeechRecognizerDelegate>
{
    UITextView *testTextView;
    
    UIButton *clickButton;
    UILabel *showLabel;

}

@property (nonatomic, strong) IFlySpeechRecognizer *iflySpeechRecognizer;
@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"57479cb8"];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake((BCWidth - 100)/2, 80, 100, 50)];
    
    showLabel.textColor = DefaultColor;
    showLabel.font = NewText20Font;
    [self.view addSubview:showLabel];
    
    testTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 200, BCWidth - 100, 200)];
    testTextView.layer.borderColor = DefaultColor.CGColor;
    testTextView.layer.borderWidth = 1;
    testTextView.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:testTextView];

    
  
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startButton.frame = CGRectMake(20, 500, 100, 50);
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startSpeech) forControlEvents:UIControlEventTouchUpInside];

    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    finishButton.frame = CGRectMake(170, 500, 100, 50);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:finishButton];
    [finishButton addTarget:self action:@selector(stopRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];

  
    
}

- (void)startSpeech {
    
    showLabel.text = @"开始";
    if (!self.iflySpeechRecognizer) {
        self.iflySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        self.iflySpeechRecognizer.delegate = self;
        [_iflySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        [self.iflySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        [self.iflySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        [self.iflySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        //设置音频来源为麦克风
        [_iflySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        //设置最长录音时间
        [_iflySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //设置采样率，推荐使用16K
        [_iflySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        
        //设置语言
        [_iflySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        
        //设置是否返回标点符号
        [_iflySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
        //设置方言--粤语
       // [_iflySpeechRecognizer setParameter:[IFlySpeechConstant ACCENT_CANTONESE] forKey:[IFlySpeechConstant ACCENT]];
        
    }
    
    
    
    
    [_iflySpeechRecognizer startListening];
    
   



}

- (void)stopRecordButtonAction:(UIButton *)button {

showLabel.text = @"完成";
    
    [_iflySpeechRecognizer stopListening];

}
#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    NSLog(@"%@",vol);
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"开始说话");
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"说话完成");
    
    
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    
    if (error.errorCode != 0) {
        
        NSLog(@"-------出错");
    }
    
}

/**
 听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    
    
    
        NSMutableString *resultString = [[NSMutableString alloc] init];
        NSDictionary *dic = results[0];
        for (NSString *key in dic) {
            [resultString appendFormat:@"%@",key];
        }
        NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
        
        testTextView.text = [NSString stringWithFormat:@"%@%@",testTextView.text,resultFromJson];

   
    
    
    
    
    
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
