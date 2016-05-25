//
//  BCFlowLayout.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/23.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,Animations) {

    UICollectionViewAnimation1,
    UICollectionViewAnimation2


};

@interface BCFlowLayout : UICollectionViewFlowLayout

/**
 
 这里我只是写了两种动画，需要的可以自己添加动画
 
 */

@property (nonatomic, assign) Animations animationType;
@end
