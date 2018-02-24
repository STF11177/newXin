//
//  orderCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "allorderModel.h"
#import "orderFootView.h"

@class orderCell;
@protocol orderCellDelegate <NSObject>

- (void)onDeleteOrderInCell:(orderCell *)cell;
- (void)onBeforeTestInCell:(orderCell *)cell;
- (void)onTestDownLoadingInCell:(orderCell *)cell;
- (void)onCheckScoreInCell:(orderCell *)cell;

@end

@interface orderCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLb;//标题
@property (nonatomic,strong) UILabel *completeLb;//支付状态
@property (nonatomic,strong) UIImageView *deleteImg;//删除图标

@property (nonatomic,strong) UILabel *levelLb;//级别
@property (nonatomic,strong) UILabel *nameLb;//考生姓名
@property (nonatomic,strong) UILabel *timeLb;//报名时间
@property (nonatomic,strong) UILabel *priceLb;//考试价格
@property (nonatomic,strong) UILabel *testTimeLb;//考试时间
@property (nonatomic,strong) UILabel *testPlace;//考试地点
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UIView *lineView;//分割线
@property (nonatomic,strong) orderFootView *footView;//分割线

@property (nonatomic,weak) id<orderCellDelegate> delegate;
@property (nonatomic,strong) allorderModel *model;
@property (nonatomic) NSIndexPath *indexPath;

@end
