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
#import <Bugtags/Bugtags.h>
#import "ChatVC.h"

@interface AppDelegate ()<EMClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingUserSteps = YES; // 具体可设置的属性请查看 Bugtags.h
    options.trackingCrashes = YES;
    options.trackingNetwork = YES;
    NSString *appkey;
#ifdef DEBUG
    appkey = @"da1f1874589eb34e9bf79bfb7ddd9ff7";
#else
    appkey = @"0f36f6c3acd21cbc0fb8d185d796ff24";
#endif
    [Bugtags startWithAppKey:appkey invocationEvent:BTGInvocationEventBubble options:options];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = whiteColor;
    [self.window makeKeyAndVisible];
    //注册本地通知
    [self setupLocalNotification:launchOptions];
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
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *vc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.window.rootViewController = vc;
        return YES;
    }
    GCD_GLOBAL_QUEUE_ASYNC(^{
        //网络检测
        [Network startMonitoringNetwork];
    });
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"TabBarVC"];
    self.window.rootViewController = vc;
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

//iOS10以前本地通知点击处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    DLog(@"%@",notification.userInfo);
    if([notification.userInfo[@"title"] isEqualToString:@"消息通知"]){
        if (![[QuickTools getCurrentVC]isKindOfClass:[ChatVC class]]) {
            UINavigationController *nav = [QuickTools getCurrentNav];
            EMConversationType type;
            if ([notification.userInfo[@"type"]isEqualToString:@"Chat"]){
                type = EMConversationTypeChat;
            }else {
                type = EMConversationTypeGroupChat;
            }
            ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:notification.userInfo[@"hxid"] conversationType:type];
            vc.title = notification.userInfo[@"hxid"];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }
    }
    DLog(@"收到本地通知");
}
//远端推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}
//本地通知注册
-(void)setupLocalNotification:(NSDictionary *)launchOptions{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取用户是否同意开启通知
                DLog(@"request authorization successed!");
            }
        }];
    } else {
        // Fallback on earlier versions
        //8.0
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    
}

- (void)jumpToControllerWithLocationNotification:(UILocalNotification *)notification{
    //如果APP在前台,就不用走通知的方法了
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    //获取userInfo
    NSDictionary *userInfo = notification.userInfo;
    DLog(@"%@",userInfo);
}

@end
