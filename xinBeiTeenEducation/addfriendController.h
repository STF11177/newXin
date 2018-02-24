//
//  addfriendController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
    ApplyStyleAgreedFriend,
}ApplyStyle;

@interface addfriendController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}

//状态  0、是好友 1、待通过的好友    2是黑名单  3、已添加好友等待好友通过
@property (nonatomic,strong)UITableView *addfriendTableView;
@property (nonatomic,strong,readonly) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString *target_uid;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (NSUInteger)getUnapplyCount;

- (void)clear;


@end
