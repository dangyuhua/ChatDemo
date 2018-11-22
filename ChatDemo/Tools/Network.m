//
//  NetworkingManage.m
//  Shopping
//
//  Created by 党玉华 on 2018/7/13.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import "Network.h"

BOOL haveNetwork;

@interface Network()

@end

@implementation Network

//网络检测
+(void)startMonitoringNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            haveNetwork = NO;
            [MBPManage showMessage:WIN message:@"没有网络"];
        }else{
            haveNetwork = YES;
            [MBPManage showMessage:WIN message:@"网络已连接"];
        }
    }];
    
    //开始监控
    [manager startMonitoring];
}

@end
