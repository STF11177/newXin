//
//  FriendListData.h
//  Bike
//
//  Created by Enjoytouch on 16/5/27.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "ETBaseData.h"
#import "FriendData.h"
@interface FriendListData : ETBaseData

//总数
@property (nonatomic,copy) NSString *total;
//状态
@property (nonatomic,copy) NSString *status;
//topic
@property (nonatomic,strong) NSArray  *data;

@end
