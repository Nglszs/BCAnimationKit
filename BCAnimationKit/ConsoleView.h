//
//  ConsoleView.h
//  BCAnimationKit
//
//  Created by Jack on 16/12/8.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic ,strong) UITextView *logView;
@end
