//
//  FriendEntity.h
//  Bike
//
//  Created by Enjoytouch on 16/5/27.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface FriendEntity : NSManagedObject

@property (nonatomic,strong) NSString *friendJson;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *hxAccount;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *disturb;

@end
