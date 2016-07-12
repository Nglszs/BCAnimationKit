//
//  BaseViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GetDataCompletion)(NSData *data);
@interface BaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{

    BOOL isEtag;
}

/**
 
 下面的属性适合网络缓存框架有关的，这里并没有用上，只是写出来
 */
@property (nonatomic, copy) NSString *etag;
@property (nonatomic, copy) NSString *localLastModified;

    
//下面这个方法与动画无关
- (void)sendData:(void (^)(BOOL finish))block;
@end
