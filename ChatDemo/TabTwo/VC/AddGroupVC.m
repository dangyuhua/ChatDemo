//
//  AddGroupVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/22.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "AddGroupVC.h"

@interface AddGroupVC ()

@property(nonatomic,strong)UITextField *textfield;

@end

@implementation AddGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    self.textfield = [QuickTools UITextFieldWithFrame:Frame(10, 50, ScreenW-20, 50) cornerRadius:5 font:18 borderStyle:UITextBorderStyleNone backgroundColor:whiteColor placeholder:@"请输入群名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} returnKeyType:UIReturnKeyDefault leftview:[QuickTools UIViewWithFrame:Frame(0, 0, 5, 40) backgroundColor:clearColor] rightView:nil clearButtonMode:UITextFieldViewModeWhileEditing keyboardType:UIKeyboardTypeDefault];
    self.textfield.layer.borderColor = RGB(239, 239, 239).CGColor;
    self.textfield.layer.borderWidth = 1;
    [self.view addSubview:self.textfield];
    
    UIButton *btn1 = [QuickTools UIButtonWithFrame:Frame(30, 138, ScreenW-60, 50) backgroundColor:blueColor title:@"创建" image:nil selectImage:nil font:18 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:0 target:self action:@selector(btnClick:)];
    [self.view addSubview:btn1];
    btn1.layer.cornerRadius = 5;
    
    UIButton *btn2 = [QuickTools UIButtonWithFrame:Frame(30, 218, ScreenW-60, 50) backgroundColor:blueColor title:@"加入" image:nil selectImage:nil font:18 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:1 target:self action:@selector(btnClick:)];
    [self.view addSubview:btn2];
    btn2.layer.cornerRadius = 5;
}

-(void)btnClick:(UIButton *)btn{
    [MBPManage showLoadingMessage:self.view message:nil];
    if (btn.tag==0) {
        [EMClientManage creatGroupGroupName:self.textfield.text description:nil ext:nil invitees:[[NSMutableArray alloc]init] message:@"邀请您加入群组" maxUsersCount:500 isInviteNeedConfirm:NO style:EMGroupStylePublicOpenJoin succeed:^(id data) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:WIN message:@"创建成功"];
            [NotificationCenter postNotificationName:ContactRefresh object:nil];
            [self pop];
        } failure:^(EMError *aError) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:WIN message:@"创建失败"];
        }];
    }else{
        [EMClientManage requestJoinFGroupToGroup:self.textfield.text message:nil succeed:^(id data) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:WIN message:@"加入成功"];
            [NotificationCenter postNotificationName:ContactRefresh object:nil];
            [self pop];
        } failure:^(EMError *aError) {
            [MBPManage hide:self.view];
            [MBPManage showMessage:WIN message:@"加入失败"];
        }];
    }
}

@end
