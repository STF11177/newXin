//
//  testTimeCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "copyLable.h"
#import "textDetailModel.h"

@interface testTimeCell : UITableViewCell

@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) copyLable *planLb;
@property (nonatomic,strong) copyLable *endTimeLb;
@property (nonatomic,strong) copyLable *testTimeLb;
@property (nonatomic,strong) copyLable *priceLb;
@property (nonatomic,strong) copyLable *adressLb;
@property (nonatomic,strong) copyLable *admissionCardLb;
@property (nonatomic,strong) textDetailModel *detailModel;

@end
