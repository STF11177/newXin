//
//  FriendData.m
//  Bike
//
//  Created by Enjoytouch on 16/5/27.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "FriendData.h"

@implementation FriendData

- (NSArray *)columns {
    return @[
             @{@"key":@"id",@"prop":@"memberId",@"class":@"NSString"},
             @{@"key":@"hx_account",@"prop":@"hxAccount",@"class":@"NSString"},
             @{@"key":@"nick_name",@"prop":@"nickName",@"class":@"NSString"},
             @{@"key":@"snap",@"prop":@"snap",@"class":@"NSString"},
             @{@"key":@"true_friend",@"prop":@"trueFriend",@"class":@"NSString"},
             @{@"key":@"friend_status",@"prop":@"friendStatus",@"class":@"NSString"}
             
             ];
}

@end
