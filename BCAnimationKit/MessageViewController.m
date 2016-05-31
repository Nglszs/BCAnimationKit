//
//  MessageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

#import "MessageFrame.h"

#import "MessageEnterView.h"
@interface MessageViewController ()<MessageEnterViewDelegate,UITextViewDelegate>
{
    UITableView *testTableView;
    NSMutableArray  *allMessagesData;//所有数据
    MessageEnterView *messageView;
    
    NSDictionary *contentDic;//每条信息的具体内容
    
   CGFloat tempHeight; 
}
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
    
    
    messageView = [[MessageEnterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(testTableView.frame), BCWidth, 50)];
    messageView.delegate = self;
    messageView.enterView.delegate = self;
    [self.view addSubview:messageView];
    
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


#pragma mark 录音按钮

- (void)voiceButton {






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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
