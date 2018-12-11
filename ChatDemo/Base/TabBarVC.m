//
//  TabBarVC.m
//  购物
//
//  Created by 党玉华 on 2017/11/30.
//  Copyright © 2017年 党玉华. All rights reserved.
//

#import "TabBarVC.h"
#import "ChatListVC.h"
#import "ContactListVC.h"
#import "SettingVC.h"
#import "ChatVC.h"

@interface TabBarVC ()<UITabBarDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate>

@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * classArray;
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) NSArray * selectImageArray;
@property(nonatomic,strong)LocalNotificationManage *mb;
@property(nonatomic,assign)BOOL isLoad;

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabData];
    [self setTabBar];
    self.mb = [[LocalNotificationManage alloc]init];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    //监听加好友请求 当您收到好友请求，如果您没有处理，请自己保存数据，新协议下不会每次都发送。
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //注册群组回调
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)setTabData{
    //防止“返回“时遇到tabbar栏frame bug
    [UITabBar appearance].translucent = NO;
    
    self.titleArray = @[@"消息",@"通讯录",@"设置"];
    self.classArray = @[[[ChatListVC alloc]init],[[ContactListVC alloc]init],[[SettingVC alloc]init]];
    self.imageArray = @[@"homeNormal",@"categoryNormal",@"discoverNormal"];
    self.selectImageArray = @[@"homeHight",@"categoryHight",@"discoverHight"];//@"carNormal"购物车图标
}

//创建tab
-(void)setTabBar{
    // 去掉tab黑色分割线
//    self.tabBar.barStyle = UIBarStyleBlack;
//    self.tabBar.shadowImage = [[UIImage alloc]init];
    
    //bar栏颜色
    self.tabBar.barTintColor = whiteColor;
    
    for (int i = 0; i < self.classArray.count; i++) {
        [self setChildViewController:self.classArray[i] tag:i title:self.titleArray[i] image:[UIImage imageNamed:self.imageArray[i]] selectedImage:[UIImage imageNamed:self.selectImageArray[i]] navi:YES];
    }
}

-(void)setChildViewController:(UIViewController *)childController tag:(NSInteger)tag title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage navi:(BOOL )isSetN{
    
    childController.tabBarItem=[[UITabBarItem alloc]initWithTitle:title image:image selectedImage:selectedImage];
    childController.tabBarItem.tag = tag;
    //设置tab字体颜色
//    [self selectedTapTabBarItems:childController.tabBarItem];
//
//    [self unSelectedTapTabBarItems:childController.tabBarItem];
    
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:childController];
    
    [self addChildViewController:navigationController];
}

//tab字体颜色
-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12],NSFontAttributeName,
                                        [UIColor colorWithRed:40/255.0 green:160/255.0 blue:57/255.0 alpha:1],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
    
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12], NSFontAttributeName,
                                        darkGrayColor,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}
//tabbar点击
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 0) {
        DLog(@"0");
    }else if (item.tag == 1){
        DLog(@"1");
    }else if (item.tag == 2){
        DLog(@"2");
    }
    
}



//消息接收
- (void)messagesDidReceive:(NSArray *)aMessages{
    //刷新未读消息
    for(EMMessage *msg in aMessages){
        if (msg.chatType == EMChatTypeGroupChat) {
            if (msg.ext[@"em_at_list"]) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:msg.ext[@"em_at_list"] forKey:@"em_at_list"];
                [dict setObject:@"1" forKey:@"isread"];
                msg.ext = dict;
            }
        }else if (msg.chatType == EMChatTypeChat){
            NSString *latestMessageTitle = @"";
            EMMessageBody *messageBody = msg.body;
            switch (messageBody.type) {
                case EMMessageBodyTypeImage:{
                    latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
                } break;
                case EMMessageBodyTypeText:{
                    // 表情映射。
                    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                                convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                    latestMessageTitle = didReceiveText;
                    if ([msg.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                        latestMessageTitle = @"[动画表情]";
                    }
                } break;
                case EMMessageBodyTypeVoice:{
                    latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
                } break;
                case EMMessageBodyTypeLocation: {
                    latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
                } break;
                case EMMessageBodyTypeVideo: {
                    latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
                } break;
                case EMMessageBodyTypeFile: {
                    latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
                } break;
                default: {
                };
            }
            if (![[QuickTools getCurrentVC]isKindOfClass:[ChatVC class]]) {
                NSString *str;
                if(msg.chatType == EMChatTypeChat){
                    str = @"Chat";
                }else if (msg.chatType == EMChatTypeGroupChat){
                    str = @"GroupChat";
                }
                [self.mb addlocalNotificationWithTitle:@"消息通知" describe:[NSString stringWithFormat:@"%@:%@",msg.from,latestMessageTitle] userInfo:@{@"title":@"消息通知",@"hxid":msg.from,@"type":str}];
            }
        }
    }
    //刷新未读消息
    [EMClientManage showUnreadMSGCount];
    [NotificationCenter postNotificationName:RefreshEMClient object:nil];
    [QuickTools playVibrate];
}
//透传消息接收
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        if (message.chatType == EMChatTypeChat) {
            NSString *currentName = [EMClientManage currentUsername];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"收到的action是 -- %@,\n透传消息是--%@",body.action,message.ext[currentName]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        DLog(@"收到的action是 -- %@,\n消息体是--%@,\n扩展消息是--%@",body.action,message.body,message.ext);
    }
}

//监听加好友请求回调  用户A发送加用户B为好友的申请，用户B会收到这个回调
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:aUsername message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [EMClientManage acceptAddContactWithName:aUsername succeed:^(id data) {
            [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"你已同意%@的好友请求",aUsername]];
            [NotificationCenter postNotificationName:ContactRefresh object:nil];
        } failure:^(EMError *aError) {
            [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"添加%@好友失败",aUsername]];
        } ];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [EMClientManage declineAddContactWithName:aUsername succeed:^(id data) {
            [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"你已拒绝%@的好友请求",aUsername]];
        } failure:^(EMError *aError) {
            [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"拒绝%@的好友请求失败",aUsername]];
        }];
    }];
    [ac addAction:cancel];
    [ac addAction:sure];
    [self presentViewController:ac animated:YES completion:nil];
    
}
//同意回调  用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"%@已同意你的好友请求",aUsername]];
    [NotificationCenter postNotificationName:ContactRefresh object:nil];
}
//拒绝回调  用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"%@已拒绝你的好友请求",aUsername]];
}
//用户B删除与用户A的好友关系后，用户A，B会收到这个回调
- (void)friendshipDidRemoveByUser:(NSString *)aUsername{
    [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"%@与你解除了好友关系",aUsername]];
    [NotificationCenter postNotificationName:ContactRefresh object:nil];
}
//移除好友群组回调
- (void)dealloc{
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}
//SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
- (void)didJoinGroup:(EMGroup *)aGroup inviter:(NSString *)aInviter message:(NSString *)aMessage{
    [MBPManage showMessage:WIN message:[NSString stringWithFormat:@"你已加入%@",aGroup.subject]];
}

@end
