//
//  managerDetailCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkAddressModel.h"

@interface managerDetailCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *phoneLb;
@property (nonatomic,strong) UILabel *addressLb;
@property (nonatomic,strong) checkAddressModel *model;
@property (nonatomic) NSIndexPath *indexPath;

@end
