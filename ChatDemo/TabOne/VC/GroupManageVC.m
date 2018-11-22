//
//  GroupManageVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/22.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "GroupManageVC.h"
#import "ChatVC.h"
#import "GroupMemberManageVC.h"

@interface GroupManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *models;

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation GroupManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组管理";
    self.models = [[NSMutableArray alloc]init];
    [self setupUI];
    [self setupData];
}

-(void)setupData{
    [MBPManage showLoadingMessage:self.view message:nil];
    [EMClientManage getGroupDetailsWithAGroupID:self.groupID succeed:^(id data) {
        EMGroup *group = data;
        [self.models addObjectsFromArray:group.occupants];
        [self.tableview reloadData];
        [MBPManage hide:self.view];
    } failure:^(EMError *aError) {
        [MBPManage hide:self.view];
        [MBPManage showMessage:self.view message:aError.errorDescription];
    }];
}

-(void)setupUI{
    self.tableview = [QuickCreate UITableViewWithBackgroundColor:RGB(239, 239, 239) frame:Frame(0, 0, ScreenW, ScreenH-kTopBarHeight) separatorStyle:UITableViewCellSeparatorStyleSingleLine style:UITableViewStyleGrouped contentInset:Edge(0, 0, 30, 0)];
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GroupManageVCCellID"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.models.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupManageVCCellID" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GroupManageVCCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        if (self.models.count!=0) {
            cell.textLabel.text = self.models[indexPath.row];
        }
    }else if (indexPath.section==1) {
        cell.textLabel.text = @"群员管理";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:self.models[indexPath.row] conversationType:EMConversationTypeChat];
        vc.title = self.models[indexPath.row];
        [self pushVC:vc];
    }else{
        GroupMemberManageVC *vc = [[GroupMemberManageVC alloc]init];
        [self pushVC:vc];
    }
}

@end
