////
////  chatController.m
////  xinBeiTeenEducation
////
////  Created by user on 2017/3/13.
////  Copyright © 2017年 user. All rights reserved.
////
//
//#import "chatController.h"
//#import "UserInfoModel.h"
////#import "EaseMessageModel.h"
//#import "UserManager.h"
//#import "ETMessageView.h"
//#import "messageSettingController.h"
//#import "UserProfileManager.h"
//#import "messageDetailController.h"
//
//@interface chatController()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,EMClientDelegate,UITextViewDelegate>
//
//{
//    UIMenuItem *_copyMenuItem;
//    UIMenuItem *_deleteMenuItem;
//    UIMenuItem *_transpondMenuItem;
//}
//
//@property (nonatomic,strong) UIImageView *backImage;
//@property (nonatomic,assign) BOOL isPlayingAudio;
//@property (nonatomic,strong) NSMutableDictionary *emoDic;
////@property (nonatomic,strong) UserInfoModel *userInfoModel;
//
//
//@end
//
//@implementation chatController
//static NSString *userId;
//
//-(void)viewDidLoad{
//    
//    [super viewDidLoad];
//    self.showRefreshHeader = YES;
//    self.delegate = self;
//    self.dataSource = self;
//    
//    [self initChatView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageFailNotification:) name:OtherNotAllowedRecived object:nil];;
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    userId = [userDefaults objectForKey:@"userName"];
//}
//
//
//-(void)initChatView{
//    
//    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame =CGRectMake(0, 0, 10, 19);
//    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = back;
//    
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 19)];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"personal"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(presentRightController:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = item;
//    
//    //设置背景泡
//    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_message_me.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:16]];
//    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_message_other.png"] stretchableImageWithLeftCapWidth:42 topCapHeight:16]];
//    
//    //设置头像大小
//    [[EaseBaseMessageCell appearance]setAvatarSize:46.f];
//    //设置头像圆角
//    [[EaseBaseMessageCell appearance]setAvatarCornerRadius:23.f];
//    [[EaseBaseMessageCell appearance]setMessageNameIsHidden:NO];
//    [EaseBaseMessageCell appearance].messageTextFont = kFontSize(14);
//    [EaseBaseMessageCell appearance].messageTextColor = COLOR_HEX(0x303859);
//    self.timeCellHeight = kScreenHeight*0.04;
//    
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//    self.view.backgroundColor = [UIColor clearColor];
//    self.chatToolbar.backgroundColor = [UIColor clearColor];
//}
//
//-(void)goBack{
//    
//    [self.navigationController popViewControllerAnimated:NO];
//}
//
//-(void)presentRightController:(UIViewController *)VC{
//    
//    messageSettingController *messageSetting = [[messageSettingController alloc]init];
//     messageSetting.taget_uid = self.from_uid;
//    [self.navigationController pushViewController:messageSetting animated:NO];
//}
//
//#pragma mark -EaseMessageViewControllerDataSource-------
//-(id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message{
//    
//    id<IMessageModel> model = nil;
//    model = [[EaseMessageModel alloc]initWithMessage:message];
//    model.avatarImage =[UIImage imageBundleNamed:@"ride_snap_default.png"];
//    
//    NSString *userStr = [NSString stringWithFormat:@"%@",userId];
//    if ([userStr isEqualToString:self.from_uid]) {
//        
//        model.isSender = YES;
//    }
//          
//    if (model.isSender) {
//        
//        model.avatarURLPath = @"http://106.14.251.200:80/olopicture/icon/10001201705201516501495264610622.jpg";
//        model.nickname = @"张波";
//    }else{
//   
//        model.avatarURLPath = self.faceImage;
//        model.nickname = self.titleName;
//        DDLog(@"%@",model.nickname);
//        model.failImageName = @"ride_snap_default.png";
//    }
//    return model;
//}
//
////获取用户点击头像回调的样例：
//- (void)messageViewController:(EaseMessageViewController *)viewController
//  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
//{
//    //UserProfileViewController用户自定义的个人信息视图
//    //样例的逻辑是选中消息头像后，进入该消息发送者的个人信息
//    
//    messageDetailController *detail = [[messageDetailController alloc]init];
//    if (messageModel.isSender) {
//        
//        detail.target_uid = self.from_uid;
//    }else{
//        
//        detail.target_uid = userId;
//    }
//    DDLog(@"%@",detail.target_uid);
//    [self.navigationController pushViewController:detail animated:NO];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.text = self.titleName;
//    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
//    lable.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lable;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
////    [self.userInfoModel cancelAllOperations];
////    self.userInfoModel.delegate = nil;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];//wohenganxia h
//}
//
//#pragma mark - *******************Main Method*************************
//- (IBAction)backMessageView:(UIButton *)sender {
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController{
//    NSMutableArray *emotions = [NSMutableArray array];
//    for (NSString *name in [EaseEmoji allEmoji]) {
//        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
//        [emotions addObject:emotion];
//    }
//    EaseEmotion *temp = [emotions objectAtIndex:0];
//    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
//    
//    return @[managerDefault];
//}
//
//- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
//                                    messageModel:(id<IMessageModel>)messageModel{
//    BOOL flag = NO;
//    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
//        return YES;
//    }
//    return flag;
//}
//
//- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
//                                      messageModel:(id<IMessageModel>)messageModel{
//    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
//    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
//    if (emotion == nil) {
//        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
//    }
//    return emotion;
//}
//
//- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
//                                        easeEmotion:(EaseEmotion*)easeEmotion{
//    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
//}
//
//#pragma mark - EaseMessageViewControllerDelegate
//
//- (BOOL)messageViewController:(EaseMessageViewController *)viewController
//   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
//
//- (BOOL)messageViewController:(EaseMessageViewController *)viewController
//   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    id object = [self.dataArray objectAtIndex:indexPath.row];
//    if (![object isKindOfClass:[NSString class]]) {
//        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        [cell becomeFirstResponder];
//        self.menuIndexPath = indexPath;
//        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
//    }
//    return YES;
//}
//
//
//#pragma mark - EMClientDelegate
//- (void)didLoginFromOtherDevice
//{
//    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
//        [self.imagePicker stopVideoCapture];
//    }
//}
//
//- (void)didRemovedFromServer
//{
//    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
//        [self.imagePicker stopVideoCapture];
//    }
//}
//
//#pragma mark - notification
//- (void)sendMessageFailNotification:(NSNotification *)notification{
//    id object = notification.object;
//    if (object) {
//        EMError *aError = (EMError *)object;
//        switch (aError.code) {
//            case EMErrorUserPermissionDenied:{
//                [[ETMessageView sharedInstance] showMessage:@"对方拒收了你的消息" onView:self.view withDuration:0.6];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    else{
//        [[ETMessageView sharedInstance] showMessage:@"你还不是对方好友能给对方发送消息" onView:self.view withDuration:0.6];
//    }
//}
//
//#pragma mark - private
//- (void)_showMenuViewController:(UIView *)showInView
//                   andIndexPath:(NSIndexPath *)indexPath
//                    messageType:(EMMessageBodyType)messageType{
//    
//    if (self.menuController == nil) {
//        self.menuController = [UIMenuController sharedMenuController];
//    }
//    
//    if (_deleteMenuItem == nil) {
//        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
//    }
//    
//    if (_copyMenuItem == nil) {
//        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
//    }
//    
//    if (messageType == EMMessageBodyTypeText) {
//        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
//        
//    } else if (messageType == EMMessageBodyTypeImage){
//        [self.menuController setMenuItems:@[_deleteMenuItem]];
//        
//    } else {
//        [self.menuController setMenuItems:@[_deleteMenuItem]];
//    }
//    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
//    [self.menuController setMenuVisible:YES animated:YES];
//}
//
//- (void)transpondMenuAction:(id)sender{
//    
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        NSLog(@"转发信息");
//    }
//    self.menuIndexPath = nil;
//}
//
//- (void)copyMenuAction:(id)sender{
//    
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
//        pasteboard.string = model.text;
//    }
//    
//    self.menuIndexPath = nil;
//}
//
//- (void)deleteMenuAction:(id)sender{
//    
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
//        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
//        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
//        
//        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
//        [self.messsagesSource removeObject:model.message];
//        
//        if (self.menuIndexPath.row - 1 >= 0) {
//            id nextMessage = nil;
//            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
//            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
//                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
//            }
//            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
//                [indexs addIndex:self.menuIndexPath.row - 1];
//                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
//            }
//        }
//        
//        [self.dataArray removeObjectsAtIndexes:indexs];
//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//        
//        if ([self.dataArray count] == 0) {
//            self.messageTimeIntervalTag = -1;
//        }
//    }
//    
//    self.menuIndexPath = nil;
//}
//
////#pragma mark -  ************UserInfoModelDelegate***********************
////- (UserInfoModel *)userInfoModel{
////    
////    if (!_userInfoModel) {
////        _userInfoModel = [[UserInfoModel alloc]initWithDelegate:self];
////    }
////    _userInfoModel.delegate = self;
////    return _userInfoModel;
////}
//
//- (void)getChatBackgroundSucc:(NSString *)result{
//    
//    [_backImage setImageWithURL:[NSURL URLWithString:result] placeholder:nil];
//}
//
//
//
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:OtherNotAllowedRecived object:nil];
//}
//
//@end
