////
////  UserProfileManager.h
////  Bike
////
////  Created by Enjoytouch on 16/5/27.
////  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
////
//
//#import "BaseModel.h"
//#import "FriendData.h"
//@interface UserManager : BaseModel
//
//+ (instancetype)sharedInstance;
//
////添加好友信息
//- (void)addUserProfileToLocal:(FriendData *)friendData;
////添加多个好友信息
//- (void)addUserProfileToLocalFriendsData:(NSArray *)friendsData;
////根据username获取当前用户昵称
//- (NSString*)getNickNameWithUsername:(NSString*)username;
////根据环信账号获取信息
//- (FriendData *)getUserProfileFromCoreDataByHxAccount:(NSString *)hxAccount;
////根据环信账号获取免打扰状态
//- (NSString *)getDisturbStatusHxAccount:(NSString *)hxAccount;
////根据环信账号设置免打扰状态
//- (void)setDisturb:(NSString *)disturb withFriend:(FriendData *)friendData;
////从本地获取全部用户好友信息
//- (NSMutableArray *)getAllUserProfileFromCoreData;
////清空缓存
//- (void)clearAllLocalByHxAccount:(NSString *)hxAccount;
////清空全部缓存
//- (void)clearAllLocal;
//
//@end
//
