//
//  Macros.h
//  Shopping
//
//  Created by 党玉华 on 2018/6/18.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//高效率的NSLog
#ifdef DEBUG
#define DLog(...) NSLog(@"\n%s \n⚠️第%d行⚠️ \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

#define BuglyKey @"9455e36408"
#define EMOPTIONKey @"1196180721228652#chatdemo"

#define RefreshEMClient @"RefreshEMClient"

//获取当前版本号
#define BUNDLE_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//获取当前版本的biuld
#define BIULD_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//获取当前设备的UDID
#define DIV_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//GCD
//GCD - 延迟执行
#define GCD_AFTER(time,afterBlock) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), afterBlock)
//GCD - 一次性执行
#define GCD_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock)
//GCD - 异步主线程
#define GCD_MAIN_QUEUE_ASYNC(mainBlock) dispatch_async(dispatch_get_main_queue(), mainBlock)
//GCD - 异步子线程
#define GCD_GLOBAL_QUEUE_ASYNC(globalBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalBlock);


/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
//view宽度
#define ViewW self.frame.size.width
//view高度
#define ViewH self.bounds.size.height
//获取window
#define WIN [UIApplication sharedApplication].delegate.window

#define uDefaults [NSUserDefaults standardUserDefaults]

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//CGRectMake
#define Frame(x,y,w,h) CGRectMake(x, y, w, h)
//CGSizeMake
#define Size(w,h) CGSizeMake(w, h)
//UIEdgeInsetsMake
#define Edge(top,left,bottom,right)  UIEdgeInsetsMake(top, left, bottom, right)
//一像素
#define oneLine 1/[UIScreen mainScreen].scale
//获取通知中心
#define NotificationCenter [NSNotificationCenter defaultCenter]
//一像素
#define OnePixel 1/[UIScreen mainScreen].scale
//状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//灵活view高度
#define ViewHeight ScreenH-kStatusBarHeight-kNaviBarHeight-kTabBarHeight

//Nav高度
#define kNaviBarHeight 44
//导航栏高度
#define kTopBarHeight (kStatusBarHeight+kNaviBarHeight)
//标签栏高度
#define kBottomBarHeight 49
//iphoneX标签栏高度
#define kiphoneXBottomBarHeight 83
//iphone X导航栏高度
#define kTopBarHeight_iPhoneX 88
//标签栏高度
#define kTabBarHeight [[UITabBarController alloc]init].tabBar.frame.size.height
//iPhone X标签栏高度
#define kTabBarHeight_iPhoneX 83

#define is_iPhoneXS_Max (ScreenW == 414.f && ScreenH == 896.f)
#define is_iPhoneX (ScreenW == 375.f && ScreenH == 812.f)
#define is_iPhone8_Plus (ScreenW == 414.f && ScreenH == 736.f)
#define is_iPhone8 (ScreenW == 375.f && ScreenH == 667.f)
#define is_iPhone5 (ScreenW == 320 && ScreenH == 568.f)
#define is_iPhone5_OR_LESS (ScreenW == 320 && ScreenH <= 568.f)
//全局背景色
#define whiteColor [UIColor whiteColor]
#define clearColor [UIColor clearColor]
#define blackColor [UIColor blackColor]
#define darkGrayColor [UIColor darkGrayColor]
#define lightGrayColor [UIColor lightGrayColor]
#define grayColor [UIColor grayColor]
#define redColor [UIColor redColor]
#define greenColor [UIColor greenColor]
#define blueColor [UIColor blueColor]
#define cyanColor [UIColor cyanColor]
#define yellowColor [UIColor yellowColor]
#define magentaColor [UIColor magentaColor]
#define orangeColor [UIColor orangeColor]
#define purpleColor [UIColor purpleColor]
#define brownColor [UIColor brownColor]


#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2


#define DCBGColor RGB(245,245,245)
//一像素
#define oneLine 1/[UIScreen mainScreen].scale
//获取通知中心
#define NotificationCenter [NSNotificationCenter defaultCenter]
//一像素
#define OnePixel 1/[UIScreen mainScreen].scale
//状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//灵活view高度
#define ViewHeight ScreenH-kStatusBarHeight-kNaviBarHeight-kTabBarHeight

//Nav高度
#define kNaviBarHeight 44
//导航栏高度
#define kTopBarHeight (kStatusBarHeight+kNaviBarHeight)
//标签栏高度
#define kBottomBarHeight 49
//iphoneX标签栏高度
#define kiphoneXBottomBarHeight 83
//iphone X导航栏高度
#define kTopBarHeight_iPhoneX 88
//标签栏高度
#define kTabBarHeight [[UITabBarController alloc]init].tabBar.frame.size.height
//iPhone X标签栏高度
#define kTabBarHeight_iPhoneX 83

#define is_iPhoneXS_Max (ScreenW == 414.f && ScreenH == 896.f)

#define is_iPhoneX (ScreenW == 375.f && ScreenH == 812.f)

#define is_iPhone8_Plus (ScreenW == 414.f && ScreenH == 736.f)

#define is_iPhone8 (ScreenW == 375.f && ScreenH == 667.f)

#define is_iPhone5 (ScreenW == 320 && ScreenH == 568.f)

#define is_iPhone5_OR_LESS (ScreenW == 320 && ScreenH <= 568.f)

//NSUserDefaults

#define IsReadGroupPrivacy @"IsReadGroupPrivacy"//用于判断群聊@，长度为0为没有@，反之有@
//通知
#define ContactRefresh @"ContactRefresh"//通讯录刷新
//通讯录刷新
#define GroupMemberRefresh @"GroupMemberRefresh"

#endif /* Macros_h */
