//
//  CorpImageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/10.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CorpImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CropRect CGRectMake((BCWidth - 200)/2, (BCHeight - 200)/2, 200, 200)
@implementation CorpImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //首先实现遮罩，遮罩实现的方式有两种，这里用CAShapeLayer,难点其实就在于坐标的获取
   
    
    
    _backgroundImage = [[UIImageView alloc] init];
    _backgroundImage.backgroundColor = [UIColor lightGrayColor];
    _backgroundImage.userInteractionEnabled = YES;
   
    [self.view addSubview:_backgroundImage];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"打开相册"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(openPicker)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [_backgroundImage addGestureRecognizer:pan];
    
    //捏合手势
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    
    [_backgroundImage addGestureRecognizer:pinch];
    
   

    
}
-(void)pan:(UIPanGestureRecognizer *)pan {
    

    
    
    CGPoint point = [pan translationInView:pan.view];
    UIImageView * imageV = (UIImageView *)pan.view;
    
    imageV.transform = CGAffineTransformTranslate(imageV.transform, point.x, point.y);
    
    
    //计算尺寸
    CGFloat x = (CropRect.origin.x - _backgroundImage.frame.origin.x) / _backgroundImage.frame.size.width * _backgroundImage.image.size.width;
    CGFloat y = (CropRect.origin.y - _backgroundImage.frame.origin.y) / _backgroundImage.frame.size.height * _backgroundImage.image.size.height;
    CGFloat dx = (CGRectGetMaxX(_backgroundImage.frame) - CGRectGetMaxX(CropRect)) / _backgroundImage.frame.size.width * _backgroundImage.image.size.width;
    CGFloat dy = (CGRectGetMaxY(_backgroundImage.frame) - CGRectGetMaxY(CropRect)) /_backgroundImage.frame.size.height * _backgroundImage.image.size.height;
    CGFloat dw = _backgroundImage.image.size.width - (dx + x);
    CGFloat dh = _backgroundImage.image.size.height - (y + dy);
    
    
    realRect = CGRectMake(x,y,dw,dh);
    [pan setTranslation:CGPointZero inView:imageV];
    
    
}

-(void)pinch:(UIPinchGestureRecognizer *)pinch
{
    
    UIImageView * imageV = (UIImageView *)pinch.view;
    //这里的缩放最好要限制，不然会造成手势失效的情况
    imageV.transform = CGAffineTransformScale(imageV.transform, pinch.scale, pinch.scale);
    
 
    //计算尺寸
    CGFloat x = (CropRect.origin.x - _backgroundImage.frame.origin.x) / _backgroundImage.frame.size.width * _backgroundImage.image.size.width;
    CGFloat y = (CropRect.origin.y - _backgroundImage.frame.origin.y) / _backgroundImage.frame.size.height * _backgroundImage.image.size.height;
    CGFloat dx = (CGRectGetMaxX(_backgroundImage.frame) - CGRectGetMaxX(CropRect)) / _backgroundImage.frame.size.width * _backgroundImage.image.size.width;
    CGFloat dy = (CGRectGetMaxY(_backgroundImage.frame) - CGRectGetMaxY(CropRect)) /_backgroundImage.frame.size.height * _backgroundImage.image.size.height;
    CGFloat dw = _backgroundImage.image.size.width - (dx + x);
    CGFloat dh = _backgroundImage.image.size.height - (y + dy);
    
    realRect = CGRectMake(x,y,dw,dh);
    
    pinch.scale = 1.0;



}
- (void)openPicker {

    
    //权限判断
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        NSLog(@"无权限");
        
    } else {
        
    UIImagePickerController *_imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    [self presentViewController:_imagePicker animated:NO completion:nil];
    
   }

}

#pragma mark UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _backgroundImage.frame = CGRectMake(0, 0, BCWidth, BCWidth/newImage.size.width * newImage.size.height);
    _backgroundImage.image = nil;
    _backgroundImage.image = newImage;
    
    [self.view.layer addSublayer:self.shapeLayer];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.certainButton];

}

- (UIButton *)cancelButton {

    if (!_cancelButton) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(0,BCHeight - 50 - 64, BCWidth / 2.0, 50);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:DefaultColor forState:UIControlStateNormal];
        self.cancelButton.tag = 10010;
        self.cancelButton.backgroundColor = [UIColor lightGrayColor];
        [_cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    }

    return _cancelButton;
}

- (UIButton *)certainButton {

    if (!_certainButton) {
        self.certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.certainButton.frame = CGRectMake(BCWidth / 2.0, BCHeight - 50 - 64, BCWidth / 2.0, 50);
        [self.certainButton setTitle:@"确定" forState:UIControlStateNormal];
        self.certainButton.tag = 10086;
        self.certainButton.backgroundColor = [UIColor orangeColor];
        [_certainButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _certainButton;
}

- (CAShapeLayer *)shapeLayer {//添加遮罩

    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = BCScreen;
        
        UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:BCScreen];
        
        //这里可以设为圆形或者圆角，我设的为圆角
       [bPath appendPath:[UIBezierPath bezierPathWithRoundedRect:CropRect cornerRadius:10]];
        [bPath setUsesEvenOddFillRule:YES];
        _shapeLayer.path = bPath.CGPath;
        _shapeLayer.fillRule = kCAFillRuleEvenOdd;
        _shapeLayer.fillColor = [UIColor blackColor].CGColor;
        _shapeLayer.opacity = .75;
        
       
    }
    
    return _shapeLayer;

}


//按钮的点击事件
- (void)clickButton:(UIButton *)btn {
    
    switch (btn.tag) {
        case 10010:
            [self.shapeLayer removeFromSuperlayer];
            //[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            break;
            
        default: {//裁剪图片
             [self.shapeLayer removeFromSuperlayer];
            
            CGImageRef subImageRef = CGImageCreateWithImageInRect(_backgroundImage.image.CGImage   , realRect);
            UIImage *newImage = [UIImage imageWithCGImage:subImageRef];
            
            //显示裁剪后的图片尺寸设置,可以自己定义
           
            _backgroundImage.frame = CGRectMake(0, 0, BCWidth, BCWidth/newImage.size.width * newImage.size.height);
           
            _backgroundImage.image = newImage;
            
            NSLog(@"%@",NSStringFromCGSize([UIImage imageWithCGImage:subImageRef].size));
            CFRelease(subImageRef);
            
        }
            break;
    }
    
    
}

@end
