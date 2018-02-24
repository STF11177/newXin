//
//  messageDetailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messDetailModel.h"

@interface messageDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *messageDetailTableView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) messDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *target_uid;

@property (strong, nonatomic, readonly) NSString *username;
- (instancetype)initWithUsername:(NSString *)username;

@end
