//
//  instroduceCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "allRecommentModel.h"
#import "copyLable.h"

@interface instroduceCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) copyLable *contentLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) allRecommentModel *model;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic) NSIndexPath *indexpath;

@end
