//
//  TableViewCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messDetailModel.h"

@class TableViewCell;
@protocol tableViewCellDelegate <NSObject>

- (void)onDefaultInCell:(TableViewCell *)cell;

@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *textLable1;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) messDetailModel *messageModel;
@property (nonatomic, weak) id<tableViewCellDelegate> delegate;
@property (nonatomic) NSIndexPath *indexPath;

-(void)setCellInfowithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withArrow:(BOOL )isHas;

@end
