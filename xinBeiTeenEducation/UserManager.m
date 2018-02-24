////
////  UserProfileManager.m
////  Bike
////
////  Created by Enjoytouch on 16/5/27.
////  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
////
//
//#import "UserManager.h"
//#import "FriendEntity.h"
//#import "ETCoreDataManager.h"
//#import "AppDataCenter.h"
////#import "MemberData.h"
////#import "SBJson.h"
//static UserManager *sharedInstance = nil;
//
//@implementation UserManager
//
//+ (instancetype)sharedInstance{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}
//
////添加好友信息
//- (void)addUserProfileToLocal:(FriendData *)friendData{
//    
//    FriendEntity *entity = [self getFromLocalByHxAccount:friendData.hxAccount];
//    if (entity == nil) {
//        entity = (FriendEntity *)[[ETCoreDataManager sharedInstance]createObjectWithEntityName:@"Friend"];
//    }
//    
////    entity = [self setEntity:entity withData:friendData];
//    [[ETCoreDataManager sharedInstance] saveContext];
//}
////添加多个好友信息
//- (void)addUserProfileToLocalFriendsData:(NSArray *)friendsData{
//
//    for (FriendData *friendData in friendsData) {
//        
//        [self addUserProfileToLocal:friendData];
//    }
//}
//
////从CoreData取到ID
//- (FriendEntity *)getFromLocalByHxAccount:(NSString *)hxAccount{
//    
//    NSString *condition = [NSString stringWithFormat:@"hxAccount='%@'",hxAccount];
//    FriendEntity *entity = (FriendEntity *)[[ETCoreDataManager sharedInstance] getOneWithEntity:@"Friend"
//                                                                                      predicate:condition
//                                                                                           sort:nil
//                                                                                      ascending:NO];
//    return entity;
//}
//
//////设置
////- (FriendEntity *)setEntity:(FriendEntity *)entity withData:(FriendData *)data{
////    
////    MemberData *memberInfo = [AppDataCenter getLoginMember];
////    if (![ETRegularUtil isEmptyString:memberInfo.memberId]) {
////        entity.userId = memberInfo.memberId;
////    }
////    if (![ETRegularUtil isEmptyString:data.hxAccount]) {
////        entity.hxAccount = data.hxAccount;
////    }
////    if (![ETRegularUtil isEmptyString:[data toJson]]) {
////        entity.friendJson = [data toJson];
////    }
////    return entity;
////}
//
////根据username获取当前用户昵称
//- (NSString*)getNickNameWithUsername:(NSString*)username{
//    
//    FriendEntity* entity = [self getUserProfileByUsername:username];
//    if (entity.nickName && entity.nickName.length > 0) {
//        return entity.nickName;
//    } else {
//        return username;
//    }
//}
//
//- (FriendEntity *)getUserProfileByUsername:(NSString *)userName{
//    
//    NSString *condition = [NSString stringWithFormat:@"nickName='%@'",userName];
//    FriendEntity *entity = (FriendEntity *)[[ETCoreDataManager sharedInstance] getOneWithEntity:@"Friend"
//                                                                                      predicate:condition
//                                                                                           sort:nil
//                                                                                      ascending:NO];
//    return entity;
//}
//
////根据环信账号获取信息
//- (FriendData *)getUserProfileFromCoreDataByHxAccount:(NSString *)hxAccount{
//    
//    NSString *condition = nil;
//    if (![ETRegularUtil isEmptyString:hxAccount]) {
//        condition = [NSString stringWithFormat:@"hxAccount='%@'",hxAccount];
//    }
//    NSArray *entityArray = [[ETCoreDataManager sharedInstance] fetchObjectsWithEntity:@"Friend"
//                                                                            predicate:condition
//                                                                                 sort:nil
//                                                                            ascending:NO];
//    FriendData *friendData = [[FriendData alloc] init];
//    for (FriendEntity *entity in entityArray) {
//        friendData = [self getData:[[entity valueForKey:@"friendJson"] JSONValue] class:@"FriendData"];
//    }
//    return friendData;
//}
//
//
//- (NSString *)getDisturbStatusHxAccount:(NSString *)hxAccount{
//    FriendEntity *entity = [self getFromLocalByHxAccount:hxAccount];
//    if (entity!=nil) {
//        return entity.disturb;
//    }
//    return nil;
//}
//
////根据环信账号设置免打扰状态
//- (void)setDisturb:(NSString *)disturb withFriend:(FriendData *)friendData{
//    
//    FriendEntity *entity = [self getFromLocalByHxAccount:friendData.hxAccount];
//    if (entity == nil) {
//        entity = (FriendEntity *)[[ETCoreDataManager sharedInstance]createObjectWithEntityName:@"Friend"];
//    }
//    
////    entity = [self setEntity:entity withData:friendData];
//    entity.disturb = disturb;
//    [[ETCoreDataManager sharedInstance] saveContext];
//}
//
//////从本地获取全部用户好友信息
//- (NSMutableArray *)getAllUserProfileFromCoreData{
////
////    MemberData *memberInfo = [AppDataCenter getLoginMember];
////    NSString *condition = nil;
////    if (![ETRegularUtil isEmptyString:memberInfo.memberId]) {
////        condition = [NSString stringWithFormat:@"userId=%@",memberInfo.memberId];
////    }
////    NSArray *entityArray = [[ETCoreDataManager sharedInstance] fetchObjectsWithEntity:@"Friend"
////                                                                            predicate:condition
////                                                                                 sort:nil
////                                                                            ascending:NO];
////    NSMutableArray *result = [NSMutableArray arrayWithCapacity:entityArray.count];
////    
////    for (FriendEntity *entity in entityArray) {
////        FriendData *friendData = [[FriendData alloc] init];
////        friendData= [self getData:[[entity valueForKey:@"friendJson"] JSONValue] class:@"FriendData"];
////        [result addObject:friendData];
////    }
//    return 0;
//}
//
//////清空缓存
//- (void)clearAllLocalByHxAccount:(NSString *)hxAccount{
////
////    MemberData *memberInfo = [AppDataCenter getLoginMember];
////    NSString *condition = [NSString stringWithFormat:@"hxAccount='%@' and userId='%@'",hxAccount,memberInfo.memberId];
////    NSArray *entityArray = [[ETCoreDataManager sharedInstance] fetchObjectsWithEntity:@"Friend"
////                                                                            predicate:condition
////                                                                                 sort:nil
////                                                                            ascending:NO];
////    for (FriendEntity *entity in entityArray) {
////        if (entity) {
////            [[ETCoreDataManager sharedInstance] deleteManagedObject:entity];
////        }
////    }
////    [[ETCoreDataManager sharedInstance] saveContext];
////    
//}
////清空全部缓存
//- (void)clearAllLocal{
////
////    MemberData *memberInfo = [AppDataCenter getLoginMember];
////    NSString *condition = [NSString stringWithFormat:@"userId='%@'",memberInfo.memberId];
////    NSArray *entityArray = [[ETCoreDataManager sharedInstance] fetchObjectsWithEntity:@"Friend"
////                                                                            predicate:condition
////                                                                                 sort:nil
////                                                                            ascending:NO];
////    for (FriendEntity *entity in entityArray) {
////        if (entity) {
////            [[ETCoreDataManager sharedInstance] deleteManagedObject:entity];
////        }
////    }
////    [[ETCoreDataManager sharedInstance] saveContext];
////    
//}
//
//@end
