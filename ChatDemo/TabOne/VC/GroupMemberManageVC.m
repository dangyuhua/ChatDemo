//
//  GroupMemberManageVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/22.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "GroupMemberManageVC.h"
#import "GroupMemberManageVCModel.h"

@interface GroupMemberManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *models;

@end

@implementation GroupMemberManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = [[NSMutableArray alloc]init];
    
    [self setupUI];
    [self setupData];
}

-(void)setupData{
    [MBPManage showLoadingMessage:self.view message:nil];
    [EMClientManage getContactListFromServerSucceed:^(id data) {
        NSArray *array = data;
        for (int i=0; i<array.count; i++) {
            GroupMemberManageVCModel *model = [[GroupMemberManageVCModel alloc]init];
            model.name = array[i];
            [self.models addObject:model];
        }
        for (int i=0; i<self.models.count; i++) {
            GroupMemberManageVCModel *model = self.models[i];
            for (int j=0; j<self.modelsArray.count; j++) {
                if ([model.name isEqualToString:self.modelsArray[j]]){
                    model.isSelect = YES;
                }
            }
        }
        [self.tableview reloadData];
        self.tableview.hidden = NO;
        [MBPManage hide:self.view];
    } failure:^(EMError *aError) {
        [MBPManage hide:self.view];
        [MBPManage showMessage:self.view message:aError.errorDescription];
    }];
}

-(void)setupUI{
    self.tableview = [QuickTools UITableViewWithBackgroundColor:RGB(239, 239, 239) frame:Frame(0, 0, ScreenW, ScreenH-kTopBarHeight) separatorStyle:UITableViewCellSeparatorStyleSingleLine style:UITableViewStyleGrouped contentInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GroupMemberManageVCCellID"];
    self.tableview.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberManageVCCellID" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GroupMemberManageVCCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GroupMemberManageVCModel *model = self.models[indexPath.row];
    cell.textLabel.text = model.name;
    if (model.isSelect) {
        cell.backgroundColor = RGB(245, 245, 245);
    }else{
        cell.backgroundColor = whiteColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMemberManageVCModel *model = self.models[indexPath.row];
    [MBPManage showLoadingMessage:self.view message:nil];
    model.isSelect = !model.isSelect;
    [self.tableview reloadData];
    if (model.isSelect) {
        [EMClientManage inviteFriendJoinFGroup:[NSMutableArray arrayWithArray:@[model.name]] toGroup:self.groupID message:nil succeed:^(id data) {
            [NotificationCenter postNotificationName:GroupMemberRefresh object:nil];
            GCD_AFTER(0.5, ^{
                [MBPManage hide:self.view];
            });
        } failure:^(EMError *aError) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:self.view message:aError.errorDescription];
        }];
    }else{
        [EMClientManage delectMemberFromGroup:[NSMutableArray arrayWithArray:@[model.name]] toGroup:self.groupID succeed:^(id data) {
            [NotificationCenter postNotificationName:GroupMemberRefresh object:nil];
            GCD_AFTER(0.5, ^{
                [MBPManage hide:self.view];
            });
        } failure:^(EMError *aError) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:self.view message:aError.errorDescription];
        }];
    }
}

@end
