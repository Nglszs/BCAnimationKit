//
//  UIImage+Common.h
//  BCAnimationKit
//
//  Created by Jack on 16/8/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

/**
 *  通过传入data来判断图片类型
 *
 *  @param data [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
 *
 *  @return 返回图片类型
 */
- (NSString *)contentTypeForImageData:(NSData *)data;


/**
 *  给图片设置圆形，当前这个在iOS9之后 系统会自动处理，这个方法仅供学习
 *
 *  @return 圆角图片
 */
- (UIImage *)cutCircleImage;
@end
