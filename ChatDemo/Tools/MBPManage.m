//
//  MBPManage.m
//  Shopping
//
//  Created by 党玉华 on 2018/7/17.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import "MBPManage.h"

@implementation MBPManage
//带加载图
+(void)showLoadingMessage:(UIView *)view message:(NSString *)message{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud show:YES];
}
//提示框
+(void)showMessage:(UIView *)view message:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    //    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 12.f;
    hud.yOffset = 80;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}
//提示框（显示期间无法交互）
+(void)showMessageOfNOInteraction:(UIView *)view message:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 12.f;
    hud.yOffset = 80;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}
//
+(void)showMessage:(NSString *)message yOffset:(float)yOffset
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}
//隐藏MBP
+ (void)hide:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
