////
////  UserInfoModel.m
////  Bike
////
////  Created by Enjoytouch on 16/5/26.
////  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
////
//
//#import "UserInfoModel.h"
//
//@implementation UserInfoModel
//
////好友申请批准
//- (void)friendsToApplyForApprovalWithParams:(NSDictionary *)params{
//    
//    [self createRequest:@"chat/allow_friend"
//              withParam:params
//              finishSel:@selector(allowAddFriendSucc)
//                failSel:@selector(allowAddFriendFail:)];
//}
//
////添加好友
//- (void)addFriendWithParams:(NSDictionary *)params{
//    
//    [self createRequest:@"chat/add_friend"
//              withParam:params
//              finishSel:@selector(addFriendSucc:)
//                failSel:@selector(addFriendFail:)
//                dataObj:@"AddFriendData"];
//}
//
////删除好友
//- (void)deleteFriendWithParams:(NSDictionary *)params{
//    
//    [self createRequest:@"chat/delete_friend"
//              withParam:params
//              finishSel:@selector(deleteFriendSucc)
//                failSel:@selector(deleteFriendFail:)];
//}
//
////好友列表
//- (void)getFriendListFromServer{
//    
//    [self createRequest:@"user/user_friend"
//              withParam:nil
//              finishSel:@selector(showFriendListSucc:)
//                failSel:@selector(showFriendListFail:)
//                dataObj:@"FriendListData"];
//
//}
//
////获取个人主页信息
////- (void)getUserInfoWithUserId:(NSString *)userId{
////    
////    NSMutableDictionary *params = [NSMutableDictionary dictionary];
////    [params setValue:userId forKey:@"id"];
////    [self createRequest:@"live/homepage"
////              withParam:params
////              finishSel:@selector(getUserInfoSucc:)
////                failSel:@selector(getUserInfoFail:)
////                dataObj:@"PersonData"];
////}
//
////我的首页信息
////- (void)getMyInfo{
////    NSMutableDictionary *params = [NSMutableDictionary dictionary];
////    [self createPostRequest:@"user/index"
////              withParam:params
////              finishSel:@selector(getMyInfoSucc:)
////                failSel:@selector(getMyInfoFail:)
////                dataObj:@"UserData"];
////}
//
////环信账号获取用户信息
//- (void)getUserInfoWithParams:(NSDictionary *)params{
//    
//    [self createPostRequest:@"chat/getUserInfo"
//              withParam:params
//              finishSel:@selector(getUserInfoByHxAccountSucc:)
//                failSel:@selector(getUserInfoByHxAccountFail:)
//                dataObj:@"FriendListData"];
//    
//}
//
////用户搜索
//- (void)searchFriendWithParams:(NSDictionary *)params{
//
//    [self createRequest:@"chat/search"
//                  withParam:params
//                  finishSel:@selector(searchFriendSucc:)
//                    failSel:@selector(searchFriendFail:)
//                    dataObj:@"FriendListData"];
//}
//
////连接设备
//- (void)connectDeviceWithCode:(NSString *)code{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:code forKey:@"bike_code"];
//    [self createRequest:@"user/bind_bike"
//              withParam:params
//              finishSel:@selector(connectDeviceSucc)
//                failSel:@selector(connectDeviceFail:)];
//}
//
////添加绑定设备
//- (void)addDeviceWithCode:(NSString *)code{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:code forKey:@"bike_code"];
//    [self createRequest:@"user/add_bike"
//              withParam:params
//              finishSel:@selector(addDeviceSucc)
//                failSel:@selector(addDeviceFail:)];
//}
//
////上传聊天背景图
//- (void)addChatBackgroundImage:(NSDictionary *)params{
//    [self createRequest:@"chat/save_chat_background"
//              withParam:params
//              finishSel:@selector(addChatBackgroundSucc)
//                failSel:@selector(addChatBackgroundFail:)];
//}
//
//
//
//
//
////关注列表
//- (void)getAttenListWithParams:(NSDictionary *)params{
//    
//       [self createPostRequest:@"live/get_follows"
//              withParam:params
//              finishSel:@selector(getFansListSucc:)
//                failSel:@selector(getFansListFail:)
//                dataObj:@"AttentResultData"];
//}
//
////关注或取消关注
//- (void)followOrNotWithParams:(NSDictionary *)params{
//    
//    [self createPostRequest:@"live/follow"
//                  withParam:params
//                  finishSel:@selector(followOrNotSucc:)
//                    failSel:@selector(followOrNotFail:)
//                    dataObj:@"AttentData"];
//}
//
//
//
//@end
