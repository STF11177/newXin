//
//  eduOrderCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"

@class eduOrderCell;

@protocol eduOrderdelegate <NSObject>

-(void)deleteInCell:(eduOrderCell*)cell;

@end

@interface eduOrderCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *authorLb;
@property (nonatomic,strong) UILabel *orginPriceLb;//原价
@property (nonatomic,strong) UIButton *realBtn;
@property (nonatomic,strong) UILabel *saleLb;//售价
@property (nonatomic,strong) UILabel *countLb;
@property (nonatomic,strong) UILabel *statusLb;//支付的状态
@property (nonatomic,strong) UILabel *sumLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) orderModel *model;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id<eduOrderdelegate> delegate;

@end
