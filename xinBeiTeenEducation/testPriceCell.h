//
//  testPriceCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textDetailListModel.h"

@interface testPriceCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *headLb;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) textDetailListModel *detailModel;

@property (nonatomic) NSIndexPath *indexpath;

@end
