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


//下面这个方法获取当前应用所占的存储空间
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
@end
