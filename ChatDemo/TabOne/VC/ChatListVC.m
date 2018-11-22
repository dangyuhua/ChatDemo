//
//  ChatListVC.m
//  ChatDemo
//
//  Created by 党玉华 on 2018/11/20.
//  Copyright © 2018年 dyh绝地求生专业送快递. All rights reserved.
//

#import "ChatListVC.h"
#import "ChatVC.h"


@interface ChatListVC ()<EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation ChatListVC

//设置视图滑动手势
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // rootViewController要关闭返回手势，否则有BUG
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTableview];
    //内存中刷新页面
    [self refreshAndSortView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupConfig];
    self.title = @"消息";
    //代理
    self.delegate = self;
    self.dataSource = self;
    self.tableView.backgroundColor = RGB(239, 239, 239);
    //下拉刷新会话列表
    self.showRefreshHeader = YES;
    //首次进入加载数据
    [self refreshTableview];
    //刷新未读消息
    [EMClientManage showUnreadMSGCount];
    
    //刷新界面和tab的badge
    [NotificationCenter addObserver:self selector:@selector(refreshTableview) name:RefreshEMClient object:nil];
    GCD_AFTER(1.0, ^{
        [self refreshAndSortView];
    });
}

//会话列表刷新
-(void)refreshTableview{
    //加载会话列表 移除空对话
    [self removeEmptyConversationsFromDB];
}

//会话列表点击的回调样例
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    EMConversation *conversation = conversationModel.conversation;
    ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
    vc.title = conversationModel.title;
    [self pushVC:vc];
}
//最后一条消息展示内容样例
- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                DLog(@"%@,%@",lastMessage.ext[@"em_at_list"],lastMessage.ext[@"isread"]);
                if (lastMessage.ext[@"em_at_list"] != nil&&[lastMessage.ext[@"isread"]isEqualToString:@"1"]) {
                    NSArray *array = lastMessage.ext[@"em_at_list"];
                    NSMutableDictionary *e = [NSMutableDictionary dictionaryWithDictionary:lastMessage.ext];
                    [e removeObjectForKey:@"em_at_list"];
                    [e removeObjectForKey:@"isread"];
                    conversationModel.conversation.latestMessage.ext = e;
                    for (int i=0; i<array.count; i++) {
                        if ([[EMClientManage currentUsername] isEqualToString:array[i]]) {
                            NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversationModel.conversation.ext];
                            [ext setObject:[EMClientManage currentUsername] forKey:@"em_at_list"];
                            [ext setObject:@"1" forKey:@"isread"];
                            conversationModel.conversation.ext = ext;
                        }
                    }
                }
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
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
            } break;
        }
    }
    if (conversationModel.conversation.ext[@"em_at_list"] != nil&&[conversationModel.conversation.ext[@"isread"]isEqualToString:@"1"]&&conversationModel.conversation.unreadMessagesCount!=0) {
        attr = [QuickCreate NSMutableAttributedStringColorConfigText:[NSString stringWithFormat:@"[有人@我] %@",latestMessageTitle] textColor:redColor range:NSMakeRange(0, 6)];
    }else{
        attr = [[NSMutableAttributedString alloc]initWithString:latestMessageTitle attributes:nil];
    }
    return attr;
}
//最后一条消息展示时间样例
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}
//设置用户头像昵称
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (conversation.type == EMConversationTypeGroupChat) {
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
    }else if(conversation.type == EMConversationTypeChat){
        
    }else if(conversation.type == EMConversationTypeChatRoom){
        
    }
    return model;
}
//加载会话列表 移除空对话
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:^(EMError *aError) {
            if (!aError) {
                [self tableViewDidTriggerHeaderRefresh];
            }
        }];
    }else{
        //加载
        [self tableViewDidTriggerHeaderRefresh];
    }
}


-(void)pushVC:(UIViewController *)vc{
    if (self.navigationController.viewControllers.firstObject != vc) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popToRootVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)popVC:(UIViewController *)vc{
    [self.navigationController popToViewController:vc animated:YES];
}
//配置基本信息
-(void)setupConfig{
    //状态栏文本颜色白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //滑动手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationController.navigationBar.backgroundColor = RGB(53, 53, 53);
    self.navigationController.navigationBar.barTintColor = RGB(53, 53, 53);
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:whiteColor}];
}


@end
