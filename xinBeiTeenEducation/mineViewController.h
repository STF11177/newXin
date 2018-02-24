//
//  mineViewController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface mineViewController :BaseController

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *faaceImage;

@end
