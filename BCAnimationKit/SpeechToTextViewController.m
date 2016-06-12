//
//  SpeechToTextViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/12.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SpeechToTextViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SpeechToTextViewController ()<AVSpeechSynthesizerDelegate>
{

    // 合成器
    
    AVSpeechSynthesizer *testSynthesizer;
    // 实例化说话的语言，说中文、英文
    
    AVSpeechSynthesisVoice *testVoice;
    
    UILabel *showLabel;
}
@end

@implementation SpeechToTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    showLabel.center = self.view.center;
    showLabel.textColor = DefaultColor;
    [self.view addSubview:showLabel];
    
    // 实例化说话的语言，说中文
    testVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-HK"];
    
      NSLog(@"%@",[AVSpeechSynthesisVoice currentLanguageCode]);
    // 要朗诵，需要一个语音合成器
    testSynthesizer = [[AVSpeechSynthesizer alloc] init];
    testSynthesizer.delegate = self;
    
    
  
    // 实例化发声的对象，及朗读的内容
     AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"今天天气不错,适合出去游泳"];
    
    
    utterance.voice = testVoice;
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    //utterance.pitchMultiplier = 0.8f; //改变合成声音的音调
    
    [testSynthesizer speakUtterance:utterance];
}


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {

    showLabel.text = @"正在朗读";

}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {

    showLabel.text = @"说话已完成";

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
