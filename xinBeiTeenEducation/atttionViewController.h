//
//  atttionViewController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "noAttionModel.h"
#import "namicInfoBeanModel.h"

@interface atttionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *attionTableView;

@property (nonatomic,strong) NSMutableArray *attenedArray;
@property (nonatomic,strong) NSMutableArray *noAttenedArray;
@property (nonatomic,strong) noAttionModel *noAttionModel;
@property (nonatomic,strong) namicInfoBeanModel *attenModel;

@end
