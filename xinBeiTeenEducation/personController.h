//
//  personController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "newController.h"
#import "YHRefreshTableView.h"
#import "SGTopTitleView.h"

@interface personController : UIViewController

@property (nonatomic,strong) UILabel *navTitle;
@property (nonatomic,strong) YHRefreshTableView *refreshTableView;
@property (nonatomic,strong) SGTopTitleView *titleView;
@property (nonatomic,strong) NSString *artCount;
@property (nonatomic,strong) NSMutableArray *personArray;

@property (nonatomic,strong) NSString *target_uid;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *faceImge;

@end
