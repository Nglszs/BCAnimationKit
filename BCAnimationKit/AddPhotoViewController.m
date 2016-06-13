//
//  AddPhotoViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/13.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "AddPhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BCClearCache.h"

#define photoWidth (BCWidth - 50)/4
@interface AddPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{

    NSInteger photoCount;
    NSMutableArray *imageArray;//用来上传图片，里面保存的是路径

}
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIView *photoBackView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加图片";
    
    imageArray = [[NSMutableArray alloc] init];
    
    photoCount = 0;
    //一个页面之放四张图片，所以需要计算下位置,每张图片之间的间隔为10，宽度只够存放四张图片
    
 
    
    _photoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, BCWidth, photoWidth)];
    _photoBackView.backgroundColor = GreenColor;
    [self.view addSubview:_photoBackView];
    
    
    _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPhotoBtn.frame = CGRectMake(10, 0, photoWidth, photoWidth);
    _addPhotoBtn.backgroundColor = line228Color;
    [_addPhotoBtn setImage:[UIImage imageNamed:@"btn_addPic"] forState:UIControlStateNormal];
    [_addPhotoBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_photoBackView addSubview:_addPhotoBtn];



}


- (void)addPhotoAction {

    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@"UIImagePickerController" message:@"使用UIImagePickerController" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:sheetController animated:YES completion:nil];

    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self cameraFromUIImagePickerController:0];
        
    }];
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self cameraFromUIImagePickerController:1];
        
    }];
  
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [sheetController addAction:albumAction];
    [sheetController addAction:pictureAction];
    [sheetController addAction:cancelAction];


}

- (void)cameraFromUIImagePickerController:(NSUInteger)type {

    
    
    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc] init];
         _imagePicker.delegate = self;
        
    }
    if (type == 0) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
    } else {
    
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    }
    
    photoCount ++;
   
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *newImage;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
      newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    } else {//拍照
    
    
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//拍照
    
           newImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    }

        
       

}
   
    
    //这里是用数组将图片途径都保存起来，然后方便后面的删除，以及上传服务器
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
       // NSString *str = [self getCurrentTimeString];
        
        NSString *subPath = [filePath stringByAppendingPathComponent:@"IMG"];//二级文件夹
        NSString *str = [self getCurrentTimeString];
        NSString *imageName = [NSString stringWithFormat:@"%@.png", str];
        NSString *imagePath = [subPath stringByAppendingPathComponent:imageName];
        [imageData writeToFile:imagePath atomically:NO];
        [imageArray addObject:imagePath];//将图片路径保存起来
        
        NSLog(@"保存图片中");
    });
   

    
   
    if (photoCount%4 == 0 && photoCount != 0) {//改变背景的frame
        
        _photoBackView.frame = CGRectMake(0, 300, BCWidth, (10 + photoWidth) * (photoCount/4 + 1));
    }
    
    //用imageview显示出来，然后移动button的位置
    UIImageView *showImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (photoCount - 1)%4 * (photoWidth + 10),(10 + photoWidth) * ((photoCount - 1)/4), photoWidth, photoWidth)];
    showImage.tag = 400 + photoCount;
    showImage.layer.borderWidth = 1;
    showImage.layer.borderColor = DefaultColor.CGColor;
    showImage.image = newImage;
    [_photoBackView addSubview:showImage];
    
    _addPhotoBtn.frame = CGRectMake(10 + photoCount%4 * (photoWidth + 10), (10 + photoWidth) * (photoCount/4), photoWidth, photoWidth);

    
    //删除按钮
    UIButton *deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteImageBtn.tag = 500 + photoCount;
    deleteImageBtn.frame = CGRectMake(CGRectGetMaxX(showImage.frame) - 12,CGRectGetMinY(showImage.frame) - 5, 20, 20);
    [deleteImageBtn setImage:[UIImage imageNamed:@"icon_photo_delete"] forState:UIControlStateNormal];
    [deleteImageBtn addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];

    [_photoBackView addSubview:deleteImageBtn];
    
    
}

- (void)deletePhotoAction:(UIButton *)button {

    NSInteger index = button.tag - 500;
    NSLog(@"%ld",index);

    
    
    //移除数组里相应的图片，也就是说，如果我选择了4张图片删除一张，其实在沙盒中还是4张，但是数组里就只剩三张了，再将这三张上传服务器即可，这就是数组存的目的
    [imageArray removeObjectAtIndex:(index - 1)];

    //移除相应显示的imageview和button
    
    UIImageView *imageView = (UIImageView *)[_photoBackView viewWithTag:(400 + index)];
    [imageView removeFromSuperview];
    imageView = nil;
    [button removeFromSuperview];
    button = nil;
    
    
    for (NSInteger i = index; i < photoCount; i ++) {
        
        UIImageView *photoImageView = (UIImageView *)[_photoBackView viewWithTag:(400 + i + 1)];
        photoImageView.frame = CGRectMake(10 + (i - 1)%4 * (photoWidth + 10),(10 + photoWidth) * ((i - 1)/4), photoWidth, photoWidth);
        photoImageView.tag--;
        
        
         UIButton *deButton = (UIButton *)[_photoBackView viewWithTag:(500 + i + 1)];
        
        deButton.frame = CGRectMake(CGRectGetMaxX(photoImageView.frame) - 12,CGRectGetMinY(photoImageView.frame) - 5, 20, 20);

        deButton.tag--;
    }
    
    
    
    
    
    
    if (photoCount%4 == 0 && photoCount != 0) {//改变背景的frame
        
        _photoBackView.frame = CGRectMake(0, 300, BCWidth, photoWidth * photoCount/4);
    }

    photoCount--;
    _addPhotoBtn.frame = CGRectMake(10 + photoCount%4 * (photoWidth + 10), (10 + photoWidth) * (photoCount/4), photoWidth, photoWidth);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
       
        NSString *subPath = [filePath stringByAppendingPathComponent:@"IMG"];
        BOOL isDelete = [BCClearCache clearCacheWithFilePath:subPath];
        if (isDelete) {
            
            NSLog(@"删除所有图片");
            
        } else {
            
            NSLog(@"删除所有图片失败");
        }

    }
}


- (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateformat stringFromDate:[NSDate date]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
