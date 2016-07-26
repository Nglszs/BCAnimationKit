//
//  NumberView.h
//  HEHEH
//
//  Created by Jack on 16/7/26.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberView : UIView
{

    NSMutableArray *numbersText;
    NSMutableArray *scrollLayers;
     NSMutableArray *scrollLabels;
}
/**
 目标值
 */
@property (strong, nonatomic) NSNumber *tempValue;
@property (assign, nonatomic) NSUInteger minLength;//数字最小长度
- (instancetype)initViewFrame:(CGRect)frame andValue:(NSNumber *)value;
- (void)startAnimation;
@end
