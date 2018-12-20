//
//  NetworkingManage.h
//  Shopping
//
//  Created by 党玉华 on 2018/7/13.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject
//是否有网络
@property(nonatomic,assign)BOOL haveNet;
+(instancetype)shareNet;
//网络检测
+(void)startMonitoringNetwork;
@end
