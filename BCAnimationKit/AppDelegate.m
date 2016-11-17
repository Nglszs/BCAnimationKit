//
//  AppDelegate.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/3.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Bugtags/Bugtags.h>
#import <objc/runtime.h>
#import "NetWorkFlow.h"
#import "SPUncaughtExceptionHandler.h"

#import <sys/sysctl.h>
#import <mach/mach.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;
    [Bugtags startWithAppKey:@"2f2c238e660e1123a0c9275154a9d405" invocationEvent:BTGInvocationEventNone options:options];
    
    
       
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
#if defined(DEBUG)||defined(_DEBUG)
   
#endif
    
   //    dismpatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self test];//这个也可以用下面的接收推送之后来代替
//    });
   
    
    
    //下面方法会测试当前app的网速
//    [[NetWorkFlow new] startNetworkFlow];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"RE" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        
//        NSString *dic = note.object;
//        
//        NSLog(@"heh%@",dic);
//        
//    }];

   //获取当前内存使用情况
    
//    [NSTimer scheduledTimerWithTimeInterval:1 block:^{
//        
//        NSLog(@"%lfM",[self usedMemory]);
//        
//    } repeats:YES];
    
    
    //闪退钱会弹出窗,这种不错
   // InstallUncaughtExceptionHandler();
    
       return YES;
    
    
}







- (void)test {//runtime 跳转到任意界面

    // 这个规则肯定事先跟服务端沟通好，跳转对应的界面需要对应的参数
    NSDictionary *userInfo = @{
                               @"class": @"NavbarGradientViewController",
                               @"property": @{
                                       @"isGradient": @"0",
                                      
                                       }
                               };
    
    [self push:userInfo];


}

- (void)push:(NSDictionary *)params
{
    // 类名
    NSString *class =[NSString stringWithFormat:@"%@", params[@"class"]];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    
    NSDictionary *propertys = params[@"property"];
    [propertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 检测这个对象是否存在该属性
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            // 利用kvc赋值
            [instance setValue:obj forKey:key];
        }
    }];
    
    
 
    UINavigationController *pushClassStance = (UINavigationController *)self.window.rootViewController;
    // 跳转到对应的控制器
    [pushClassStance pushViewController:instance animated:YES];
}
/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}
#pragma mark 接收推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 这个规则肯定事先跟服务端沟通好，跳转对应的界面需要对应的参数
    //NSDictionary *userInfo = @{
    //                           @"class": @"HSFeedsViewController",
    //                           @"property": @{
    //                                        @"ID": @"123",
    //                                        @"type": @"12"
    //                                   }
    //                           };
    
    [self push:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    //这里收集了几种后台运行的方法，但是有一些事无法通过审核的，慎用

    //NO.1 利用block
    //[self runBackgroundMode1];
    
}

- (void)runBackgroundMode1 {
    
    //此模式不需要设置plist，可以直接使用，只可以运行10分钟？这个我没测试过，这样就可以后台运行定时器了
    UIApplication *app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });


}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    
    NSLog(@"这里当程序被上滑退出时，会执行");
    
}
//获取随机字符串，可用来作为异步登录判断，也可用devicetoken,将这些保存在keychain里即可
- (NSString *)getAnyCharStringWitn:(int)tempLength {
    NSString *tempStr = @"abcdefABCDEF0123456789abcdefABCDEF0123456789abcdefABCDEF0123456789";
    NSString *kRandomAlphabet = [NSString stringWithFormat:@"%@",tempStr];
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:tempLength];
    for (int i = 0; i<tempLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    
    
    return randomString;
}

#pragma mark 当前内存使用情况

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1000.0) / 1000.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1000.0 / 1000.0;
}

@end
