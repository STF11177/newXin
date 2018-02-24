//
//  testdetailCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "allRecommentModel.h"
#import "copyLable.h"

@class testdetailCell;

@protocol testdetailCellDelegate <NSObject>

-(void)shareCell:(testdetailCell*)cell;

@end

@interface testdetailCell : UITableViewCell

@property (nonatomic,strong) copyLable *titleLale;
@property (nonatomic,strong) UILabel *testTiemLb;
@property (nonatomic,strong) UILabel *personLb;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) allRecommentModel *model;

@property (nonatomic,weak) id<testdetailCellDelegate> delegate;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic) NSIndexPath *indexpath;

@end
