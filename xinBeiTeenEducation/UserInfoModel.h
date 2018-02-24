////
////  UserInfoModel.h
////  Bike
////
////  Created by Enjoytouch on 16/5/26.
////  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
////
//
//#import "BaseModel.h"
////#import "AttentResultData.h"
//#import "FriendListData.h"
//#import "AddFriendData.h"
////#import "PersonData.h"
////#import "UserData.h"
//
//@interface UserInfoModel : BaseModel
//
////好友申请批准
//- (void)friendsToApplyForApprovalWithParams:(NSDictionary *)params;
//
////添加好友
//- (void)addFriendWithParams:(NSDictionary *)params;
//
////删除好友
//- (void)deleteFriendWithParams:(NSDictionary *)params;
//
////好友列表
//- (void)getFriendListFromServer;
//
////个人主页
////- (void)getUserInfoWithUserId:(NSString *)userId;
//
////我的首页信息
////- (void)getMyInfo;
//
////环信账号获取用户信息
//- (void)getUserInfoWithParams:(NSDictionary *)params;
//
////用户搜索
//- (void)searchFriendWithParams:(NSDictionary *)params;
//
////用户连接设备
//- (void)connectDeviceWithCode:(NSString *)code;
//
////添加绑定设备
//- (void)addDeviceWithCode:(NSString *)code;
//
////上传聊天背景图
//- (void)addChatBackgroundImage:(NSDictionary *)params;
//
////获取聊天背景图片
//- (void)getChatBackgroundImage:(NSDictionary *)params;
//
////粉丝列表
////- (void)getFansListWithParams:(NSDictionary *)params;
//
////关注列表
//- (void)getAttenListWithParams:(NSDictionary *)params;
//
////关注或取消关注
//- (void)followOrNotWithParams:(NSDictionary *)params;
//
////粉丝贡献榜
////- (void)getFansContributionListWithParams:(NSDictionary *)params;
//@end
//
//@protocol UserInfoDelegate <NSObject>
//
//@optional
//
//- (void)allowAddFriendSucc;
////- (void)allowAddFriendFail:(ErrorData *)error;
//
//- (void)addFriendSucc:(AddFriendData *)result;
////- (void)addFriendFail:(ErrorData *)error;
//
//- (void)deleteFriendSucc;
////- (void)deleteFriendFail:(ErrorData *)error;
//
//- (void)showFriendListSucc:(FriendListData *)result;
////- (void)showFriendListFail:(ErrorData *)error;
//
////- (void)getUserInfoSucc:(PersonData *)result;
////- (void)getUserInfoFail:(ErrorData *)error;
//
//- (void)getUserInfoByHxAccountSucc:(FriendListData *)result;
////- (void)getUserInfoByHxAccountFail:(ErrorData *)error;
//
////- (void)getMyInfoSucc:(UserData *)result;
////- (void)getMyInfoFail:(ErrorData *)error;
//
//- (void)searchFriendSucc:(FriendListData *)result;
////- (void)searchFriendFail:(ErrorData *)error;
//
//- (void)connectDeviceSucc;
////- (void)connectDeviceFail:(ErrorData *)error;
//
//- (void)addDeviceSucc;
////- (void)addDeviceFail:(ErrorData *)error;
//
//- (void)addChatBackgroundSucc;
////- (void)addChatBackgroundFail:(ErrorData *)error;
//
//- (void)getChatBackgroundSucc:(NSString *)result;
////- (void)getChatBackgroundFail:(ErrorData *)error;
//
////- (void)getFansListSucc:(AttentResultData *)result;
////- (void)getFansListFail:(ErrorData *)error;
////
////- (void)followOrNotSucc:(AttentData *)result;
////- (void)followOrNotFail:(ErrorData *)error;
//
//
//@end
