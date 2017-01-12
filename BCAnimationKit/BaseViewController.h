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
 
 下面的属性适合网络缓存框架有关的
 */
@property (nonatomic, copy) NSString *etag;
@property (nonatomic, copy) NSString *localLastModified;

    
//下面这个方法与动画无关
- (void)sendData:(void (^)(BOOL finish))block;

#ifdef __IPHONE_9_0



#else


#endif


/**
 下面是一个带block的写法，这里并没有声明某个block 的属性而是直接去调用它，这种方法暂时没发现什么影响，当然也可以声明block属性，具体区别可以参考云盘里的mvvm框架
 */
//typedef void (^ReturnValueBlock) (id returnValue);
//typedef void (^ErrorCodeBlock) (id errorCode);
//
//@interface MovieViewModel : NSObject
//
//
//
////获取电影数据
//- (void)getMovieData:(ReturnValueBlock)data failTure:(ErrorCodeBlock)errorCode;

//.m中的实现方法
//- (void)getMovieData:(ReturnValueBlock)data failTure:(ErrorCodeBlock)errorCode{
//  
//    
//    
//    
//    
//    if(有数据) {
//        //这里不声明block具体属性也是可以的，直接用下面的赋值就行，如果写了属性就用下面被屏蔽的两行,屏蔽最后一行，暂时没发现这两种写法的区别
//        //        _Successblock = data;
//        //        _Successblock(modelArr);
//
//     data(modelArr);
//    
//    } else {
//     errorCode(error);
//    
//    }
//        
//    
//        
//    
//   
//}

@end
