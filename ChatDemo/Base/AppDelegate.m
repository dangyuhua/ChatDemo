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
#import "ChatVC.h"

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

//本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    DLog(@"%@",notification.userInfo);
    if([notification.userInfo[@"title"] isEqualToString:@"消息通知"]){
        if (![[QuickCreate getCurrentVC]isKindOfClass:[ChatVC class]]) {
            UINavigationController *nav = [QuickCreate getCurrentNav];
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
        
        //当程序被杀死的情况下,如何接收到通知并执行事情--ios10.0之后废弃,需要用10.0之前版本测试
        UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        if (notification) {
            NSLog(@"localNo = %@",notification.userInfo);//NSLog不会再打印
            [self jumpToControllerWithLocationNotification:notification];
        }
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
