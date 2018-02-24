//
//  FriendListData.m
//  Bike
//
//  Created by Enjoytouch on 16/5/27.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "FriendListData.h"

@implementation FriendListData

- (NSArray *)columns {
    return @[
             @{@"key":@"status",@"prop":@"status",@"class":@"NSString"},
             @{@"key":@"total",@"prop":@"total",@"class":@"NSString"},
             @{@"key":@"data",@"prop":@"data",@"class":@"FriendData"}
             ];
}

@end
