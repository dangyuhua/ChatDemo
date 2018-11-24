//
//  EMClientManage.h
//  demo
//
//  Created by 党玉华 on 2018/7/22.
//  Copyright © 2018年 Person. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock) (id data);
typedef void(^errorBlock) (EMError *aError);

@interface EMClientManage : NSObject
//初始化
+(void)initSDK;
//注册用户
+(void)registerUserWithUserName:(NSString *)username password:(NSString *)password succeed:(successBlock)success failure:(errorBlock)failure;
//登录
+(void)loginEMClientSDKWithUsername:(NSString *)username password:(NSString *)password succeed:(successBlock)success failure:(errorBlock)failure;
//是否自动登录了
+(BOOL)isAutoLogin;
//当前用户
+(NSString *)currentUsername;
//退出登录
+(void)logoutSucceed:(successBlock)success failure:(errorBlock)failure;
//从服务器获取好友列表
+(void)getContactListFromServerSucceed:(successBlock)success failure:(errorBlock)failure;
//从DB获取好友列表
+(NSArray *)getContactListFromDB;
//添加好友
+(void)addContactList:(NSString *)username message:(NSString *)message succeed:(successBlock)success failure:(errorBlock)failure;
//同意好友请求
+(void)acceptAddContactWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure;
//拒绝好友请求
+(void)declineAddContactWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure;
//删除好友
+(void)delectContactWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure;
//从Server获取黑名单
+(void)getBlackContactListFromServerSucceed:(successBlock)success failure:(errorBlock)failure;
//从DB获取黑名单
+(NSArray *)getBlackContactListFromDB;
//移入黑名单
+(void)addUserToBlackListWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure;
//移出黑名单
+(void)removeUserFromBlackListWithName:(NSString *)name succeed:(successBlock)success failure:(errorBlock)failure;
//获取所有会话
+(NSArray *)getAllConversations;
//初始化EaseUI
+(void)initEaseUIWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions;
//创建群组
+(void)creatGroupGroupName:(NSString *)groupName description:(NSString *)description ext:(NSString *)ext invitees:(NSMutableArray *)invitees message:(NSString *)message maxUsersCount:(int)maxUsersCount isInviteNeedConfirm:(BOOL)isInviteNeedConfirm style:(EMGroupStyle)style succeed:(successBlock)success failure:(errorBlock)failure;
//邀请人进群
+(void)inviteFriendJoinFGroup:(NSMutableArray *)aOccupants toGroup:(NSString *)aGroupId message:(NSString *)message succeed:(successBlock)success failure:(errorBlock)failure;
//删除群组成员
+(void)delectMemberFromGroup:(NSMutableArray *)aOccupants toGroup:(NSString *)aGroupId succeed:(successBlock)success failure:(errorBlock)failure;
//申请进群
+(void)requestJoinFGroupToGroup:(NSString *)aGroupId message:(NSString *)message succeed:(successBlock)success failure:(errorBlock)failure;
//获取所有群组从网络
+(void)getAllGroupsFromServeSucceed:(successBlock)success failure:(errorBlock)failure;
//获取所有群组从内存
+(NSArray*)getAllGroups;
//解散群聊
+(void)delectGroupWithGroupId:(NSString *)groupId succeed:(successBlock)success failure:(errorBlock)failure;
//获取未读消息数
+(int)getUnreadMSGCount;
//文字消息发送
+(void)sendMessage:(NSString *)msg conversationID:(NSString *)conversationID aTo:(NSString *)aTo ext:(NSDictionary *)ext chatType:(EMChatType )chatType;
//消息发送
+(void)sendMessage:(EMMessage *)message succeed:(successBlock)success failure:(errorBlock)failure;
//标注未读消息数
+(void)showUnreadMSGCount;
//获取群组详情
+(void)getGroupDetailsWithAGroupID:(NSString *)aGroupID succeed:(successBlock)success failure:(errorBlock)failure;
//透传消息发送
+(void)sendCMDmsgWithAction:(NSString *)action chatType:(EMChatType)chatType conversationID:(NSString *)conversationID messageExt:(NSDictionary *)messageExt succeed:(successBlock)success failure:(errorBlock)failure;
@end
