//
//  BaseVC.m
//  Shopping
//
//  Created by 党玉华 on 2018/6/18.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()<UIGestureRecognizerDelegate>

@end

@implementation BaseVC
//vc消失的时候销毁vc所有网络请求
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (NSURLSessionTask *task in self.netsArray) {
        if (task.state == NSURLSessionTaskStateRunning) {
            [task cancel];
        }
    }
}
//vc的网络请求数组
- (NSMutableArray *)netsArray{
    if (!_netsArray) {
        _netsArray = [[NSMutableArray alloc]init];
    }
    return _netsArray;
}

//设置视图滑动手势
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // rootViewController要关闭返回手势，否则有BUG
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
//在导航栏不存在或隐藏的情况下
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
    //在导航栏存在并且没有隐藏的情况下
    //状态栏文本颜色白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //状态栏文本颜色黑色 ,默认就是黑色
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    
    
    //滑动手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = whiteColor;
    //配置导航栏
    [self setupNavi];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)setupNavi{
    //配置返回按钮
    if (self.navigationController.viewControllers.firstObject != self) {
        self.navigationItem.leftBarButtonItem = [QuickTools UIBarButtonItemNavBackBarButtonItemWithTarget:self action:@selector(pop)];
    }
    
    //去除导航栏黑线
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];

    //配置导航栏颜色
    self.navigationController.navigationBar.backgroundColor = RGB(53, 53, 53);
    self.navigationController.navigationBar.barTintColor = RGB(53, 53, 53);
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:whiteColor}];
}

-(void)pushVC:(UIViewController *)vc{
    if (self.navigationController.viewControllers.firstObject != vc) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popVC:(Class)aClass{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:aClass]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)popToRootVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)presentVC:(UIViewController *)vc blcok:(completionBlock)block{
    [self presentViewController:vc animated:YES completion:block];
}

-(void)dismissBlcok:(completionBlock)block{
    [self dismissViewControllerAnimated:YES completion:block];
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
