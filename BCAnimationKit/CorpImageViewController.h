//
//  CorpImageViewController.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/10.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BaseViewController.h"

@interface CorpImageViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{

    CGRect realRect;//裁剪的rect

}
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, strong) UIButton *cancelButton; //取消按钮
@property (nonatomic, strong) UIButton *certainButton; //确定按钮


@property (nonatomic, strong) UIScrollView *mainScrollView; //确定按钮
@end
