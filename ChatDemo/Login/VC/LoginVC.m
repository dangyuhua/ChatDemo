//
//  LoginVC.m
//  demo
//
//  Created by 党玉华 on 2018/7/30.
//  Copyright © 2018年 Person. All rights reserved.
//

#import "LoginVC.h"
#import "TabBarVC.h"

@interface LoginVC ()

@property(nonatomic,strong)UITextField *idTf;

@property(nonatomic,strong)UITextField *pwTf;

@property(nonatomic,strong)UIButton *registerBtn;

@property(nonatomic,strong)UIButton *loginBtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)setupUI{
    self.idTf = [QuickTools UITextFieldWithFrame:Frame(50, 100, ScreenW-100, 40) cornerRadius:5 font:15 borderStyle:UITextBorderStyleRoundedRect backgroundColor:clearColor placeholder:@"请输入账号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} returnKeyType:UIReturnKeyDefault leftview:[QuickTools UIViewWithFrame:Frame(0, 0, 10, 40) backgroundColor:clearColor] rightView:nil clearButtonMode:UITextFieldViewModeWhileEditing keyboardType:UIKeyboardTypePhonePad];
    [self.view addSubview:self.idTf];
    
    self.pwTf = [QuickTools UITextFieldWithFrame:Frame(50, 180, ScreenW-100, 40) cornerRadius:5 font:15 borderStyle:UITextBorderStyleRoundedRect backgroundColor:clearColor placeholder:@"请输入账号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} returnKeyType:UIReturnKeyGo leftview:[QuickTools UIViewWithFrame:Frame(0, 0, 10, 40) backgroundColor:clearColor] rightView:nil clearButtonMode:UITextFieldViewModeWhileEditing keyboardType:UIKeyboardTypePhonePad];
    [self.view addSubview:self.pwTf];
    
    self.registerBtn = [QuickTools UIButtonWithFrame:Frame(50, 350, ScreenW-100, 40) backgroundColor:blueColor title:@"注册" image:nil selectImage:nil font:18 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:0 target:self action:@selector(registerBtnClick)];
    self.registerBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.registerBtn];
    
    self.loginBtn = [QuickTools UIButtonWithFrame:Frame(50, 430, ScreenW-100, 40) backgroundColor:blueColor title:@"登录" image:nil selectImage:nil font:18 textColor:whiteColor selectTextColor:whiteColor edgeInsets:UIEdgeInsetsZero tag:0 target:self action:@selector(loginBtnClick)];
    self.loginBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.loginBtn];
}

-(void)registerBtnClick{
    [MBPManage showLoadingMessage:self.view message:nil];
    [EMClientManage registerUserWithUserName:self.idTf.text password:self.pwTf.text succeed:^(id data) {
        [MBPManage hide:self.view];
        [MBPManage showMessage:self.view message:@"注册成功，请点击登录"];
    } failure:^(EMError *aError) {
        [MBPManage hide:self.view];
        [MBPManage showMessage:self.view message:[NSString stringWithFormat:@"%@",aError.errorDescription]];
    }];
}

-(void)loginBtnClick{
    [MBPManage showLoadingMessage:self.view message:nil];
    //登录环信
    [EMClientManage loginEMClientSDKWithUsername:self.idTf.text password:self.pwTf.text succeed:^(id data) {
        [MBPManage hide:self.view];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"TabBarVC"];
        WIN.rootViewController = vc;
    } failure:^(EMError *aError) {
        [MBPManage hide:self.view];
        [MBPManage showMessage:self.view message:[NSString stringWithFormat:@"%@",aError.errorDescription]];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
