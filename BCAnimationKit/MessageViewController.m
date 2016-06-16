//
//  MessageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "MessageFrame.h"

#import "MessageEnterView.h"
@interface MessageViewController ()<MessageEnterViewDelegate,UITextViewDelegate>
{
    UITableView *testTableView;
    NSMutableArray  *allMessagesData;//所有数据
    MessageEnterView *messageView;
    
    NSDictionary *contentDic;//每条信息的具体内容
    
    CGFloat tempHeight;
    
    AVAudioSession *audioSession;
}
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *soundImageView;//音量大小
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BCWidth, BCHeight - 64 - 50) style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    testTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    testTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    
    [self.view addSubview:testTableView];
    
    //聊天框
    messageView = [[MessageEnterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(testTableView.frame), BCWidth, 50)];
    messageView.delegate = self;
    messageView.enterView.delegate = self;
    [self.view addSubview:messageView];
    
    //按下录音
    [messageView.clickBtn addTarget:self action:@selector(voiceButton) forControlEvents:UIControlEventTouchDown];
    //松开发送
    [messageView.clickBtn addTarget:self action:@selector(stopRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //从按钮内部移到按钮外部
    [messageView.clickBtn addTarget:self action:@selector(showCancelRecord) forControlEvents:UIControlEventTouchDragExit];
    //从按钮外部移到按钮内部
    [messageView.clickBtn addTarget:self action:@selector(goOnRecord) forControlEvents:UIControlEventTouchDragEnter];
    //在按钮外松开
    [messageView.clickBtn addTarget:self action:@selector(cancelRecordButtonAction) forControlEvents:UIControlEventTouchUpOutside];

    
    
    
    
    allMessagesData = [NSMutableArray arrayWithCapacity:1];
    
    
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

}


- (void)addData:(UITextView *)textView {

    contentDic = [NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"Content",@"head.jpg",@"HeadImage",MessageFromMe,@"FromType",@"0",@"MsgType", nil];
    
    

    
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    
    MessageModel *messageModel = [MessageModel parseFromDict:contentDic];
    messageFrame.messageModel = messageModel;
    [allMessagesData addObject:messageFrame];
    
    
    
    //这里添加机器人数据
  NSDictionary  *conDic = [NSDictionary dictionaryWithObjectsAndKeys:@"呵呵哒",@"Content",@"bc.jpg",@"HeadImage",@"1",@"FromType",MessageText,@"MsgType", nil];
    
    
    
    MessageFrame *messageFrame1 = [[MessageFrame alloc] init];
    
    MessageModel *messageModel1 = [MessageModel parseFromDict:conDic];
    messageFrame1.messageModel = messageModel1;
    [allMessagesData addObject:messageFrame1];

    
    
    [testTableView reloadData];

    
   


}

#pragma mark 代理相关


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {



    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return allMessagesData.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    return [allMessagesData[indexPath.row] cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellid = @"cee";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    cell.messageFrame = allMessagesData[indexPath.row];
    return cell;


}

#pragma mark 调整输入框的额尺寸

- (void)adjustViewFrame:(CGFloat)frame {

    
    tempHeight = frame - 50;
   CGFloat changeHeight = frame - CGRectGetHeight(messageView.frame);
   
    testTableView.frame = CGRectMake(0, CGRectGetMinY(testTableView.frame), BCWidth, CGRectGetHeight(testTableView.frame) - changeHeight);
    messageView.frame = CGRectMake(0, CGRectGetMaxY(testTableView.frame) , BCWidth, frame);


   
}


#pragma mark 录音相关

- (void)voiceButton {

    //设置定时检测
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    
    
    
    if (![self isAVAudioSessionAvaliable]) {//判断权限
        NSLog(@"没有录音权限");
        
        
        return;
    }
    //初始化相关的view
    [messageView.clickBtn setTitle:@"松开发送" forState:UIControlStateNormal];
    [self.view addSubview:self.soundImageView];

   //音频回话设置
    audioSession =[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    if(audioSession == nil) {
        NSLog(@"Error creating session");
    }
    else {
        [audioSession setActive:YES error:nil];
    }

    
    //录音文件路径设置
    NSString *subPath = [filePath stringByAppendingPathComponent:@"VOICE"];//二级文件夹
    NSString *str = [self getCurrentTimeString];
    NSString *imageName = [NSString stringWithFormat:@"%@.caf", str];
    NSString *imagePath = [subPath stringByAppendingPathComponent:imageName];

    //录音播放路径
     NSURL *fileUrl = [NSURL fileURLWithPath:imagePath];
    
    //录音参数设置
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了,如果不够增大数字
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];//单声道还是双声道，单身道为1
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    [dicM setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];  //音频质量,采样质量
    
    //录音机
    _recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:dicM error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];

   
    
    
}
- (void)stopRecordButtonAction:(UIButton *)button {
    
    [messageView.clickBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    
    CGFloat currentTime = _recorder.currentTime;
    messageView.clickBtn.enabled = NO;
    
    
   
        
        if (currentTime >= 2) {
            
        
    }

}




- (void)detectionVoice {

    [_recorder updateMeters];//刷新音量数据
   CGFloat testVolume = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    if (0<testVolume<=0.125) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_1"]];
    }else if (0.125<testVolume<=0.250) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_2.png"]];
    }else if (0.250<testVolume<=0.375) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_3.png"]];
    }else if (0.375<testVolume<=0.500) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_4.png"]];
    }else if (0.500<testVolume<=0.625) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_5.png"]];
    }else if (0.625<testVolume<=0.750) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_6.png"]];
    }else if (0.750<testVolume<=0.875) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_7.png"]];
    }else if (0.875<testVolume<=1.000) {
        [self.soundImageView setImage:[UIImage imageNamed:@"icon_soundvoule_8.png"]];
    }

}
- (NSString*)getCurrentTimeString {
    
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateformat stringFromDate:[NSDate date]];
}

- (UIImageView *)soundImageView {
    if (!_soundImageView) {
        //语音图片
        _soundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
        _soundImageView.center = self.view.center;
        [_soundImageView setImage:[UIImage imageNamed:@"sound_1"]];
    }

    return _soundImageView;

}
#pragma  mark textview代理

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

   
    if ([text isEqualToString:@"\n"]) {
        
       
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *intText = [textView.text stringByTrimmingCharactersInSet:set];

        if (intText.length == 0) {
            
            NSLog(@"不能发送空的内容");
            
            return NO;
        }
       

        [self addData:textView];
        
        
        
        messageView.enterView.text = nil;
      
        
        if (allMessagesData && allMessagesData.count != 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:allMessagesData.count - 1 inSection:0];
            [testTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }

        
       
    }




    return YES;


}


- (void)textViewDidChange:(UITextView *)textView {
    
  

    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    //获取textView内容的高度
    CGRect textFrame = [[textView layoutManager] usedRectForTextContainer:[textView textContainer]];
    CGFloat height = textFrame.size.height;
    
    CGFloat textHeight;
    if (height <= 32) {
        
        textHeight = 32;
        
    } else if (height > 78) {
        
        textHeight = 78;
        
    } else {
        
        textHeight = height;
        
    }
   
    
//
//    
//    enterView.enterView.frame = CGRectMake(CGRectGetMinX(enterView.enterView.frame), CGRectGetMinY(enterView.enterView.frame), CGRectGetWidth(enterView.enterView.frame), textHeight + 18);
//    
//   
//
 

}


#pragma mark  键盘监听

- (void)keyboardWillShow:(NSNotification *)noti {
    
    //取得键盘的高度
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    __block UITableView *table = testTableView;
    
   
        
    
        
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            
            table.frame = CGRectMake(0, 64, BCWidth,BCHeight - 114 - keyboardHeight - tempHeight);
            
             messageView.frame = CGRectMake(0, CGRectGetMaxY(testTableView.frame)  , BCWidth, CGRectGetHeight(messageView.frame));
            
        } completion:^(BOOL finished) {
            
        }];
    
}


- (void)keyboardWillHidden:(NSNotification *)noti {
    
    __block UITableView *table = testTableView;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        table.frame = CGRectMake(0, 64, BCWidth, BCHeight - 64 - 50 - tempHeight);
        
        messageView.frame = CGRectMake(0, CGRectGetMaxY(testTableView.frame)  , BCWidth, CGRectGetHeight(messageView.frame));
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) isAVAudioSessionAvaliable {
    
    __block BOOL flag = nil;
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                flag = YES;
            }
            else {
                // Microphone disabled code
                flag = NO;
                
            }
        }];
    }
    
    return flag;
    
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
