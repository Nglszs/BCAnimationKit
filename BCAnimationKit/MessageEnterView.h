//
//  MessageEnterView.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageEnterViewDelegate <NSObject>

@optional

- (void)adjustViewFrame:(CGFloat)frame;



@end

@interface MessageEnterView : UIView
{

    UIButton *leftBtn;
    UIButton *rightBtn;
    
  
}
@property (nonatomic, strong) UIButton *clickBtn;  //按住说话
@property (nonatomic, strong) UITextView *enterView;
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *photoBtn;

@property (nonatomic ,weak) id<MessageEnterViewDelegate>delegate;
@end
