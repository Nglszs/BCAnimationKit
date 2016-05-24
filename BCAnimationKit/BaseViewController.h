//
//  BaseViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

//下面这个方法与动画无关
- (void)sendData:(void (^)(BOOL finish))block;
@end
