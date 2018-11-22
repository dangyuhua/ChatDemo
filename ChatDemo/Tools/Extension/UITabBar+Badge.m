//
//  UITabBar+Badge.m
//  demo
//
//  Created by 党玉华 on 2018/9/10.
//  Copyright © 2018年 Person. All rights reserved.
//

#import "UITabBar+Badge.h"
//⚠️⚠️⚠️⚠️
#define TabbarItemNums 3.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index title:(NSString *)title{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.backgroundColor = redColor;//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.08 * tabFrame.size.height);
    badgeView.frame = Frame(x, y, 8, 8);
    badgeView.layer.cornerRadius = badgeView.frame.size.width/2;
    [self addSubview:badgeView];
    if (title != nil) {
        badgeView.frame = Frame(x, y, 17, 17);
        badgeView.layer.cornerRadius = badgeView.frame.size.width/2;
        UILabel *label = [QuickCreate UILabelWithFrame:CGRectZero backgroundColor:clearColor textColor:whiteColor text:title numberOfLines:0 textAlignment:NSTextAlignmentCenter font:12];
        CGFloat width = [QuickCreate calculatedStringWidth:title WithSize:Size(MAXFLOAT,17) font:12];
        if (width>badgeView.frame.size.width) {
            width += 10;
            badgeView.frame = Frame(x, y, width, 17);
            label.frame = Frame(0, 0, width, badgeView.frame.size.height);
        }else{
            label.frame = Frame(0, 0, badgeView.frame.size.width, badgeView.frame.size.height);
        }
        [badgeView addSubview:label];
    }
    
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
