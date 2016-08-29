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



//计算缓存大小，这里路径写死了
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
 
 */
@end
