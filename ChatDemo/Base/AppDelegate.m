//
//  AppDelegate.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/20.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarVC.h"
#import "LoginVC.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()<EMClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //****环信
    //初始化SDK
    [EMClientManage initSDK];
    //自动登录回调监听，判断是否自动登录和是否被挤出
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //初始化EaseUI
    [EMClientManage initEaseUIWithApplication:application options:launchOptions];
    //环信自动登录
    BOOL isLogin = [EMClientManage isAutoLogin];
    if (!isLogin)  {
        self.window.rootViewController = [[LoginVC alloc]init];
        return YES;
    }
    GCD_GLOBAL_QUEUE_ASYNC(^{
        //网络检测
        [Network startMonitoringNetwork];
        BuglyConfig *config = [[BuglyConfig alloc]init];
        config.blockMonitorEnable = YES;
        config.blockMonitorTimeout = 10;
        [Bugly startWithAppId:BuglyKey config:config];
    });
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = whiteColor;
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[TabBarVC alloc]init];
    return YES;
}

//自动登录完成时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)error{
    DLog(@"发生自动登录");
}
//当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice{
    self.window.rootViewController = [[LoginVC alloc]init];
    [MBPManage showMessage:WIN message:@"当前登录账号已在其它设备登录"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    DLog(@"进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    DLog(@"进入前台");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
