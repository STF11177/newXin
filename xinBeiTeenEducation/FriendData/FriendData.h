//
//  FriendData.h
//  Bike
//
//  Created by Enjoytouch on 16/5/27.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "ETBaseData.h"

@interface FriendData : ETBaseData

//用户ID
@property (nonatomic,copy) NSString *memberId;
//环信账号
@property (nonatomic,copy) NSString *hxAccount;
//用户昵称
@property (nonatomic,copy) NSString *nickName;
//头像
@property (nonatomic,copy) NSString *snap;
//在不在对方好友列表里
@property (nonatomic,copy) NSString *trueFriend;

@property (nonatomic,copy) NSString *friendStatus;

@end
