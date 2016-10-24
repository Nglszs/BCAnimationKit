//
//  BaseViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "BCKeyChain.h"
#import "BCClearCache.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation BaseViewController

NSString * const KEY_USERNAME_PASSWORD = @"com.jack.app.usernamepassword";;
NSString * const KEY_USERNAME = @"com.company.app.username";
NSString * const KEY_PASSWORD = @"com.company.app.password";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
    
   //这里可以用单例也可以用AppDelegate，这里用AppDelegate来实现
    
    AppDelegate *newAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (newAppDelegate.isNightModel) {//这里也可以通过获取偏好存储，也就是说偏好和appdelegate二者取一0
       
        [self openNightModel];
        
    } else {
    
        [self openDayModel];
    
    }
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDayModel) name:Day object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNightModel) name:Night object:nil];
   
 
    //保存用户名和密码
    
   // NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    //    [usernamepasswordKVPairs setObject:@"jack" forKey:KEY_USERNAME];
    //    [usernamepasswordKVPairs setObject:@"123" forKey:KEY_PASSWORD];
  //      [BCKeyChain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
    
    
    //获取用户名和密码
//    NSMutableDictionary *usernamepasswordKVPairs1 = (NSMutableDictionary *)[BCKeyChain load:KEY_USERNAME_PASSWORD];
//    NSString *name = [usernamepasswordKVPairs1 objectForKey:KEY_USERNAME];
//    NSString *pass = [usernamepasswordKVPairs1 objectForKey:KEY_PASSWORD];
//
//    
//   NSLog(@"%@ -- %@",name,pass);
//    删除用户
//    [BCKeyChain delete:KEY_USERNAME_PASSWORD];

    
    //封装一个weakself
    //    WS(ws);
    //    ws.view
    
     
    //下面这个方法是参考知乎的退出app后再次进入会自动跳转上一次进入的界面
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
}
#pragma mark  进入后台的通知
- (void)appDidEnterBackground {


    NSLog(@"当前的界面为%@",NSStringFromClass([self class]));
    
   
        
        [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass([self class]) forKey:@"MAIN"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
   


}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"当前界面已释放");

}

- (void)openNightModel {

    NSLog(@"开启夜间模式");

}
- (void)openDayModel {



}

- (void)sendData:(void (^)(BOOL))block {


    if (block) {//这里暂时用block代替，如果是网络请求可以用来判断是否有返回数据
        block(YES);
    }


}
#pragma  mark  网络请求缓存框架,这里用etag和LastModified两种方法结合


- (void)getDataFromInternet:(GetDataCompletion)completion {
    //支持etag
   NSString *kETagImageURL = @"http://ac-g3rossf7.clouddn.com/xc8hxXBbXexA8LpZEHbPQVB.jpg";
    
    //下面这个链接不支持etag
    NSString *kLastModifiedImageURL = @"http://image17-c.poco.cn/mypoco/myphoto/20151211/16/17338872420151211164742047.png";

    
    //上面不管用哪个连接，这里都会进行缓存，下面进行了判断
    NSURL *url = [NSURL URLWithString:kETagImageURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];

    if (isEtag) {
        // 发送 etag
        if (self.etag.length > 0) {
            [request setValue:self.etag forHTTPHeaderField:@"If-None-Match"];
        }

    } else {
    
        if (self.localLastModified.length > 0) {
            [request setValue:self.localLastModified forHTTPHeaderField:@"If-Modified-Since"];
        }

    
    }

    //请求
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
       
        //判断是否支持etag
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (httpResponse.allHeaderFields[@"Etag"]) {
            
            isEtag = YES;
            NSLog(@"支持etag");
            
            if (httpResponse.statusCode == 304) {
                
                NSLog(@"加载本地缓存图片");
                // 如果是，使用本地缓存
                // 根据请求获取到`被缓存的响应`！
                NSCachedURLResponse *cacheResponse =  [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
                // 拿到缓存的数据
                data = cacheResponse.data;
           
            }
            
            // 获取并且纪录 etag，区分大小写
            self.etag = httpResponse.allHeaderFields[@"Etag"];
            

        } else {
        
            NSLog(@"不支持etag");
            isEtag = NO;
        
            if (httpResponse.statusCode == 304) {
                NSLog(@"加载本地缓存图片");
                // 如果是，使用本地缓存
                // 根据请求获取到`被缓存的响应`！
                NSCachedURLResponse *cacheResponse =  [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
                // 拿到缓存的数据
              
                data = cacheResponse.data;
            }
            
            // 获取并且纪录 LastModified
            self.localLastModified = httpResponse.allHeaderFields[@"Last-Modified"];
        
        }
        
        
        if (data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                completion(data);
            });
        }
        
        
    }] resume];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    //[self getDataFromInternet:^(NSData *data) {
   
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    image.image = [UIImage imageWithData:data];
//    [[UIApplication sharedApplication].keyWindow addSubview:image];
    
//}];

}
//汉字转拼音
//- (NSString *)chineseToPinyin:(NSString *)chinese withSpace:(BOOL)withSpace {
//    CFStringRef hanzi = (__bridge CFStringRef)chinese;
//    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, hanzi);
//    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
//    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
//    NSString *pinyin = (NSString *)CFBridgingRelease(string);
//    if (!withSpace) {
//        pinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
//    }
//    return pinyin;
//}

//返回文字高度
//- (CGFloat)getStringHeightNotFormatWith:(NSString*)tempStr width:(CGFloat)tempWidth font:(UIFont*)tempFont {
//    
//    CGRect rect = [tempStr boundingRectWithSize:CGSizeMake(tempWidth, 0)
//                                        options:NSStringDrawingUsesLineFragmentOrigin|        NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading
//                                     attributes:@{NSFontAttributeName:tempFont}
//                                        context:nil];
//    //文字的高度
//    float tempHeight = rect.size.height;
//    
//    return tempHeight;
//}



//四舍五入浮点数使用方法
 //NSLog(@"----%@---",[self decimalwithFormat:@"0" value:1.848]);

//- (NSString *) decimalwithFormat:(NSString *)format  value:(CGFloat)tempValue
//{
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    
//    [numberFormatter setPositiveFormat:format];
//    
//    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:tempValue]];
//}


//下面这个方法获取当前应用所占的存储空间，或者单独计算  下面给出方法
//   NSLog(@"%@",[BCClearCache getCacheSizeWithFilePath:NSHomeDirectory()]);
//
//    //这个方法获取整个设备的存储空间用量
//    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
//    NSFileManager* fileManager = [[NSFileManager alloc ]init];
// NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
//    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
//    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
//    NSString *text = [NSString stringWithFormat:@"已占用%0.1fG/剩余%0.1fG",([totalSpace longLongValue] - [freeSpace longLongValue])/1000.0/1000.0/1000.0,[freeSpace longLongValue]/1000.0/1000.0/1000.0];
//    NSLog(@"%@",text);





//计算缓存大小，这里路径写死了，这个和上面计算缓存同理，上面计算缓存是单独写成一个类
//-(float)getCacheSizeAtPath {
//    
//    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:cachPath]) return 0;
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachPath] objectEnumerator];//从前向后枚举器
//    NSString* fileName;
//    long long folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//        
//        NSString* fileAbsolutePath = [cachPath stringByAppendingPathComponent:fileName];
//        
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//    }
//    
//    return folderSize/(1000.0 * 1000.0);
//}
//- (long long)fileSizeAtPath:(NSString*)filePath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
//    }
//    return 0;
//}
//
////清除缓存
//- (void)clearCacheAtPath {
//    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//        }
//    }
//}




//下面这个方法用来实现登录按钮和输入框的联动，有两种方式，个人倾向第二种，如果用通知会大材小用
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//   
//      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:self.name];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:self.password];
//    
//    
//    [self.name addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
//    
//    [self.password addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
//    
//    
//    
//}
//
//-(void)change:(NSNotification *)notif
//{
//    
//    
//    if (self.name.text.length >= 6 && self.password.text.length >= 3) {
//        
//        self.login.enabled = YES;
//    } else {
//        
//        self.login.enabled = NO;
//    }
//    
//    
//    
//    
//}



#pragma mark gcd 定时器 创建及释放，下面分别写在两个方法里


//@property (nonatomic, strong) dispatch_source_t timer;
//
//{
//dispatch_queue_t queue = dispatch_get_main_queue();
//self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//
//
//dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));//什么时候开始
//uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);//间隔
//dispatch_source_set_timer(self.timer, start, interval, 0);
//dispatch_source_set_event_handler(self.timer, ^{
//    
//    //做一些事
//    
//    
//    
//});
//
//dispatch_resume(self.timer);//开始
//
//}
//
//
////停止
//{
//dispatch_cancel(self.timer);
//self.timer = nil;
//}



#pragma mark 单个删除按钮，多个删除可以看云盘

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [msgListArray removeObjectAtIndex:indexPath.row];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//    }
//    
//}


#pragma mark  创建文件夹的用法~~二级文件夹和三级文件夹
//// 获得沙盒中Documents文件夹路径
//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentsPath = [paths objectAtIndex:0];
//
//
//
//// 二级文件夹~test文件夹
//NSFileManager *fileManager = [NSFileManager defaultManager];
//NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
//[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//
//// 在test文件夹中创建三个测试文件（test1.txt/test2.txt/test3.txt），并写入数据
//NSString *test1FilePath = [testDirectory stringByAppendingPathComponent:@"test1.txt"];
//NSString *test2FilePath = [testDirectory stringByAppendingPathComponent:@"test2.txt"];
//NSString *test3FilePath = [testDirectory stringByAppendingPathComponent:@"test3.txt"];
//// 三个文件的内容
//NSString *test1Content = @"helloWorld";
//NSString *test2Content = @"helloTest2";
//NSString *test3Content = @"helloTest3";
//// 写入对应文件
//[fileManager createFileAtPath:test1FilePath contents:[test1Content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
//[fileManager createFileAtPath:test2FilePath contents:[test2Content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
//[fileManager createFileAtPath:test3FilePath contents:[test3Content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
//
////创建三级文件夹 subtest
//NSString *subtestDirectoryPath = [testDirectory stringByAppendingPathComponent:@"subtest"];
//[fileManager createDirectoryAtPath:subtestDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
//
//// 创建三个子文件
//
//[fileManager createFileAtPath:[subtestDirectoryPath stringByAppendingPathComponent:@"subtest1.txt"] contents:nil attributes:nil];
//[fileManager createFileAtPath:[subtestDirectoryPath stringByAppendingPathComponent:@"subtest2.txt"] contents:nil attributes:nil];
//[fileManager createFileAtPath:[subtestDirectoryPath stringByAppendingPathComponent:@"subtest3.txt"] contents:nil attributes:nil];
//
//
//
//NSLog(@"ddd%@",[fileManager subpathsAtPath:subtestDirectoryPath]);

#pragma mark 开发中的小技巧

/**
NSInteger count = 5;
//02代表:如果count不足2位 用0在最前面补全(2代表总输出的个数)
NSString *string = [NSString stringWithFormat:@"%02zd",count];
//输出结果是: 05
NSLog(@"%@", string);



NSInteger count = 50;
//%是一个特殊符号 如果在NSString中用到%需要如下写法
NSString *string = [NSString stringWithFormat:@"%zd%%",count];
//输出结果是: 50%
NSLog(@"%@", string);
 
 
 NSInteger count = 50;
 //"是一个特殊符号, 如果在NSString中用到"需要用\进行转义
 NSString *string = [NSString stringWithFormat:@"%zd\"",count];
 //输出结果是: 50"
 NSLog(@"%@", string);
 
 
 
 bloc里有定时器打印值的时候必须强引用他才有效
 LRWeakSelf(shop);
 shop.myBlock = ^{
 //强引用
 LRStrongSelf(shop)
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 NSLog(@"%@",shop.string);
 });
 };
 shop.myBlock();
 
 
 
5. 自定义控件里如何拿到导航控制器进行页面跳转
 如果有UITabBarController我们会这样获取导航控制器:
 
 UIViewController *viewC = [[UIViewController alloc]init];
 // 取出当前的导航控制器
 UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
 //The view controller associated with the currently selected tab item
 //当前选择的导航控制器
 UINavigationController *navC = (UINavigationController *)tabBarVc.selectedViewController;
 [navC pushViewController:viewC animated:YES];
 
 
 
 如果通过modal出来的控制器并且用UITabBarController不好使, 我们会这样获取导航控制器:
 UIViewController *viewC = [[UIViewController alloc]init];
 //获取最终的根控制器
 UIViewController *rootC = [UIApplication sharedApplication].keyWindow.rootViewController;
 //如果是modal出来的控制器,它就会通过presentedViewController拿到上一个控制器
 UINavigationController *navC = (UINavigationController *)rootC.presentedViewController;
 [navC pushViewController:viewC animated:YES];
 
 
 6.修改了leftBarButtonItem如何恢复系统侧滑返回功能
 self.interactivePopGestureRecognizer.delegate = self;
 #pragma mark - <UIGestureRecognizerDelegate>
 //实现代理方法:return YES :手势有效, NO :手势无效
 - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
 {
 //当导航控制器的子控制器个数 大于1 手势才有效
 return self.childViewControllers.count > 1;
 }
 
 
7。 等线程1和2都执行完再做些事情
 dispatch_group_t group = dispatch_group_create();
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
 //线程一
 });
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
 // 线程二
 });
 dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
 //汇总
 });
 
 
 8.录屏
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
  
 
 
 UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
 [self.view addSubview:startBtn];
 startBtn.backgroundColor = [UIColor blueColor];
 [startBtn setTitle:@"开始录制" forState:UIControlStateNormal];
 [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
 
 
 UIButton *endBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
 [self.view addSubview:endBtn];
 endBtn.backgroundColor = [UIColor blueColor];
 [endBtn setTitle:@"结束录制" forState:UIControlStateNormal];
 [endBtn addTarget:self action:@selector(end:) forControlEvents:UIControlEventTouchUpInside];
 }
 
 
 - (void)start:(UIButton *)btn {
 RPScreenRecorder *recorder = [RPScreenRecorder sharedRecorder];
 [recorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
 if (error) {
 NSLog(@"start recorder error - %@",error);
 }
 [btn setTitle:@"开始啦" forState:UIControlStateNormal];
 }];
 
 }
 
 - (void)end:(UIButton *)btn {
 RPScreenRecorder *recorder = [RPScreenRecorder sharedRecorder];
 [recorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
 
 previewViewController.previewControllerDelegate = self;
 [self presentViewController:previewViewController animated:NO completion:^{
 NSLog(@"开始播放啦");
 }];
 }];
 
 
 }
 - (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
 {
 [previewController dismissViewControllerAnimated:YES completion:nil];
 }
 
# 保存图片
 
 NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"bc.jpg"], 0.5);
 
 
 NSString *subPath = [kPathCache stringByAppendingPathComponent:@"IMG"];//二级文件
 NSString *str = @"Jack111";
 NSString *imageName = [NSString stringWithFormat:@"%@.jpg", str];
 NSString *imagePath = [subPath stringByAppendingPathComponent:imageName];
 [[NSFileManager defaultManager] createDirectoryAtPath:[imagePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
 
 BOOL hehe = [imageData writeToFile:imagePath atomically:NO];
 
 if (hehe) {
 
 NSLog(@"%@",imagePath);
 } else {
 
 NSLog(@"失败");
 }
 UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
 
 im.image = [UIImage imageWithContentsOfFile:[imagePath stringByExpandingTildeInPath]];//这里是为了获取绝对路径，因为每一次更新应用路径都会改变，这里是为了自动生成新的路径
 im.backgroundColor = [UIColor redColor];
 [self.view addSubview:im];

 
 
 
 */


/**
 *  有时候writetofile失败，就需要创建文件夹，这个在多级文件夹下回出现,也可以用上面的nsfilemanage方法
 */

//- (NSString *)getImagePath{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"IMG"];
//    NSFileManager *manager = [[NSFileManager alloc]init];
//    if (![manager fileExistsAtPath:path]) {
//        NSError *error ;
//        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
//        if (error) {
//            //            NSLog(@"creat error : %@",error.description);
//        }
//    }
//    
//    
//    
//    return path;
//}

#pragma mark 监听设备旋转旋转的角度


//[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//
//
///**
// *  添加 设备旋转 通知
// *
// *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
// *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
// *
// *  @return return value description
// */
//[[NSNotificationCenter defaultCenter] addObserver:self
//                                         selector:@selector(handleDeviceOrientationDidChange:)
//                                             name:UIDeviceOrientationDidChangeNotification
//                                           object:nil
// ];
//
//
///**
// *  销毁 设备旋转 通知
// *
// *  @return return value description
// */
//[[NSNotificationCenter defaultCenter] removeObserver:self
//                                                name:UIDeviceOrientationDidChangeNotification
//                                              object:nil
// ];
//
//
///**
// *  结束 设备旋转通知
// *
// *  @return return value description
// */
//[[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
//
//
//- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
//{
//    //1.获取 当前设备 实例
//    UIDevice *device = [UIDevice currentDevice] ;
//    
//    
//    
//    
//    /**
//     *  2.取得当前Device的方向，Device的方向类型为Integer
//     *
//     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
//     *
//     *  @param device.orientation
//     *
//     */
//    
//    switch (device.orientation) {
//        case UIDeviceOrientationFaceUp:
//            NSLog(@"屏幕朝上平躺");
//            break;
//            
//        case UIDeviceOrientationFaceDown:
//            NSLog(@"屏幕朝下平躺");
//            break;
//            
//            //系統無法判斷目前Device的方向，有可能是斜置
//        case UIDeviceOrientationUnknown:
//            NSLog(@"未知方向");
//            break;
//            
//        case UIDeviceOrientationLandscapeLeft:
//            NSLog(@"屏幕向左横置");
//            break;
//            
//        case UIDeviceOrientationLandscapeRight:
//            NSLog(@"屏幕向右橫置");
//            break;
//            
//        case UIDeviceOrientationPortrait:
//            NSLog(@"屏幕直立");
//            break;
//            
//        case UIDeviceOrientationPortraitUpsideDown:
//            NSLog(@"屏幕直立，上下顛倒");
//            break;
//            
//        default:
//            NSLog(@"无法辨识");
//            break;
//    }
//    
//}

#pragma mark  并发控制

//- (NSOperationQueue *)queue
//{
//    if (_queue == nil) {
//        _queue = [[NSOperationQueue alloc] init];
//          _queue.maxConcurrentOperationCount = 3; // 最大并发数
//    }
//    return _queue;
//}
//
//- (void)hehe:(int)num {
//    
//    
//    [self.queue waitUntilAllOperationsAreFinished];//加上这句线程就会一步一步执行，如果去掉这个设置并发数为1效果是一样的
//    
//    
//    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        
//        NSLog(@"%d",num);
//        
//        
//    }];
//    
//    
//    [self.queue addOperation:op];
//    
//}


#pragma mark 在相册选择多张图片时，按钮和label的动画效果，下面有3种方式

//self.backGroudView.transform =CGAffineTransformMakeScale(0, 0);
//[UIView animateWithDuration:0.2 animations:^{
//    self.backGroudView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//}
//                 completion:^(BOOL finished){
//                     [UIView animateWithDuration:0.1 animations:^{
//                         self.backGroudView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                     }];
//                 }];
//


//第二种实现方式
//-(void)roundAnimation:(UILabel *)label
//{
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.7;
//    
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [label.layer addAnimation:animation forKey:nil];
//}
//
//-(void)selectAnimation:(UIButton *)button
//{
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.5;
//    
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [button.layer addAnimation:animation forKey:nil];
//}
//

//第三
//placeholder.transform = CGAffineTransformMakeScale(.5, .5);
//[UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//				placeholder.transform = CGAffineTransformIdentity;
//} completion:nil];


#pragma mark 控制多张图片上传时的顺序
//dispatch_group_t group = dispatch_group_create();
//
//__block BOOL error = NO;
//
//[self.uploadImageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
//    
//    dispatch_group_enter(group);
//    [[AFFileClient sharedClient] upload:@"app/upload_file/imageList"
//                             parameters:nil
//                                  files:@{@"upload":UIImageJPEGRepresentation(image, 0.8)}
//                               complete:^(ResponseData *response) {
//                                   dispatch_group_leave(group);
//                                   if (response.success) {
//                                       NSLog(@"第%@张图片上传完成...",@(idx));
//                                   }
//                                   else {
//                                       error = YES;
//                                       NSLog(@"第%@张图片上传失败：%@",@(idx),response.message);
//                                   }
//                               }];
//}];
//
//dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//    [self doSomethingWhenAllImageUpload:error];
//});


#pragma mark kvo监听按钮是否点击，类似于反射，用来vc种tableview点击了cell此时将改变按钮的状态，此时对按钮进行监听，类似于一种反射机制

//[self.selectedBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    
//    if ([keyPath isEqualToString:@"selected"] && object == self.selectedBtn) {
//        
//        
//        NSLog(@"%@",[change objectForKey:@"new"]);
//        
//        
//        if ([[change objectForKey:@"new"] integerValue] == 1) {
//            
//            dayLabel.textColor = [UIColor whiteColor];
//        } else {
//            
//            dayLabel.textColor = COLOR(174, 143, 101, 1);
//        }
//        
//        
//    } else {
//        
//        
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        
//    }
//    
//    
//    
//    
//    
//}
//
//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    
//    if (!newSuperview) {
//        
//        
//        [self.selectedBtn removeObserver:self forKeyPath:@"selected" context:nil];
//    }
//    
//}

#pragma mark 删除数组及字典里的null，这个使用递归，第二种方法不是递归

//- (NSMutableArray *)removeNullFromArray:(NSArray *)arr
//{
//    NSMutableArray *marr = [NSMutableArray array];
//    for (int i = 0; i < arr.count; i++) {
//        NSValue *value = arr[i];
//        // 删除NSDictionary中的NSNull，再添加进数组
//        if ([value isKindOfClass:NSDictionary.class]) {
//            [marr addObject:[self removeNullFromDictionary:(NSDictionary *)value]];
//        }
//        // 删除NSArray中的NSNull，再添加进数组
//        else if ([value isKindOfClass:NSArray.class]) {
//            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
//        }
//        // 剩余的非NSNull类型的数据添加进数组
//        else if (![value isKindOfClass:NSNull.class]) {
//            [marr addObject:value];
//        }
//    }
//    return marr;
//}
//// 删除Dictionary中的NSNull
//- (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
//{
//    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
//    for (NSString *strKey in dic.allKeys) {
//        NSValue *value = dic[strKey];
//        // 删除NSDictionary中的NSNull，再保存进字典
//        if ([value isKindOfClass:NSDictionary.class]) {
//            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
//        }
//        // 删除NSArray中的NSNull，再保存进字典
//        else if ([value isKindOfClass:NSArray.class]) {
//            mdic[strKey] = [self removeNullFromArray:(NSArray *)value];
//        }
//        // 剩余的非NSNull类型的数据保存进字典
//        else if (![value isKindOfClass:NSNull.class]) {
//            mdic[strKey] = dic[strKey];
//        }
//    }
//    return mdic;
//}
//- (NSObject *)removeNullFrom:(NSObject *)object
//{
//    NSObject *objResult = nil;
//    NSMutableArray *marrSearch = nil;
//    if ([object isKindOfClass:NSNull.class]) {
//        return nil;
//    }
//    else if ([object isKindOfClass:NSArray.class]) {
//        objResult = [NSMutableArray arrayWithArray:(NSArray *)object];
//        marrSearch = [NSMutableArray arrayWithObject:objResult];
//    }
//    else if ([object isKindOfClass:NSDictionary.class]) {
//        objResult = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
//        marrSearch = [NSMutableArray arrayWithObject:objResult];
//    }
//    else {
//        return object;
//    }
//    while (marrSearch.count > 0) {
//        NSObject *header = marrSearch[0];
//        if ([header isKindOfClass:NSMutableDictionary.class]) {
//            // 遍历这个字典
//            NSMutableDictionary *mdicTemp = (NSMutableDictionary *)header;
//            for (NSString *strKey in mdicTemp.allKeys) {
//                NSObject *objTemp = mdicTemp[strKey];
//                // 将NSDictionary替换为NSMutableDictionary
//                if ([objTemp isKindOfClass:NSDictionary.class]) {
//                    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)objTemp];
//                    mdicTemp[strKey] = mdic;
//                    [marrSearch addObject:mdic];
//                }
//                // 将NSArray替换为NSMutableArray
//                else if ([objTemp isKindOfClass:NSArray.class]) {
//                    NSMutableArray *marr = [NSMutableArray arrayWithArray:(NSArray *)objTemp];
//                    mdicTemp[strKey] = marr;
//                    [marrSearch addObject:marr];
//                }
//                // 删除NSNull
//                else if ([objTemp isKindOfClass:NSNull.class]) {
//                    mdicTemp[strKey] = nil;
//                }
//            }
//        }
//        else if ([header isKindOfClass:NSMutableArray.class]) {
//            // 遍历这个数组
//            NSMutableArray *marrTemp = (NSMutableArray *)header;
//            for (int i = marrTemp.count-1; i >= 0; i--) {
//                NSObject *objTemp = marrTemp[i];
//                // 将NSDictionary替换为NSMutableDictionary
//                if ([objTemp isKindOfClass:NSDictionary.class]) {
//                    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)objTemp];
//                    [marrTemp replaceObjectAtIndex:i withObject:mdic];
//                    [marrSearch addObject:mdic];
//                }
//                // 将NSArray替换为NSMutableArray
//                else if ([objTemp isKindOfClass:NSArray.class]) {
//                    NSMutableArray *marr = [NSMutableArray arrayWithArray:(NSArray *)objTemp];
//                    [marrTemp replaceObjectAtIndex:i withObject:marr];
//                    [marrSearch addObject:marr];
//                }
//                // 删除NSNull
//                else if ([objTemp isKindOfClass:NSNull.class]) {
//                    [marrTemp removeObjectAtIndex:i];
//                }
//            }
//        }
//        else {
//            // 到这里就出错了
//        }
//        [marrSearch removeObjectAtIndex:0];
//    }
//    return objResult;
//}
//

//[[UIColor lightGrayColor] colorWithAlphaComponent:.9];



#pragma mark 改变tableview左划删除按钮的颜色

//左划删除时偏移的背景色就是tableview的背景色

//在自定义cell加上如下代码


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    [self dealDeleteButton];
//}
//- (void)dealDeleteButton{
//    for (UIView *subView in self.subviews) {
//        
//        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
//            
//            subView.backgroundColor = [UIColor blueColor];
//            
//            for (UIButton *button in subView.subviews) {
//                
//                if ([button isKindOfClass:[UIButton class]]) {
//                    
//                    button.backgroundColor = [UIColor blueColor];
//                    button.titleLabel.font = [UIFont systemFontOfSize:11.0];
//                    
//                }
//            }
//        }
//    }
//}
//左划删除的代码
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除事件
//        
//        [msgListArray removeObjectAtIndex:indexPath.row];//tableview数据源
//        
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        
//    }
//    
//    
//    
//}
//

#pragma mark  刮刮乐

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
// 
//    
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7, 50, 400, 400)];
//    label.text = @"离思五首\n元稹\n曾经沧海难为水,\n除却巫山不是云!\n取次花丛懒回顾,\n半缘修道半缘君!\n";
//    label.numberOfLines = 0;
//    label.backgroundColor = [UIColor colorWithRed:(arc4random()%173)/346.0 + 0.5 green:(arc4random()%173)/346.0 + 0.5  blue:(arc4random()%173)/346.0 + 0.5  alpha: 1];
//    label.font = [UIFont systemFontOfSize:30];
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//    
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 50, 400, 400)];
//    self.imageView.image = [UIImage imageNamed:@"bc.jpg"];
//    [self.view addSubview:self.imageView ];
//    
//}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    // 触摸任意位置
//    UITouch *touch = touches.anyObject;
//    // 触摸位置在图片上的坐标
//    CGPoint cententPoint = [touch locationInView:self.imageView];
//    // 设置清除点的大小
//    CGRect  rect = CGRectMake(cententPoint.x, cententPoint.y, 20, 20);
//    // 默认是去创建一个透明的视图
//    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
//    // 获取上下文(画板)
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    // 把imageView的layer映射到上下文中
//    [self.imageView.layer renderInContext:ref];
//    // 清除划过的区域
//    CGContextClearRect(ref, rect);
//    // 获取图片
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    // 结束图片的画板, (意味着图片在上下文中消失)
//    UIGraphicsEndImageContext();
//    self.imageView.image = image;
//    
//}


#pragma mark 归档

//一次只能保存一个对象
//   // 归档
//    NSArray* names=@[@"高富帅",@"李志杰",@"我",@"小纸箱"];//准备归档对象
//
//
//    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    //2、添加储存的文件名
//    NSString *path  = [docPath stringByAppendingPathComponent:@"data.archiver"];
//    //3、将一个对象保存到文件中
//    BOOL flag = [NSKeyedArchiver archiveRootObject:names toFile:path];
//
//    if (flag) {
//        NSLog(@"归档成功");
//
//
//
//        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *path=[docPath stringByAppendingPathComponent:@"data.archiver"];
//
//        //2.从文件中读取对象
//      NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//
//
//    NSLog(@"%@",arr);
//    }


//    //一次保存多个对象
//    CGPoint point = CGPointMake(1.0, 2.0);
//    NSString *origin = @"坐标原点";
//    NSInteger value = 10;
//    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [docPath stringByAppendingPathComponent:@"multi.archiver"];
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    //对多个对象进行归档
//    [archvier encodeCGPoint:point forKey:@"kPoint"];
//    [archvier encodeObject: origin forKey:@"kOrigin"];
//    [archvier encodeInteger:value forKey:@"kValue"];
//    [archvier finishEncoding];
//    [data writeToFile:path atomically:YES];
//
//
//
//
//    NSMutableData *dataR = [[NSMutableData alloc] initWithContentsOfFile:path];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataR];
//    CGPoint pointR = [unarchiver decodeCGPointForKey:@"kPoint"];
//    NSString *infoR = [unarchiver decodeObjectForKey:@"kOrigin"];
//    NSInteger valueR = [unarchiver decodeIntegerForKey:@"kValue"];
//    [unarchiver finishDecoding];
//    NSLog(@"%f,%f,%@,%ld",pointR.x,pointR.y,infoR,valueR);



//保存自定义对象,这个自定义对象必须遵循并实现NSCoding协议，参考笔记本nsuserdefult方法

//1.创建对象
//    YYPerson *person = [[YYPerson alloc] init];
//    person.name=@"蜗牛";
//    person.age=23;
//    person.height=1.83;
//
//    //2.获取文件路径
//    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *path=[docPath stringByAppendingPathComponent:@"person.archiver"];
//    NSLog(@"path=%@",path);
//
//    //3.将自定义的对象保存到文件中，调用NSKeyedArchiver的工厂方法 archiveRootObject: toFile: 方法
//    [NSKeyedArchiver archiveRootObject:p toFile:path];


//解档
//    //1.获取文件路径
//    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *path=[docPath stringByAppendingPathComponent:@"person.archiver"];
//    NSLog(@"path=%@",path);
//
//    //2.从文件中读取对象，解档对象就调用NSKeyedUnarchiver的一个工厂方法 unarchiveObjectWithFile: 即可。
//    YYPerson * person = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    if (person) {
//        NSLog(@"%@,%d,%.1f", person.name, person.age, person.height);
//    }

#pragma mark  判断当前ViewController是push还是present的方式显示的

//也可以通过是否执行viewdidload判断，如果push则会执行viewdidload

//NSArray *viewcontrollers=self.navigationController.viewControllers;
//
//if (viewcontrollers.count > 1)
//{
//    if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self)
//    {
//        //push方式
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//else
//{
//    //present方式
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


#pragma mark iOS在当前屏幕获取第一响应
//UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
//UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];

#pragma mark 取消UICollectionView的隐式动画
//方法一
//[UIView performWithoutAnimation:^{
//    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
//}];
//
////方法二
//[UIView animateWithDuration:0 animations:^{
//    [collectionView performBatchUpdates:^{
//        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
//    } completion:nil];
//}];
//
////方法三
//[UIView setAnimationsEnabled:NO];
//[self.trackPanel performBatchUpdates:^{
//    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
//} completion:^(BOOL finished) {
//    [UIView setAnimationsEnabled:YES];
//}];



#pragma mark 计算字符串字符长度，一个汉字算两个字符
//方法一：
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
        
    }
    return strlength;
}

//方法二：
-(NSUInteger) unicodeLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}


#pragma mark 给UIView设置图片
//UIImage *image = [UIImage imageNamed:@"image"];
//self.MYView.layer.contents = (__bridge id _Nullable)(image.CGImage);
//self.MYView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);


#pragma mark 防止scrollView手势覆盖侧滑手势
//[scrollView.panGestureRecognizerrequireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];

#pragma mark 获取手机安装的应用
//Class c =NSClassFromString(@"LSApplicationWorkspace");
//id s = [(id)c performSelector:NSSelectorFromString(@"defaultWorkspace")];
//NSArray *array = [s performSelector:NSSelectorFromString(@"allInstalledApplications")];
//for (id item in array)
//{
//    NSLog(@"%@",[item performSelector:NSSelectorFromString(@"applicationIdentifier")]);
//    //NSLog(@"%@",[item performSelector:NSSelectorFromString(@"bundleIdentifier")]);
//    NSLog(@"%@",[item performSelector:NSSelectorFromString(@"bundleVersion")]);
//    NSLog(@"%@",[item performSelector:NSSelectorFromString(@"shortVersionString")]);
//}


#pragma mark navigationBar变为纯透明,tabBar同理
//[self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
////去掉导航栏底部的黑线
//self.navigationBar.shadowImage = [UIImage new];
//
////第二种方法
//[[self.navigationBar subviews] objectAtIndex:0].alpha = 0;


//[self.tabBar setBackgroundImage:[UIImage new]];
//self.tabBar.shadowImage = [UIImage new];

#pragma mark wkwebview截屏失败


- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame
{
    
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        for(UIView *subview in theView.subviews)
        {
            [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        CGContextSaveGState(context);
        [theView.layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *CGImg = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return CGImg;
}

#pragma mark 系统返回手势和scrollview冲突，这个方法和下面的不一样，这里是系统自带的返回手势，下面抽屉效果都是自定义的返回手势



//1
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//    
//}


//2

//UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = self.navigationController.screenEdgePanGestureRecognizer;
//[mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];

//3
// [_smallScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//

//4.在viewDidAppear里边添加此段代码即可
//NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
//// 当是侧滑手势的时候设置scrollview需要此手势失效即可
//for (UIGestureRecognizer *gesture in gestureArray) {
//    if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//        [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
//        break;
//    }
//}

#pragma mark  这里是自定义scrollview,解决和系统返回手势冲突问题

//在自定义的uiscroview里添加方法。
//
//左边侧滑：
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
//    CGPoint location = [gestureRecognizer locationInView:self];
//    
//    NSLog(@"velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
//    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<60) {
//        return NO;
//    }
//    return YES;
//}
//
//
//
//
//
//右边侧滑：
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
//    CGPoint location = [gestureRecognizer locationInView:self];
//    
//    NSLog(@"velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
//    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.width-60) {
//        return NO;
//    }
//    return YES;
//}


//这也要写在自定义scrollview里，CustomScrollView，遵守<UIGestureRecognizerDelegate>协议，然后在实现文件中写如下代码：
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    // 首先判断otherGestureRecognizer是不是系统pop手势
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
//        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
//            return YES;
//        }
//    }
//    
//    return NO;
//}

#pragma mark 抽屉效果有时候滑动范围太大，不像系统自带的手势那样精确，解决方法如下

//下面这个方法是抽屉效果提供给user是否可以打开侧滑，然后在这里加上系统侧滑是否打开即可，亲测有效
//- (void)setEnableSwipeGesture:(BOOL)markEnableSwipeGesture
//{
//    
//    _enableSwipeGesture = markEnableSwipeGesture;
//    
//    
//    self.interactivePopGestureRecognizer.delegate = (id)self;//jack 标记
//    if (_enableSwipeGesture)
//    {
//        [self.view addGestureRecognizer:self.panRecognizer];
//        self.interactivePopGestureRecognizer.enabled = NO;//jack 标记这里是为了正在某些固定的界面让pan手势失效，而响应系统自带的侧滑
//    }
//    else
//    {
//        [self.view removeGestureRecognizer:self.panRecognizer];
//        
//        self.interactivePopGestureRecognizer.enabled = YES;//jack 标记
//        
//    }
//}



#pragma mark 抽屉效果和tableview滑动删除冲突，或者和竖直滑动的scrollView冲突，这个代理写在抽屉效果内部的pan手势中，因为这里的手势是自定义的

//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        CGPoint pointInView = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
//        
//        
//        
//        
//        
//        NSInteger currentX = [self horizontalLocation];
//        
//        if (pointInView.x < 0 && currentX == 0) {
//            NSLog(@"左划手势失效");
//            
//            return NO;
//        }
//        
//        
//        
//        
//        
//        
//        
//        
//    }
//    
//    return YES;
//}
//- (CGFloat)horizontalLocation
//{
//    CGRect rect = self.view.frame;
//    UIInterfaceOrientation orientation = self.interfaceOrientation;
//    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//    {
//        return rect.origin.x;
//    }
//    else
//    {
//        if (UIInterfaceOrientationIsLandscape(orientation))
//        {
//            return (orientation == UIInterfaceOrientationLandscapeRight)
//            ? rect.origin.y
//            : rect.origin.y*-1;
//        }
//        else
//        {
//            return (orientation == UIInterfaceOrientationPortrait)
//            ? rect.origin.x
//            : rect.origin.x*-1;
//        }
//    }
//}


#pragma mark 设置滑动手势范围，这样自定义的手势就可以跟系统侧滑手势效果一样
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    CGPoint location = [gestureRecognizer locationInView:self.view];
//    CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
//    BOOL ret = (0 < offSet.x && location.x <= 40);
//       return ret;
//    
//    
//    
//    
//
//}


#pragma mark 抽屉效果和可以左右滑动的scrollview冲突，这个方法可以和上面同时使用，但是这里必须进行区别对待，也就是某一个vc中可以策划手势生效，如果不区别则所有vc的scrollview都会出现滚动的现象，这里切记

///- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//    
//    if ([[otherGestureRecognizer view] isMemberOfClass:[UIScrollView class]]) {
//        
//        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
//        
//        
//        for (UIView* next = [scrollView superview]; next; next = next.superview) {
//            UIResponder *nextResponder = [next nextResponder];
//            if ([nextResponder isKindOfClass:[UIViewController class]]) {
//                
//                
//                
//                if (scrollView.contentOffset.x <= 0 && [NSStringFromClass([(UIViewController *)nextResponder class]) isEqualToString:@"ShoppingImageViewController"]) {//区别地图界面
//                    
//                    
//                    NSLog(@"ssss");
//                    
//                    return YES;
//                    
//                    
//                    
//                }
//                
//            }
//            
//            
//        }
//        
//        
//        
//        
//        
//        
//    }
//    
//    return NO;
//    
//    
//    
//    
//}


#pragma mark 按钮设置图片和标题

//UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
//mapButton.frame = CGRectMake(KSCREENWIDTH/2,0, KSCREENWIDTH/2, 50);
//mapButton.backgroundColor = [UIColor clearColor];
//mapButton.tag = 101;
//mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);//表示图片和标题的间距为7，且图片再左边
//mapButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
//[mapButton setImage:[UIImage imageNamed:@"icon_eye"] forState:UIControlStateNormal];
//[mapButton setTitle:@"999" forState:UIControlStateNormal];
//[mapButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
//
//mapButton.titleLabel.font = text14Font;
//// [mapButton addTarget:delegate action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

#pragma mark 导航栏返回按钮设置
//去掉导航栏黑线
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}
//
////视图将要消失时取消隐藏
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}

// A使用pushViewController切换到B时，navigation controller按照以下3条顺序更改导航栏的左侧按钮：
//
//1、如果B视图有一个自定义的左侧按钮（leftBarButtonItem），则会显示这个自定义按钮；
//
//2、如果B没有自定义按钮，但是A视图的backBarButtonItem属性有自定义项，则显示这个自定义项；
//
//3、如果前2条都没有，则默认显示一个后退按钮，后退按钮的标题是A视图的标题；


//设置导航栏右边标题
//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick:)];
//



//设置导航栏标题为图片，也可以用自定义view
//UIImage *image = [[UIImage imageNamed:@"icon_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//
//
//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];


//改变b导航栏字体颜色，必须在a设置
//self.navigationController.navigationBar.tintColor = defaultColor;

//设置导航栏title颜色。必须在a设置
//self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:defaultColor,NSFontAttributeName:text14Font};

//导航栏自定义view
//UIButton *_rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, 0, 60, 30)];
//[_rightBtn setTitleColor:defaultColor forState:UIControlStateNormal];
//[_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
//[_rightBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];


#pragma mark toolbar使用
//toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44)];
//toolbar.tintColor = [UIColor whiteColor];
//toolbar.barStyle = UIBarStyleBlack;
//[self.view addSubview:toolbar];
//UIBarButtonItem *leftFix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//UIBarButtonItem *rightFix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//preview = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(preview)];
//UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//selectNum = [[UIBarButtonItem alloc] initWithTitle:@"0/9" style:UIBarButtonItemStylePlain target:nil action:nil];
//UIBarButtonItem *fix2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(choiceDone)];
//[toolbar setItems:@[leftFix, preview, fix, selectNum, fix2, done, rightFix]];
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCount:) name:@"selectdPhotos" object:nil];
//selectNum.title = [NSString stringWithFormat:@"%ld/9", (unsigned long)ASSETHELPER.selectdPhotos.count];

#pragma mark 代理反射机制，今天发现代理不仅可以a到b，也可以b到a，这是才发现的

//。h文件
//@protocol CustomAlertDelegate <NSObject>
//
//@optional
//
//- (void)clickCustomAlertButton:(UIButton *)button;
//
//- (NSInteger)pringtheh;
//
//@end


//。m文件中

//if ([self.delegate respondsToSelector:@selector(clickCustomAlertButton:)]) {
//    
//    [self.delegate clickCustomAlertButton:btn];
//    
//    
//    NSLog(@"%ld",[self.delegate pringtheh]);//相当于反射的感觉
//    
//}



#pragma mark 限制scrollview滚动范围，这里限制的是任意范围，而不是简单的从0开始

//下面是简单声明一个scrollview，并设置他滚动范围为3倍的自身，这里我会限制在特定条件下，他的滚动范围为（KSCREENWIDTH —— 2 * KSCREENWIDTH），当然也可以设置任意数据


//no.1
//self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width+10, KSCREENHEIGHT)];
//self.mainScrollView.contentSize = CGSizeMake(KSCREENWIDTH * 3 + 10 * 3,KSCREENHEIGHT);
//self.mainScrollView.bounces = YES;
//self.mainScrollView.pagingEnabled = YES;
//self.mainScrollView.showsHorizontalScrollIndicator = NO;
//self.mainScrollView.showsVerticalScrollIndicator = NO;


//no.2,下面就是特定条件滚动范围，简单的就是说和contentInset结合

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (scrollView == _mainScrollView) {
//        
//        
//
//        if (_curPage == self.imageArr.count - 1 ) {
//            
//            
//            _mainScrollView.contentInset = UIEdgeInsetsMake(0, -(KSCREENWIDTH + 10), 0, 0);
//            
//        } else if ( _curPage == 0) {
//            
//            _mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, -(KSCREENWIDTH + 10));
//            
//        } else {
//            
//            _mainScrollView.contentInset = UIEdgeInsetsZero;
//        }
//    }
//


#pragma mark 获取点击cell的位置，在自定义cell内部重写方法
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch* touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    
//    NSLog(@"%@",NSStringFromCGPoint(point));

// [super touchesBegan:touches withEvent:event];
//    
//}

#pragma mark pan手势代理swipe方向

//-(void)pan:(UIPanGestureRecognizer*)sender
//{
//    typedefNS_ENUM(NSUInteger,UIPanGestureRecognizerDirection){
//        UIPanGestureRecognizerDirectionUndefined,
//        UIPanGestureRecognizerDirectionUp,
//        UIPanGestureRecognizerDirectionDown,
//        UIPanGestureRecognizerDirectionLeft,
//        UIPanGestureRecognizerDirectionRight
//    };
//    staticUIPanGestureRecognizerDirectiondirection=UIPanGestureRecognizerDirectionUndefined;
//    switch(sender.state){
//        caseUIGestureRecognizerStateBegan:{
//            if(direction==UIPanGestureRecognizerDirectionUndefined){
//                CGPointvelocity=[sendervelocityInView:recognizer.view];
//                BOOLisVerticalGesture=fabs(velocity.y)>fabs(velocity.x);
//                if(isVerticalGesture){
//                    if(velocity.y>0){
//                        direction=UIPanGestureRecognizerDirectionDown;
//                    }else{
//                        direction=UIPanGestureRecognizerDirectionUp;
//                    }
//                }
//                else{
//                    if(velocity.x>0){
//                        direction=UIPanGestureRecognizerDirectionRight;
//                    }else{
//                        direction=UIPanGestureRecognizerDirectionLeft;
//                    }
//                }
//            }
//            break;
//        }
//        caseUIGestureRecognizerStateChanged:{
//            switch(direction){
//                caseUIPanGestureRecognizerDirectionUp:{
//                    [selfhandleUpwardsGesture:sender];
//                    break;  
//                }  
//                caseUIPanGestureRecognizerDirectionDown:{  
//                    [selfhandleDownwardsGesture:sender];  
//                    break;  
//                }  
//                caseUIPanGestureRecognizerDirectionLeft:{  
//                    [selfhandleLeftGesture:sender];  
//                    break;  
//                }  
//                caseUIPanGestureRecognizerDirectionRight:{  
//                    [selfhandleRightGesture:sender];  
//                    break;  
//                }  
//                default:{  
//                    break;  
//                }  
//            }  
//            break;  
//        }  
//        caseUIGestureRecognizerStateEnded:{  
//            direction=UIPanGestureRecognizerDirectionUndefined;  
//            break;  
//        }  
//        default:  
//            break;  
//    }  
//}


#pragma mark pan手势方向

//- (void)addTapGestureWithView:(UIView *)view
//{
//    
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
//                                          initWithTarget:self action:@selector(handleSwipe:)];
//    [self.view addGestureRecognizer:recognizer];
//    [recognizer release];
//}
//
///**
// *  平移手势响应事件
// *
// *  @param swipe swipe description
// */
//- (void)handleSwipe:(UIPanGestureRecognizer *)swipe
//{
//    
//    if (swipe.state == UIGestureRecognizerStateChanged) {
//        [self commitTranslation:[swipe translationInView:self.view]];
//    }
//}
//
//
///**
// *   判断手势方向
// *
// *  @param translation translation description
// */
//- (void)commitTranslation:(CGPoint)translation
//{
//    
//    CGFloat absX = fabs(translation.x);
//    CGFloat absY = fabs(translation.y);
//    
//    // 设置滑动有效距离
//    if (MAX(absX, absY) < 10)
//        return;
//    
//    
//    if (absX > absY ) {
//        
//        if (translation.x<0) {
//            
//            //向左滑动
//        }else{
//            
//            //向右滑动
//        }
//        
//    } else if (absY > absX) {
//        if (translation.y<0) {
//            
//            //向上滑动
//        }else{
//            
//            //向下滑动
//        }
//    }
//    
//    
//}

//translationInView： 该方法返回在横坐标上、纵坐标上拖动了多少像素
//velocityInView：在指定坐标系统中pan gesture拖动的速度


#pragma mark 比较字符串

//这里可以看到即使带数字的字符串也可以直接比较
//NSMutableArray *mArray = [NSMutableArray arrayWithArray:@[@"a1", @"a2", @"a22", @"a11", @"a21", @"a10", @"a23", @"a33", @"a30", @"a31", @"a32"]];
//NSArray *sorArray = [mArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
//    
//    return [obj1 localizedStandardCompare:obj2];
//}];
//
//
//
//NSLog(@"%@",sorArray);


#pragma mark 多图片上传

+(NSString *)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params dicImages:(NSMutableDictionary *) dicImages{
    NSString * res;
    
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image;//=[params objectForKey:@"pic"];
    //得到图片的data
    //NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //if(![key isEqualToString:@"pic"]) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //[body appendString:@"Content-Transfer-Encoding: 8bit"];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        //}
    }
    ////添加分界线，换行
    //[body appendFormat:@"%@\r\n",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //循环加入上传图片
    keys = [dicImages allKeys];
    for(int i = 0; i< [keys count] ; i++){
        //要上传的图片
        image = [dicImages objectForKey:[keys objectAtIndex:i ]];
        //得到图片的data
        NSData* data =  UIImageJPEGRepresentation(image, 0.0);
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        //此处循环添加图片文件
        //添加图片信息字段
        //声明pic字段，文件名为boris.png
        //[body appendFormat:[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"File\"; filename=\"%@\"\r\n", [keys objectAtIndex:i]]];
        
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"File%d\"; filename=\"%@.jpg\"\r\n", i, [keys objectAtIndex:i]];
        //声明上传文件的格式
        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
        
        NSLog(@"上传的图片：%d  %@", i, [keys objectAtIndex:i]);
        
        //将body字符串转化为UTF8格式的二进制
        //[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //设置接受response的data
    NSData *mResponseData;
    NSError *err = nil;
    mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
    if(mResponseData == nil){
        NSLog(@"err code : %@", [err localizedDescription]);
    }
    res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
    /*
     if (conn) {
     mResponseData = [NSMutableData data];
     mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
     
     if(mResponseData == nil){
     NSLog(@"err code : %@", [err localizedDescription]);
     }
     res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
     }else{
     res = [[NSString alloc] init];
     }*/
    NSLog(@"服务器返回：%@", res);
    return res;
}


#pragma mark app上传蒲公英不能下载或者下载闪退

//1。是因为同一个证书不能再不同设备上使用的原因，解决方法，制作证书的人吧发布证书导出p12文件，放到其他电脑上双击即可，然后看自己钥匙串下我的证书里是否有发布证书，没有则从官网下载


#pragma mark 电话号码类型判断
///**
// * 手机号码
// * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,186,183
// * 联通：130,131,132,152,155,156,185,186
// * 电信：133,1349,153,180,189,177
// */
//NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|8[0-9]|77)\\d{8}$";
//
//
///**
// 10         * 中国移动：China Mobile
// 11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
// 12         */
//NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//
//
///**
// 15         * 中国联通：China Unicom
// 16         * 130,131,132,152,155,156,185,186
// 17         */
//NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//
//
///**
// 20         * 中国电信：China Telecom
// 21         * 133,1349,153,180,189,177
// 22         */
//
//NSString * CT = @"^1(349|(33|53|8[09]|77)\\d)\\d{7}$";
//
//NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
//
//
//有新的自己添加上就行了


#pragma mark 计算文字高度，效果等同于[[UILabel new] sizeToFit]

//这里一定要让label的宽度和下面输入的相等，只有这样label才能居顶对其，
////获取字符串高度
- (CGFloat)getStringHeightWith:(NSString*)tempStr width:(CGFloat)tempWidth font:(UIFont*)tempFont {
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 4.f;    //行间距
    paragraphStyle.maximumLineHeight = 20.f;    //每行的最大高度
    paragraphStyle.minimumLineHeight = 16.f;    //每行的最小高度
    paragraphStyle.alignment = NSTextAlignmentJustified;

    CGRect rect = [tempStr boundingRectWithSize:CGSizeMake(tempWidth, 0)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                     attributes:@{NSFontAttributeName:tempFont,NSParagraphStyleAttributeName:paragraphStyle}
                                        context:nil];
    //文字的高度
    float tempHeight = rect.size.height;
    
    return tempHeight;
}


//NO。2这个方法和上面一样，切记设置label的宽度要等于下面的size1.width，否则label不会居顶对齐
//+ (CGFloat)getStringHeightWith:(NSString*)tempStr {
//    
//    //    UIFont *font = text14Font;
//    CGSize size1 = [Tools getLabelSize:[UIFont systemFontOfSize:14] withText:@"深圳市罗湖区宝安南路啊呵呵洗" withWidth:200];
//    CGRect rect = [tempStr boundingRectWithSize:CGSizeMake(size.width, 0)
//                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
//                                     attributes:@{NSFontAttributeName:font}
//                                        context:nil];
//    
//    return rect.size.height;
//}
@end
