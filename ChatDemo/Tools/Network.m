//
//  NetworkingManage.m
//  Shopping
//
//  Created by 党玉华 on 2018/7/13.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import "Network.h"

static Network *network = nil;

@interface Network()

@end

@implementation Network

+(instancetype)shareNet{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[Network alloc]init];
    });
    return network;
}

//网络检测
+(void)startMonitoringNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [[Network shareNet]setHaveNet:NO];
            [MBPManage showMessage:WIN message:@"没有网络"];
        }else{
            [[Network shareNet]setHaveNet:YES];
            [MBPManage showMessage:WIN message:@"网络已连接"];
        }
    }];
    
    //开始监控
    [manager startMonitoring];
}

@end
