//
//  LocalNotificationManage.m
//  demo
//
//  Created by 党玉华 on 2018/8/31.
//  Copyright © 2018年 Person. All rights reserved.
//

#import "LocalNotificationManage.h"

@implementation LocalNotificationManage

- (void)addlocalNotificationWithTitle:(NSString *)title describe:(NSString *)describe userInfo:(NSDictionary *)userInfo{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
        content.userInfo = userInfo;
        content.body = [NSString localizedUserNotificationStringForKey:describe arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        
        //    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:alertTime repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"dangyuhuaDEMO" content:content trigger:nil];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            
        }];
    } else {
        // Fallback on earlier versions
    }
}

/**
 iOS 10以前版本添加本地通知
 */
- (void)addLocalNotificationForOldVersionWithTitle:(NSString *)title describe:(NSString *)describe {
    
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置调用时间
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];//通知触发的时间，10s以后
    notification.repeatInterval = 1;//通知重复次数
    notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    //设置通知属性
    if (@available(iOS 8.2, *)) {
        notification.alertTitle = title;
    } else {
        // Fallback on earlier versions
    }
    notification.alertBody = describe; //通知主体
    notification.applicationIconBadgeNumber += 1;//应用程序图标右上角显示的消息数
    notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName = UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    //设置用户信息
    notification.userInfo = @{@"id": @1, @"user": @"cloudox"};//绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        DLog(@"iOS10 前台收到远程通知:%@", body);
        
    } else {
        // 判断为本地通知
        DLog(@"%@/n%@",userInfo,body);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

@end
