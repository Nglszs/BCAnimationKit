//
//  AppDelegate.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/3.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RealReachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    
    //监听网络状态
    [GLobalRealReachability  startNotifier];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    
    
   // NSLog(@"%@",[self getAnyCharStringWitn:32])
    
        return YES;
}

//获取随机字符串，可用来作为异步登录判断，也可用devicetoken
- (NSString *)getAnyCharStringWitn:(int)tempLength {
    NSString *tempStr = @"abcdefABCDEF0123456789abcdefABCDEF0123456789abcdefABCDEF0123456789";
    NSString *kRandomAlphabet = [NSString stringWithFormat:@"%@",tempStr];
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:tempLength];
    for (int i = 0; i<tempLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
 
    
    return randomString;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
