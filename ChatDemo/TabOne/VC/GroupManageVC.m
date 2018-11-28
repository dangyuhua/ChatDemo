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
#import "ContactListVC.h"

@interface GroupManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *models;

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,copy)NSString *ower;

@end

@implementation GroupManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组管理";
    self.models = [[NSMutableArray alloc]init];
    [NotificationCenter addObserver:self selector:@selector(setupData) name:GroupMemberRefresh object:nil];
    
    [self setupUI];
    [self setupData];
}

-(void)setupData{
    [self.models removeAllObjects];
    [MBPManage showLoadingMessage:self.view message:nil];
    [EMClientManage getGroupDetailsWithAGroupID:self.groupID succeed:^(id data) {
        EMGroup *group = data;
        self.ower = group.owner;
        [self.models addObjectsFromArray:group.occupants];
        [self.tableview reloadData];
        self.tableview.hidden = NO;
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
    self.tableview.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
    }else{
        if ([[EMClientManage currentUsername]isEqualToString:self.ower]) {
            cell.textLabel.text = @"群组解散";
        }else{
            cell.textLabel.text = @"退出群组";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:self.models[indexPath.row] conversationType:EMConversationTypeChat];
        vc.title = self.models[indexPath.row];
        [self pushVC:vc];
    }else if (indexPath.section==1){
        GroupMemberManageVC *vc = [[GroupMemberManageVC alloc]init];
        vc.modelsArray = self.models;
        vc.groupID = self.groupID;
        [self pushVC:vc];
    }else{
        if ([[EMClientManage currentUsername]isEqualToString:self.ower]) {
            [EMClientManage delectGroupWithGroupId:self.groupID succeed:^(id data) {
                [MBPManage showMessage:WIN message:@"解散成功"];
                [NotificationCenter postNotificationName:ContactRefresh object:nil];
                [self popVC:[ContactListVC class]];
            } failure:^(EMError *aError) {
                [MBPManage showMessage:WIN message:aError.errorDescription];
            }];
        }else{
            [EMClientManage quitGroupWithGroupID:self.groupID succeed:^(id data) {
                [MBPManage showMessage:WIN message:@"退出成功"];
                [NotificationCenter postNotificationName:ContactRefresh object:nil];
                [self popVC:[ContactListVC class]];
            } failure:^(EMError *aError) {
                [MBPManage showMessage:WIN message:aError.errorDescription];
            }];
        }
    }
}

@end
