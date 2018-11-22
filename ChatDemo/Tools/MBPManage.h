//
//  MBPManage.h
//  Shopping
//
//  Created by 党玉华 on 2018/7/17.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBPManage : NSObject
//带加载图
+ (void)showLoadingMessage:(UIView *)view message:(NSString *)message;
//提示框（可操作）
+(void)showMessage:(UIView *)view message:(NSString *)message;
//提示框(不可操作当前界面)
+(void)showMessageOfNOInteraction:(UIView *)view message:(NSString *)message;
//yOffset偏移量
+(void)showMessage:(NSString *)message yOffset:(float)yOffset;
//隐藏MBP
+ (void)hide:(UIView *)view;

@end
