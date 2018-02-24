//
//  detailHeadCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eduDetailModel.h"

@class detailHeadCell;
@protocol detailHeadDelegate <NSObject>

-(void)addProductNumWith:(detailHeadCell*)cell;
-(void)deleteProductNumWith:(detailHeadCell*)cell;

@end

@interface detailHeadCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *introduceLb;
@property (nonatomic,strong) UILabel *saleLb;
@property (nonatomic,strong) UILabel *originPriceLb;
@property (nonatomic,strong) UIImageView *detailImage;
@property (nonatomic,strong) UIButton *signBtn;

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *numberLb;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) eduDetailModel *model;

@property (nonatomic,strong) UILabel *expressLb;//快递
@property (nonatomic,strong) UILabel *monthSaleLb;//月销
@property (nonatomic,strong) UILabel *addressLb;//地点

@property (nonatomic,weak) id<detailHeadDelegate> delegate;

@end
