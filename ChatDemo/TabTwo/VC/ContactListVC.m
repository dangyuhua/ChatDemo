//
//  ContactListVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/20.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "ContactListVC.h"
#import "AddFriendVC.h"
#import "ChatVC.h"
#import "AddGroupVC.h"

@interface ContactListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)UILabel *friendLabel;

@property(nonatomic,strong)UILabel *groupLabel;

@property(nonatomic,strong)NSMutableArray *friendsList;

@property(nonatomic,strong)NSMutableArray *groupsList;


@end

@implementation ContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    self.friendsList = [[NSMutableArray alloc]init];
    self.groupsList = [[NSMutableArray alloc]init];
    [NotificationCenter addObserver:self selector:@selector(setupData) name:ContactRefresh object:nil];
    
    [self setupUI];
    [self setupData];
    
}
//从网络获取好友列表和群组列表
-(void)setupData{
    [MBPManage showLoadingMessage:self.view message:nil];
    GCD_GLOBAL_QUEUE_ASYNC(^{
        [EMClientManage getContactListFromServerSucceed:^(id data) {
            self.friendsList = data;
            [EMClientManage getAllGroupsFromServeSucceed:^(id data) {
                self.groupsList = data;
                GCD_MAIN_QUEUE_ASYNC(^{
                    [self.tableview reloadData];
                    [self.tableview.mj_header endRefreshing];
                    self.tableview.hidden = NO;
                    [MBPManage hide:self.view];
                });
            } failure:^(EMError *aError) {
                GCD_MAIN_QUEUE_ASYNC(^{
                    [self.tableview.mj_header endRefreshing];
                    [MBPManage hide:self.view];
                    [MBPManage showMessage:self.view message:@"获取通讯录失败"];
                });
            }];
        } failure:^(EMError *aError) {
            GCD_MAIN_QUEUE_ASYNC(^{
                [self.tableview.mj_header endRefreshing];
                [MBPManage hide:self.view];
                [MBPManage showMessage:self.view message:@"获取通讯录失败"];
            });
        }];
    });
}

-(void)setupUI{
    self.tableview = [QuickCreate UITableViewMJRefreshWithBackgroundColor:RGB(239, 239, 239) frame:Frame(0, 0, ScreenW, ScreenH-kTopBarHeight-kTabBarHeight) separatorStyle:UITableViewCellSeparatorStyleSingleLine style:UITableViewStyleGrouped contentInset:Edge(0, 0, 30, 0) footIsNeedDrag:NO mjheadBlock:^{
        [self setupData];
    } mjfootBlock:nil];
    self.tableview.mj_footer = nil;
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TwoCellID"];
    self.tableview.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return self.friendsList.count;
    }else if (section==2){
        return self.groupsList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoCellID" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TwoCellID"];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"好友添加";
        }else{
            cell.textLabel.text = @"群组创建或申请加入";
        }
    }else if (indexPath.section==1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.friendsList[indexPath.row]];
    }else if (indexPath.section==2){
        EMGroup *group = self.groupsList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",group.subject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            AddFriendVC *vc = [[AddFriendVC alloc]init];
            [self pushVC:vc];
        }else{
            AddGroupVC *vc = [[AddGroupVC alloc]init];
            [self pushVC:vc];
        }
    }else if (indexPath.section==1){
        ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:self.friendsList[indexPath.row] conversationType:EMConversationTypeChat];
        vc.title = self.friendsList[indexPath.row];
        [self pushVC:vc];
    }else if (indexPath.section==2){
        EMGroup *group = self.groupsList[indexPath.row];
        ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        vc.title = group.subject;
        [self pushVC:vc];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        self.friendLabel = [QuickCreate UILabelWithFrame:Frame(0, 0, ScreenW, 25) backgroundColor:clearColor textColor:RGB(207, 207, 207) text:@"  好友" numberOfLines:0 textAlignment:NSTextAlignmentLeft font:15];
        if (self.friendsList.count!=0) {
            self.friendLabel.hidden = NO;
        }else{
            self.friendLabel.hidden = YES;
        }
        return self.friendLabel;
    }else if (section==2){
        self.groupLabel = [QuickCreate UILabelWithFrame:Frame(0, 0, ScreenW, 25) backgroundColor:clearColor textColor:RGB(207, 207, 207) text:@"  群组" numberOfLines:0 textAlignment:NSTextAlignmentLeft font:15];
        if (self.groupsList.count!=0) {
            self.groupLabel.hidden = NO;
        }else{
            self.groupLabel.hidden = YES;
        }
        return self.groupLabel;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1f;
    }
    return 18;
}

@end
