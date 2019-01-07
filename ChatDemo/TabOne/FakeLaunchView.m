//
//  FakeLaunchView.m
//  ChatDemo
//
//  Created by 党玉华 on 2019/1/7.
//  Copyright © 2019年 dyh绝地求生专业送快递. All rights reserved.
//

#import "FakeLaunchView.h"

@implementation FakeLaunchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *imageview = [QuickTools UIImageViewWithFrame:Frame(0, 0, ScreenW, ScreenH) image:[QuickTools getLaunchImage]];
    [self addSubview:imageview];
}

@end
