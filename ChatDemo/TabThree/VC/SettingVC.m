//
//  SettingVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/20.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "SettingVC.h"
#import "LoginVC.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupUI];
}

-(void)setupUI{
    UITableView *tableview = [QuickTools UITableViewWithBackgroundColor:RGB(239, 239, 239) frame:Frame(0, 0, ScreenW, ScreenH-kTopBarHeight) separatorStyle:UITableViewCellSeparatorStyleSingleLine style:UITableViewStyleGrouped contentInset:Edge(0, 0, 30, 0)];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ThreeCellID"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeCellID" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ThreeCellID"];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"用户名：%@",[EMClientManage currentUsername]];
    }else if (indexPath.section==1){
        cell.textLabel.text = @"退出登录";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        [MBPManage showLoadingMessage:self.view message:nil];
        [EMClientManage logoutSucceed:^(id data) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:WIN message:@"退出登录成功"];
            WIN.rootViewController = [[LoginVC alloc]init];
        } failure:^(EMError *aError) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:WIN message:@"退出登录失败，请重试"];
        }];
    }
}

@end
