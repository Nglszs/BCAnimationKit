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
#import "BCPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define photoWidth (BCWidth - 50)/4
#define tempValue 10 //10个像素的间隙


@interface AddPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
   
    NSInteger photoCount;
    NSMutableArray *imageArray;//用来上传图片，里面保存的是路径

}
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIView *photoBackView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;


@property (nonatomic, strong) ALAssetsLibrary *assetslibrary;
@property (nonatomic, strong) NSMutableArray *albumArrayM;//相册数量
@property (nonatomic, strong) NSMutableArray *photosArrayM;//图片数量
@end

@implementation AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    self.title = @"添加图片";
    
    imageArray = [[NSMutableArray alloc] init];
    
    photoCount = 0;
    //一个页面之放四张图片，所以需要计算下位置,每张图片之间的间隔为10，宽度只够存放四张图片
    
 
    
    _photoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, BCWidth, photoWidth)];
    _photoBackView.backgroundColor = GreenColor;
    [self.view addSubview:_photoBackView];
    
    
    _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPhotoBtn.frame = CGRectMake(tempValue, 0, photoWidth, photoWidth);
    _addPhotoBtn.backgroundColor = line228Color;
    [_addPhotoBtn setImage:[UIImage imageNamed:@"btn_addPic"] forState:UIControlStateNormal];
    [_addPhotoBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_photoBackView addSubview:_addPhotoBtn];


    
    //通知来刷新图片
   [[NSNotificationCenter defaultCenter] addObserverForName:@"IMG" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
       
       NSArray *imageArr = (NSArray *)note.object;
       
       
       for (int i = 0; i < imageArr.count; i ++) {
           
           [self showChosePhoto:[imageArr objectAtIndex:i]];
       }

   }];
    
    
    
}

- (void)addPhotoAction {

    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        NSLog(@"无权限");
        
        return;
        
    }
    
    if (type == 0) {//从相册中读取
    
        
        __weak typeof(self) weakSelf = self;
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        NSBlockOperation *enumP = [NSBlockOperation blockOperationWithBlock:^{
            
            [self.assetslibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
                    
                    //[weakSelf.albumArrayM addObject:group];
                    
                    
//                   [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                    
                  
                    
                        
                        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                            
                            if (result) {
                                [weakSelf.photosArrayM addObject:result];
                            }
                            
                            
                            
                        }];

                    
                    
                    
                }
                
                
            } failureBlock:^(NSError *error) {
                
                
                NSLog(@"获取相册失败");
            }];
            
        }];
        
        
        NSBlockOperation *reloadOp = [NSBlockOperation blockOperationWithBlock:^{
            if (self.photosArrayM.count > 0) {
                
                BCPhotoViewController *photoVC = [[BCPhotoViewController alloc] init];
                photoVC.assetArray = [[weakSelf.photosArrayM reverseObjectEnumerator] allObjects];
                
                [self.navigationController pushViewController:photoVC animated:YES];

            }
            
            
        }];
        
        [reloadOp addDependency:enumP];
        [queue addOperation:enumP];
        [queue addOperation:reloadOp];

        
    } else {
    
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    
    }
    
    
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *newImage;
    
    
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//拍照
    
           newImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
    

    

        }
   
        [self showChosePhoto:newImage];
    
    
}


- (void)showChosePhoto:(UIImage *)newImage {

    photoCount ++;
    //这里是用数组将图片途径都保存起来，然后方便后面的删除，以及上传服务器
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    
        
        NSString *subPath = [filePath stringByAppendingPathComponent:@"IMG"];//二级文件夹，二级文件夹必须同filemanage创建
        NSString *str = [self getCurrentTimeString];
        NSString *imageName = [NSString stringWithFormat:@"%@.png", str];
        NSString *imagePath = [subPath stringByAppendingPathComponent:imageName];
        
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            NSLog(@"文件夹创建失败。正在重新创建。。");
            
            [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
            
        } else {
            
            NSLog(@"FileDir is exists.");
        }

        [imageData writeToFile:imagePath atomically:NO];
        [imageArray addObject:imagePath];//将图片路径保存起来
        
        NSLog(@"保存图片中");
    });
    
    
    
    
    if (photoCount%4 == 0 && photoCount != 0) {//改变背景的frame
        
        _photoBackView.frame = CGRectMake(0, 200, BCWidth,  (tempValue + photoWidth) * (photoCount/4 + 1) - tempValue);
    }
    
    //用imageview显示出来，然后移动button的位置
    UIImageView *showImage = [[UIImageView alloc] initWithFrame:CGRectMake(tempValue + (photoCount - 1)%4 * (photoWidth + tempValue),(tempValue + photoWidth) * ((photoCount - 1)/4), photoWidth, photoWidth)];
    showImage.tag = 400 + photoCount;
    showImage.layer.borderWidth = 1;
    showImage.layer.borderColor = DefaultColor.CGColor;
    showImage.image = newImage;
    [_photoBackView addSubview:showImage];
    
    _addPhotoBtn.frame = CGRectMake(tempValue + photoCount%4 * (photoWidth + tempValue), (tempValue + photoWidth) * (photoCount/4), photoWidth, photoWidth);
    
   
    
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
   

    
    
    //移除数组里相应的图片，也就是说，如果我选择了4张图片删除一张，其实在沙盒中还是4张，但是数组里就只剩三张了，再将这三张上传服务器即可，这就是数组存的目的,上传服务器直接数组里的地址就好了
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
        

        
        _photoBackView.frame = CGRectMake(0, 200, BCWidth, (tempValue + photoWidth) * photoCount/4 - tempValue);//后面需要去见到10px的像素
    }

    photoCount--;
    _addPhotoBtn.frame = CGRectMake(tempValue + photoCount%4 * (photoWidth + tempValue), (tempValue + photoWidth) * (photoCount/4), photoWidth, photoWidth);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
       
        NSString *subPath = [filePath stringByAppendingPathComponent:@"IMG"];
        BOOL isDelete = [BCClearCache clearCacheWithFilePath:subPath];
        if (isDelete) {
            
            NSLog(@"删除所有图片成功");
            
        } else {
            
            NSLog(@"删除所有图片失败");
        }

    }
}

#pragma mark  懒加载初始化
- (ALAssetsLibrary *)assetslibrary {
    if (!_assetslibrary) {
        _assetslibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetslibrary;
}
- (NSMutableArray *)albumArrayM {
    if (!_albumArrayM) {
        _albumArrayM = [NSMutableArray array];
    }
    
    return _albumArrayM;
}


- (NSMutableArray *)photosArrayM {
    if (!_photosArrayM) {
        _photosArrayM = [NSMutableArray array];
    }
    
    return _photosArrayM;
}


- (UIImagePickerController *)imagePicker {

    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        
    }
    return _imagePicker;

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
