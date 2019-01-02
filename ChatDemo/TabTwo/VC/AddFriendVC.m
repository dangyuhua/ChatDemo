//
//  AddFriendVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/20.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "AddFriendVC.h"

@interface AddFriendVC ()

@property(nonatomic,strong)UITextField *textfield;

@end

@implementation AddFriendVC

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    DLog(@"dd");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友添加";
    [self setupUI];
}

-(void)setupUI{
    self.textfield = [QuickTools UITextFieldWithFrame:Frame(10, 50, ScreenW-20, 50) cornerRadius:5 font:18 borderStyle:UITextBorderStyleNone backgroundColor:whiteColor placeholder:@"请输入你要添加的人" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} returnKeyType:UIReturnKeyDefault leftview:[QuickTools UIViewWithFrame:Frame(0, 0, 5, 40) backgroundColor:clearColor] rightView:nil clearButtonMode:UITextFieldViewModeWhileEditing keyboardType:UIKeyboardTypePhonePad];
    self.textfield.layer.borderColor = RGB(239, 239, 239).CGColor;
    self.textfield.layer.borderWidth = 1;
    [self.view addSubview:self.textfield];
    UIButton *btn = [QuickTools UIButtonWithFrame:Frame(30, 138, ScreenW-60, 50) backgroundColor:blueColor title:@"确定" image:nil selectImage:nil font:18 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:0 target:self action:@selector(btnClick)];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
}

-(void)btnClick{
    [EMClientManage addContactList:self.textfield.text message:[NSString stringWithFormat:@"%@想添加你为好友",[EMClientManage currentUsername]] succeed:^(id data) {
        [MBPManage showMessage:WIN message:@"发送成功"];
    } failure:^(EMError *aError) {
        [MBPManage showMessage:WIN message:@"发送失败"];
    }];
}

//点击空白区域收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
