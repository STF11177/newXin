////
////  ConversationListController.m
////  xinBeiTeenEducation
////
////  Created by user on 2017/4/5.
////  Copyright © 2017年 user. All rights reserved.
////
//
//#import "ConversationListController.h"
//#import "chatController.h"
//#import "UserProfileManager.h"
//#import "chatViewModel.h"
//#import "addfriendController.h"
//
//#define kHaveUnreadAtMessage    @"kHaveAtMessage"
//#define kAtYouMessage           1
//#define kAtAllMessage           2
//
//@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>
//
//@property (nonatomic, strong) UIView *networkStateView;
//@property (nonatomic, assign) NSInteger messageCount;
//@property (nonatomic, assign) NSInteger systermCount;
//
//@end
//
//@implementation ConversationListController
//static NSString *userId;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.showRefreshHeader = YES;
//    self.delegate = self;
//    self.dataSource = self;
//    
//    [self networkStateView];
//    
//    //初始化页面
//    [self createNav];
//    [self tableViewDidTriggerHeaderRefresh];
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    userId = [userDefaults objectForKey:@"userName"];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self refresh];
//    [self removeEmptyConversationsFromDB];
//}
//
//-(void)createNav{
//
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.text = @"消息";
//    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable;
//    [self.navigationItem setHidesBackButton:YES];
//    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = item;
//}
//
//-(void)goBack{
//
//    [self.navigationController popViewControllerAnimated:NO];
//}
//
//- (void)removeEmptyConversationsFromDB
//{
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    NSMutableArray *needRemoveConversations;
//    for (EMConversation *conversation
//         in conversations) {
//        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
//            if (!needRemoveConversations) {
//                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
//            }
//            [needRemoveConversations addObject:conversation];
//        }
//    }
//    if (needRemoveConversations && needRemoveConversations.count > 0) {
//        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
//    }
//}
//
//#pragma mark - getter
//
//- (UIView *)networkStateView
//{
//    if (_networkStateView == nil) {
//        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
//        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
//        imageView.image = [UIImage imageNamed:@"messageSendFail"];
//        [_networkStateView addSubview:imageView];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
//        label.font = [UIFont systemFontOfSize:15.0];
//        label.textColor = [UIColor grayColor];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
//        [_networkStateView addSubview:label];
//    }
//    
//    return _networkStateView;
//}
//#pragma mark - EaseConversationListViewControllerDelegate
////点击进入聊天视图
//- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
//            didSelectConversationModel:(id<IConversationModel>)conversationModel
//{
//    if (conversationModel) {
//        EMConversation *conversation = conversationModel.conversation;
//        if (conversation) {
//            
//          chatController *chatVC = [[chatController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//            chatVC.titleName = conversationModel.title;
//            
//            [self.navigationController pushViewController:chatVC animated:NO];
//            
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//        [self.tableView reloadData];
//    }
//}
//
//#pragma mark - EaseConversationListViewControllerDataSource
//
//- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
//                                    modelForConversation:(EMConversation *)conversation
//{
//    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
//    
//    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
//    if (profileEntity) {
//        model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//        model.avatarURLPath = profileEntity.imageUrl;
//    }
//    return model;
//}
//
//- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
//                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
//{
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
//    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
//    if (lastMessage) {
//        NSString *latestMessageTitle = @"";
//        EMMessageBody *messageBody = lastMessage.body;
//        switch (messageBody.type) {
//            case EMMessageBodyTypeImage:{
//                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
//            } break;
//            case EMMessageBodyTypeText:{
//                // 表情映射。
//                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
//                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
//                latestMessageTitle = didReceiveText;
//                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
//                    latestMessageTitle = @"[动画表情]";
//                }
//            } break;
//            case EMMessageBodyTypeVoice:{
//                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
//            } break;
//            case EMMessageBodyTypeLocation: {
//                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
//            } break;
//            case EMMessageBodyTypeVideo: {
//                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
//            } break;
//            case EMMessageBodyTypeFile: {
//                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
//            } break;
//            default: {
//            } break;
//        }
//        
//        if (lastMessage.direction == EMMessageDirectionReceive) {
//            NSString *from = lastMessage.from;
//            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
//            if (profileEntity) {
//                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//            }
//            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
//        }
//        
//        NSDictionary *ext = conversationModel.conversation.ext;
//        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
//            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
//            
//        }
//        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
//            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
//        }
//        else {
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//        }
//    }
//    
//    return attributedStr;
//}
//
////发布的最近的时间
//- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
//       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
//{
//    NSString *latestMessageTime = @"";
//    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
//    if (lastMessage) {
//        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
//    }
//    
//    return latestMessageTime;
//}
//
//
//
////// 统计未读消息数
////- (void)setupUnreadMessageCount{
////    
////    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
////    _messageCount = 0;
////    for (EMConversation *conversation in conversations) {
////        _messageCount += conversation.unreadMessagesCount;
////    }
//////    if (_chatNavi) {
//////        if ((_messageCount+_systermCount) > 0) {
//////            _chatNavi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)(_messageCount+_systermCount)];
//////        }else{
//////            _chatNavi.tabBarItem.badgeValue = nil;
//////        }
//////    }
////    UIApplication *application = [UIApplication sharedApplication];
////    [application setApplicationIconBadgeNumber:(_messageCount+_systermCount)];
////}
//
//////好友请求变化时，更新好友请求未处理的个数
////- (void)reloadApplyView{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
////    
////    NSInteger count = [[addfriendController shareController] getUnapplyCount];
//////    self.unapplyCount = count;
////    [self.tableView reloadData];
////}
//
//#pragma mark - public
//
//-(void)refresh
//{
//    [self refreshAndSortView];
//}
//
//-(void)refreshDataSource
//{
//    [self tableViewDidTriggerHeaderRefresh];
//}
//
//- (void)isConnect:(BOOL)isConnect{
//    if (!isConnect) {
//        self.tableView.tableHeaderView = _networkStateView;
//    }
//    else{
//        self.tableView.tableHeaderView = nil;
//    }
//}
//
//- (void)networkChanged:(EMConnectionState)connectionState
//{
//    if (connectionState == EMConnectionDisconnected) {
//        self.tableView.tableHeaderView = _networkStateView;
//    }
//    else{
//        self.tableView.tableHeaderView = nil;
//    }
//}
//
//@end
