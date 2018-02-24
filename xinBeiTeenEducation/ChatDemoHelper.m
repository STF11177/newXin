///************************************************************
// *  * Hyphenate CONFIDENTIAL
// * __________________
// * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
// *
// * NOTICE: All information contained herein is, and remains
// * the property of Hyphenate Inc.
// * Dissemination of this information or reproduction of this material
// * is strictly forbidden unless prior written permission is obtained
// * from Hyphenate Inc.
// */
//
//#import "ChatDemoHelper.h"
//#import "AppDelegate.h"
//#import "addfriendController.h"
//#import "MBProgressHUD.h"
//
//static ChatDemoHelper *helper = nil;
//
//@implementation ChatDemoHelper
//
//+ (instancetype)shareHelper
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        helper = [[ChatDemoHelper alloc] init];
//    });
//    return helper;
//}
//
//- (void)dealloc
//{
//    [[EMClient sharedClient] removeDelegate:self];
//    [[EMClient sharedClient].roomManager removeDelegate:self];
//    [[EMClient sharedClient].chatManager removeDelegate:self];
//    [[EMClient sharedClient].contactManager removeDelegate:self];
//}
//
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self initHelper];
//    }
//    return self;
//}
//
//- (void)initHelper
//{
//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
//    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
//    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
//
//}
//
//- (void)asyncPushOptions
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = nil;
//        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
//    });
//}
//
//- (void)asyncConversationFromDB
//{
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
//        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
//            if(conversation.latestMessage == nil){
//                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
//            }
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakself.conversationListVC) {
//                [weakself.conversationListVC refreshDataSource];
//                [weakself.conversationListVC setupUnreadMessageCount];
//            }
//            
//        });
//    });
//}
//
//#pragma mark - EMClientDelegate
//
//// 网络状态变化回调
//- (void)didConnectionStateChanged:(EMConnectionState)connectionState
//{
//    [self.conversationListVC networkChanged:connectionState];
//}
//
//- (void)autoLoginDidCompleteWithError:(EMError *)error
//{
//    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.tag = 100;
//        [alertView show];
//    } else if([[EMClient sharedClient] isConnected]){
//        UIView *view = self.conversationListVC.view;
//        [MBProgressHUD showHUDAddedTo:view animated:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            BOOL flag = [[EMClient sharedClient] migrateDatabaseToLatestSDK];
//            if (flag) {
//             
//                [self asyncConversationFromDB];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:view animated:YES];
//            });
//        });
//    }
//}
//
//- (void)userAccountDidLoginFromOtherDevice
//{
//    [self _clearHelper];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//}
//
//- (void)userAccountDidRemoveFromServer
//{
//    [self _clearHelper];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//}
//
//#pragma mark - EMChatManagerDelegate
//
//- (void)didUpdateConversationList:(NSArray *)aConversationList
//{
//    if (self.conversationListVC) {
//        [self.conversationListVC setupUnreadMessageCount];
//    }
//    
//    if (self.conversationListVC) {
//        [_conversationListVC refreshDataSource];
//    }
//}
//
//- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages{
//
//    for (EMMessage *message in aCmdMessages) {
//        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
//        NSLog(@"收到的action是 -- %@",body.action);
//        if ([body.action hasPrefix:@"{"] && [body.action hasSuffix:@"}"]) {
//
//        }
//    }
//}
//
//- (void)didReceiveMessages:(NSArray *)aMessages
//{
//    BOOL isRefreshCons = YES;
//    for(EMMessage *message in aMessages){
//        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
//        
//        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//        if (needShowNotification) {
//#if !TARGET_IPHONE_SIMULATOR
////            switch (state) {
////                case UIApplicationStateActive:
////                    [self.mainVC playSoundAndVibration];
////                    break;
////                case UIApplicationStateInactive:
////                    [self.mainVC playSoundAndVibration];
////                    break;
////                case UIApplicationStateBackground:
////                    [self.mainVC showNotificationWithMessage:message];
////                    break;
////                default:
////                    break;
////            }
//#endif
//        }
//        
//        if (_chatVC == nil) {
//            _chatVC = [self _getCurrentChatView];
//        }
//        BOOL isChatting = NO;
//        if (_chatVC) {
//            isChatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
//        }
//        if (_chatVC == nil || !isChatting || state == UIApplicationStateBackground) {
//            [self _handleReceivedAtMessage:message];
//            
//            if (self.conversationListVC) {
//                [_conversationListVC refresh];
//            }
//            
//            if (self.conversationListVC) {
//                [_conversationListVC setupUnreadMessageCount];
//            }
//            return;
//        }
//        
//        if (isChatting) {
//            isRefreshCons = NO;
//        }
//    }
//    
//    if (isRefreshCons) {
//        if (self.conversationListVC) {
//            [_conversationListVC refresh];
//        }
//        
//        if (self.conversationListVC) {
//            [self.conversationListVC setupUnreadMessageCount];
//        }
//    }
//}
//
//- (void)_handleReceivedAtMessage:(EMMessage*)aMessage
//{
//    if (aMessage.chatType != EMChatTypeGroupChat || aMessage.direction != EMMessageDirectionReceive) {
//        return;
//    }
//    
//    NSString *loginUser = [EMClient sharedClient].currentUsername;
//    NSDictionary *ext = aMessage.ext;
//    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:aMessage.conversationId type:EMConversationTypeGroupChat createIfNotExist:NO];
//    if (loginUser && conversation && ext && [ext objectForKey:kGroupMessageAtList]) {
//        id target = [ext objectForKey:kGroupMessageAtList];
//        if ([target isKindOfClass:[NSString class]] && [(NSString*)target compare:kGroupMessageAtAll options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//            NSNumber *atAll = conversation.ext[kHaveUnreadAtMessage];
//            if ([atAll intValue] != kAtAllMessage) {
//                NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
//                [conversationExt removeObjectForKey:kHaveUnreadAtMessage];
//                [conversationExt setObject:@kAtAllMessage forKey:kHaveUnreadAtMessage];
//                conversation.ext = conversationExt;
//            }
//        }
//        else if ([target isKindOfClass:[NSArray class]]) {
//            if ([target containsObject:loginUser]) {
//                if (conversation.ext[kHaveUnreadAtMessage] == nil) {
//                    NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
//                    [conversationExt setObject:@kAtYouMessage forKey:kHaveUnreadAtMessage];
//                    conversation.ext = conversationExt;
//                }
//            }
//        }
//    }
//}
//
//
//- (chatController*)_getCurrentChatView
//{
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_conversationListVC.navigationController.viewControllers];
//    chatController *chatViewContrller = nil;
//    for (id viewController in viewControllers)
//    {
//        if ([viewController isKindOfClass:[chatController class]])
//        {
//            chatViewContrller = viewController;
//            break;
//        }
//    }
//    return chatViewContrller;
//}
//
//
//#pragma mark - EMContactManagerDelegate
//
////用户B删除与用户A的好友关系后，用户A会收到这个回调
//- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
//{
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_conversationListVC.navigationController.viewControllers];
//    chatController *chatContrller = nil;
//    for (id viewController in viewControllers)
//    {
//        if ([viewController isKindOfClass:[chatController class]] && [aUsername isEqualToString:[(chatController *)viewController conversation].conversationId])
//        {
//            chatContrller = viewController;
//            break;
//        }
//    }
//    if (chatContrller)
//    {
//        [viewControllers removeObject:chatContrller];
//        if ([viewControllers count] > 0) {
//            [_conversationListVC.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
//        } else {
//            [_conversationListVC.navigationController setViewControllers:viewControllers animated:YES];
//        }
//    }
//    [_conversationListVC showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), aUsername]];
//}
//
////用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
//- (void)didReceiveAddedFromUsername:(NSString *)aUsername{
//}
////用户B申请加A为好友后，用户A会收到这个回调
//- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
//                                       message:(NSString *)aMessage
//{
//    if (!aUsername) {
//        return;
//    }
//    
//    if (!aMessage) {
//        aMessage = @"请求加为好友";
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
//    [[addfriendController shareController] addNewApply:dic];
//    if (self.conversationListVC) {
//#if !TARGET_IPHONE_SIMULATOR
////        [self.conversationListVC playSo？undAndVibration];
//        
//        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
//        if (!isAppActivity) {
//            //发送本地推送
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date]; //触发通知的时间
//            notification.alertBody = @"请求加为好友";
//            notification.alertAction = NSLocalizedString(@"open", @"Open");
//            notification.timeZone = [NSTimeZone defaultTimeZone];
//        }
//#endif
//    }
//    [_conversationListVC reloadApplyView];
//}
//
//#pragma mark - EMChatroomManagerDelegate
//
//- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
//                            username:(NSString *)aUsername
//{
//    
//}
//
//- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
//                            username:(NSString *)aUsername
//{
//
//}
//
//- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
//                              reason:(EMChatroomBeKickedReason)aReason
//{
//    
//}
//
//#pragma mark - private
//- (BOOL)_needShowNotification:(NSString *)fromChatter
//{
//    BOOL ret = YES;
//    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
//    for (NSString *str in igGroupIds) {
//        if ([str isEqualToString:fromChatter]) {
//            ret = NO;
//            break;
//        }
//    }
//    return ret;
//}
//
//
//
//- (void)_clearHelper
//{
//    self.conversationListVC = nil;
//    self.chatVC = nil;
//    
//    [[EMClient sharedClient] logout:NO];
//}
//
//
//#pragma  mark - ***************发送透传消息********************
//- (void)sendCmdMessageWithReceive:(NSString *)hxAccount{
//    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"CircleMessage"];
//    NSString *from = [[EMClient sharedClient] currentUsername];
//    EMMessage *message = [[EMMessage alloc]initWithConversationID:@"6001" from:from to:hxAccount body:body ext:nil];
//     message.chatType = EMChatTypeChat;// 设置为单聊消息
//    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
//        NSLog(@"**************%@",error);
//    }];
//}
//@end
