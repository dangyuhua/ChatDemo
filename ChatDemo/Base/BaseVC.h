//
//  BaseVC.h
//  Shopping
//
//  Created by 党玉华 on 2018/6/18.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^completionBlock)(void);

@interface BaseVC : UIViewController
//vc的网络请求数组
@property(nonatomic,strong)NSMutableArray<NSURLSessionTask *> *netsArray;

-(void)pushVC:(UIViewController *)vc;

-(void)pop;

-(void)popVC:(Class)aClass;

-(void)popToRootVC;

-(void)presentVC:(UIViewController *)vc blcok:(completionBlock)block;

-(void)dismissBlcok:(completionBlock)block;

@end
