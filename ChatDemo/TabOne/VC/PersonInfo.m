//
//  PersonInfo.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/22.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "PersonInfo.h"

@interface PersonInfo ()

@property(nonatomic,strong)UITextField *textfield;

@property(nonatomic,strong)UIButton *btn;

@end

@implementation PersonInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    self.textfield = [QuickCreate UITextFieldWithFrame:Frame(30, 100, ScreenW-60, 40) cornerRadius:5 font:16 borderStyle:UITextBorderStyleNone backgroundColor:whiteColor placeholder:@"请输入透传消息" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} returnKeyType:UIReturnKeyGo leftview:[QuickCreate UIViewWithFrame:Frame(0, 0, 5, 40) backgroundColor:clearColor] rightView:nil clearButtonMode:UITextFieldViewModeWhileEditing keyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:self.textfield];
    self.textfield.layer.borderColor = RGB(239, 239, 239).CGColor;
    self.textfield.layer.borderWidth = 1;
    self.btn = [QuickCreate UIButtonWithFrame:Frame(38, 160, ScreenW-76, 50) backgroundColor:blueColor title:@"发送透传信息" image:nil selectImage:nil font:17 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:0 target:self action:@selector(btnClick)];
    [self.view addSubview:self.btn];
    self.btn.layer.cornerRadius = 5;
    
    UIButton *delect = [QuickCreate UIButtonWithFrame:Frame(38, 250, ScreenW-76, 50) backgroundColor:blueColor title:@"删除好友" image:nil selectImage:nil font:17 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:0 target:self action:@selector(delectClick)];
    [self.view addSubview:delect];
    delect.layer.cornerRadius = 5;
    
}

-(void)btnClick{
    [MBPManage showLoadingMessage:self.view message:nil];
    [EMClientManage sendCMDmsgWithAction:@"test" chatType:EMChatTypeChat conversationID:self.hxid messageExt:@{self.hxid:self.textfield.text} succeed:^(id data) {
        [MBPManage hide:self.view];
        DLog(@"%@",data);
        [self.textfield resignFirstResponder];
    } failure:^(EMError *aError) {
        [MBPManage hide:self.view];
        DLog(@"%@",aError.errorDescription);
    }];
}

-(void)delectClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你确定要删除%@吗",self.hxid] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [EMClientManage delectContactWithName:self.hxid succeed:^(id data) {
            [MBPManage showMessage:WIN message:@"删除成功"];
        } failure:^(EMError *aError) {
            [MBPManage showMessage:WIN message:@"删除失败"];
        }];
    }];
    [alert addAction:sure];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
