//
//  LocalNotificationManage.h
//  demo
//
//  Created by 党玉华 on 2018/8/31.
//  Copyright © 2018年 Person. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface LocalNotificationManage : NSObject<UNUserNotificationCenterDelegate>

- (void)addlocalNotificationWithTitle:(NSString *)title describe:(NSString *)describe userInfo:(NSDictionary *)userInfo;

- (void)addLocalNotificationForOldVersionWithTitle:(NSString *)title describe:(NSString *)describe;

@end
