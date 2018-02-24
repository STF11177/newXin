//
//  attionCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "namicInfoBeanModel.h"

@class attionCell;
@protocol attionCellDelegate <NSObject>

- (void)onDeleteOrderInCell:(attionCell *)cell;

@end

@interface attionCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *titilelable;
@property (strong, nonatomic) UILabel *contLable;
@property (strong, nonatomic) UIButton *deleteBtn;

@property (nonatomic, weak) id<attionCellDelegate> delegate;
@property (strong, nonatomic) namicInfoBeanModel *namicModel;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end







