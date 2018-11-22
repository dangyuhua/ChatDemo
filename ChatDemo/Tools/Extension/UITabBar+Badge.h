//
//  UITabBar+Badge.h
//  demo
//
//  Created by 党玉华 on 2018/9/10.
//  Copyright © 2018年 Person. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index title:(NSString *)title;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点 

@end
