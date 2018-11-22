//
//  ChatVC.m
//  demo
//
//  Created by 党玉华 on 2018/7/22.
//  Copyright © 2018年 Person. All rights reserved.
//

#import "ChatVC.h"
#import "GroupManageVC.h"
#import "PersonInfo.h"

@interface ChatVC ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,UIGestureRecognizerDelegate,EaseChatBarMoreViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>

@property(nonatomic,strong)EaseTextView *textfield;

@end

@implementation ChatVC

//设置视图滑动手势
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //刷新未读消息
    [EMClientManage showUnreadMSGCount];
    [NotificationCenter postNotificationName:RefreshEMClient object:nil];
    // rootViewController要关闭返回手势，否则有BUG
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //当群聊有人@时，没点击会话列表@一直显示，反之消失
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"em_at_list"] length]){
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:@"em_at_list"];
            [newExt setObject:@"2" forKey:@"isread"];
            self.conversation.ext = newExt;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //滑动手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //上拉刷新
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.navigationItem.leftBarButtonItem = [QuickCreate UIBarButtonItemNavBackBarButtonItemWithTarget:self action:@selector(pop)];
    self.tableView.backgroundColor = RGB(239, 239, 239);
    [self setupBottomTools];
    
    //如果是群聊，进来此VC先更新群员,防止@时群员显示bug
    if (self.conversation.type == EMConversationTypeGroupChat) {
        GCD_GLOBAL_QUEUE_ASYNC(^{
            [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
                DLog(@"%lu",(unsigned long)aGroup.occupants.count);
                if (!aError) {
                    [[EMClient sharedClient].groupManager getGroupMemberListFromServerWithId:self.conversation.conversationId cursor:nil pageSize:aGroup.occupantsCount completion:^(EMCursorResult *aResult, EMError *aError) {
                        DLog(@"%lu",(unsigned long)aGroup.occupants.count);
                    }];
                }
            }];
        });
        self.navigationItem.rightBarButtonItem =[QuickCreate UIBarButtonItemBarButtonWithTarget:self action:@selector(rightNavClick) frame:Frame(0, 0, 35, 18) title:@"群员" image:nil selectImage:nil font:17 textColor:whiteColor edgeInsets:UIEdgeInsetsZero];
    }
}

-(void)rightNavClick{
    GroupManageVC *vc = [[GroupManageVC alloc]init];
    vc.groupID = self.conversation.conversationId;
    [self pushVC:vc];
}

//遍历拿到底部输入框
-(EaseTextView *)textfield
{
    if (!_textfield) {
        for(UIView*view in self.chatToolbar.subviews){
            for(UIView*subview in view.subviews){
                if ([subview isKindOfClass:[EaseTextView class]]) {
                    _textfield = (EaseTextView *)subview;
                    break;
                }
            }
        }
    }
    return _textfield;
}
//是否允许长按
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//触发长按手势
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

//发送文字消息
- (void)sendTextMessage:(NSString *)text{
    if (self.conversation.type == EMConversationTypeGroupChat) {
        GCD_GLOBAL_QUEUE_ASYNC(^{
            if ([text containsString:@"@"]) {
                // 通过获取群详情获取群组成员
                [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
                    NSMutableArray *items = [[NSMutableArray alloc]init];
                    for (int i=0; i<aGroup.occupants.count; i++) {
                        NSString *str = aGroup.occupants[i];
                        if ([text containsString:str]) {
                            //不能@自己
                            DLog(@"%@",[EMClientManage currentUsername]);
                            if (![str containsString:[EMClientManage currentUsername]]) {
                                [items addObject:str];
                            }
                        }
                    }
                    NSDictionary *ext = @{@"em_at_list":items};
                    [self sendTextMessage:text withExt:ext];
                }];
            }else{
                [self sendTextMessage:text withExt:nil];
            }
        });
    }else if (self.conversation.type == EMConversationTypeChat){
        [self sendTextMessage:text withExt:nil];
    }else{
        [self sendTextMessage:text withExt:nil];
    }
}
//消息已读回调
//- (void)messageViewController:(EaseMessageViewController *)viewController
// didReceiveHasReadAckForModel:(id<IMessageModel>)messageModel{
//
//}
//@对象回调
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback{
    if (self.conversation.type == EMConversationTypeGroupChat) { //群聊
        
    }else{ //单聊
        return;
    }
}
//获取用户点击头像回调的样例：
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel{
    if ([[EMClientManage currentUsername] isEqualToString:messageModel.message.from]) {
        return;
    }
    if (self.conversation.type == EMConversationTypeGroupChat) {
        ChatVC *vc = [[ChatVC alloc]initWithConversationChatter:messageModel.message.from conversationType:EMConversationTypeChat];
        vc.title = messageModel.message.from;
        [self pushVC:vc];
    }else if (self.conversation.type == EMConversationTypeChat){
        PersonInfo *vc = [[PersonInfo alloc]init];
        vc.hxid = self.conversation.conversationId;
        [self pushVC:vc];
    }
}

//底部功能栏
-(void)setupBottomTools{
//    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"defaultImage"] highlightedImage:[UIImage imageNamed:@"defaultImage"] title:@"视频"];
}
//自定义功能代理
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index{
//    if (index == 5) {
//        [self photoVideo];
//        [MBPManage showMessage:self.view message:[NSString stringWithFormat:@"%@,%@",self.conversation.conversationId,self.title]];
//        [self.chatToolbar endEditing:YES];
//    }
}
//拨打实时通话
- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView{
    [MBPManage showMessage:self.view message:self.conversation.conversationId];
}
//相册方法重写
- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView{
    UIAlertController *c = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self emSDKPhotoAction];
    }];
    UIAlertAction *video = [UIAlertAction actionWithTitle:@"相册视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoVideo];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [c addAction:photo];
    [c addAction:video];
    [c addAction:cancel];
    [self presentViewController:c animated:YES completion:nil];
}
//环信SDK相册方法
-(void)emSDKPhotoAction{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    // Pop image picker
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
}
//相册视频
-(void)photoVideo{
    [self.chatToolbar endEditing:YES];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes =[NSArray arrayWithObjects: (NSString *)kUTTypeMovie, nil];
    //imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
    imagePickerController.videoQuality=UIImagePickerControllerQualityTypeMedium;
    imagePickerController.navigationBar.translucent = NO;//去除毛玻璃效果
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
-(void)popVC:(Class)aClass{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:aClass]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

@end
