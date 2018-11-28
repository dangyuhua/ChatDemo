//
//  EMClientManage.m
//  demo
//
//  Created by 党玉华 on 2018/7/22.
//  Copyright © 2018年 Person. All rights reserved.
//

#import "EMClientManage.h"

@interface EMClientManage()

@end

@implementation EMClientManage
//初始化SDK
+(void)initSDK{
    EMOptions *options = [EMOptions optionsWithAppkey:EMOPTIONKey];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}
//注册用户
+(void)registerUserWithUserName:(NSString *)username password:(NSString *)password succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient] registerWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            failure(aError);
        }else{
            success(aUsername);
        }
    }];
}

//登录
+(void)loginEMClientSDKWithUsername:(NSString *)username password:(NSString *)password succeed:(successBlock)success failure:(errorBlock)failure{

    //判断是否设置了自动登录,自动登录属性默认是关闭的,自动登录在以下几种情况下会被取消
    //1.用户调用了SDK的登出动作;
    //2.用户在别的设备上更改了密码, 导致此设备上自动登陆失败;
    // 3.用户的账号被从服务器端删除;
    // 4.用户从另一个设备登录，把当前设备上登陆的用户踢出.
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        //登陆环信
//        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
//        if (!error) {
//            DLog(@"登录成功");
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//        }else{
//            failure(error);
//        }
//    }else{
//        DLog(@"自动登录成功");
//    }
    //登陆环信
    [[EMClient sharedClient] loginWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            DLog(@"登录成功");
            //设置自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}
//是否自动登录了
+(BOOL)isAutoLogin{
    //判断是否设置了自动登录,自动登录属性默认是关闭的,自动登录在以下几种情况下会被取消
    //1.用户调用了SDK的登出动作;
    //2.用户在别的设备上更改了密码, 导致此设备上自动登陆失败;
    // 3.用户的账号被从服务器端删除;
    // 4.用户从另一个设备登录，把当前设备上登陆的用户踢出.
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    return isAutoLogin;
}
//当前用户
+(NSString *)currentUsername{
    NSString *name = [EMClient sharedClient].currentUsername;
    return name;
}

//退出登录
+(void)logoutSucceed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient]logout:NO completion:^(EMError *aError) {
        if (aError) {
            failure(aError);
        }else{
            success(@"");
        }
    }];
}
//从服务器获取好友列表
+(void)getContactListFromServerSucceed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            success(aList);
        }else{
            failure(aError);
        }
    }];
}

//从DB获取好友列表
+(NSArray *)getContactListFromDB{
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    return userlist;
}

//添加好友
+(void)addContactList:(NSString *)username message:(NSString *)message succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager addContact:username message:message completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}

//同意好友请求
+(void)acceptAddContactWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:name completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}
//拒绝好友请求
+(void)declineAddContactWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:name completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}
//删除好友
+(void)delectContactWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager deleteContact:name isDeleteConversation:YES completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}

//从Server获取黑名单
+(void)getBlackContactListFromServerSucceed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager getBlackListFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            success(aList);
        }else{
            failure(aError);
        }
    }];
}

//从DB获取黑名单
+(NSArray *)getBlackContactListFromDB{
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    return blockList;
}
//移入黑名单
+(void)addUserToBlackListWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager addUserToBlackList:name completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}
//移出黑名单
+(void)removeUserFromBlackListWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].contactManager removeUserFromBlackList:name completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        }else{
            failure(aError);
        }
    }];
}
//获取所有会话
+(NSArray *)getAllConversations{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    return conversations;
}

//初始化EaseUI
+(void)initEaseUIWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:EMOPTIONKey
                                         apnsCertName:nil
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
}
//创建群组
+(void)creatGroupGroupName:(NSString *)groupName description:(NSString *)description ext:(NSString *)ext invitees:(NSMutableArray *)invitees message:(NSString *)message maxUsersCount:(int)maxUsersCount isInviteNeedConfirm:(BOOL)isInviteNeedConfirm style:(EMGroupStyle)style succeed:(successBlock)success failure:(errorBlock)failure{
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = maxUsersCount;
    setting.IsInviteNeedConfirm = isInviteNeedConfirm; //邀请群成员时，是否需要发送邀请通知.若NO，被邀请的人自动加入群组
    setting.style = style;// 创建不同类型的群组，这里需要才传入不同的类型
    setting.ext = ext;
    [[EMClient sharedClient].groupManager createGroupWithSubject:groupName description:description invitees:invitees message:message setting:setting completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            success(aGroup);
        }else{
            failure(aError);
        }
    }];
}
//退出群组
+(void)quitGroupWithGroupID:(NSString *)groupID succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager leaveGroup:groupID completion:^(EMError *aError) {
        if (!aError) {
            success(nil);
        }else{
            failure(aError);
        }
    }];
}
//邀请人进群
+(void)inviteFriendJoinFGroup:(NSMutableArray *)aOccupants toGroup:(NSString *)aGroupId message:(NSString *)message succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager addMembers:aOccupants toGroup:aGroupId message:message completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            success(aGroup);
        }else{
            failure(aError);
        }
    }];
}
//删除群组成员
+(void)delectMemberFromGroup:(NSMutableArray *)aOccupants toGroup:(NSString *)aGroupId succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager removeMembers:aOccupants fromGroup:aGroupId completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            success(aGroup);
        }else{
            failure(aError);
        }
    }];
}
//申请进群
+(void)requestJoinFGroupToGroup:(NSString *)aGroupId message:(NSString *)message succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager requestToJoinPublicGroup:aGroupId message:message completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            success(aGroup);
        }else{
            failure(aError);
        }
    }];
}
//获取所有群组从网络
+(void)getAllGroupsFromServeSucceed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:1 pageSize:50 completion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            success(aList);
        }else{
            failure(aError);
        }
    }];
}
//获取所有群组从内存
+(NSArray*)getAllGroups{
    NSArray *array = [[EMClient sharedClient].groupManager getJoinedGroups];
    return array;
}
//解散群聊
+(void)delectGroupWithGroupId:(NSString *)groupId succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager destroyGroup:groupId finishCompletion:^(EMError *aError) {
        if (!aError) {
            success(nil);
        }else{
            failure(aError);
        }
    }];
}
//获取未读消息数
+(int)getUnreadMSGCount{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    int unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}
//发送文字信息
+(void)sendMessage:(NSString *)msg conversationID:(NSString *)conversationID aTo:(NSString *)aTo ext:(NSDictionary *)ext chatType:(EMChatType )chatType{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:msg];
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationID from:from to:aTo body:body ext:ext];
    message.chatType = chatType;
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *aMessage, EMError *aError) {
        
    }];
}
//消息发送
+(void)sendMessage:(EMMessage *)message succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        DLog(@"%d",progress);
    } completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            success(aMessage);
        }else{
            failure(aError);
        }
    }];
}
//标注未读消息数
+(void)showUnreadMSGCount{
    int unreadCount = [EMClientManage getUnreadMSGCount];
    UITabBarController *tabbar = (UITabBarController *)WIN.rootViewController;
    if ( unreadCount > 0) {
        [tabbar.tabBar showBadgeOnItemIndex:0 title:[NSString stringWithFormat:@"%d",unreadCount]];
    }else{
        [tabbar.tabBar hideBadgeOnItemIndex:0];
    }
}
//获取群组详情
+(void)getGroupDetailsWithAGroupID:(NSString *)aGroupID succeed:(successBlock)success failure:(errorBlock)failure{
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:aGroupID completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            success(aGroup);
        }else{
            failure(aError);
        }
    }];
}
//透传消息发送
+(void)sendCMDmsgWithAction:(NSString *)action chatType:(EMChatType)chatType conversationID:(NSString *)conversationID messageExt:(NSDictionary *)messageExt succeed:(successBlock)success failure:(errorBlock)failure{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:action];
    NSString *from = [[EMClient sharedClient] currentUsername];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationID from:from to:conversationID body:body ext:messageExt];
    message.chatType = chatType;
    //message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            success(aMessage);
        }else{
            failure(aError);
        }
    }];
}


@end
