//
//  testfiCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messDetailModel.h"

@class testfiCell;
@protocol testfiCellDelegate <NSObject>

-(void)xiuGaiBeizhuInCell:(testfiCell*)cell;

@end

@interface testfiCell : UITableViewCell

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *sexView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIButton *beizhuBtn;//修改备注
@property (nonatomic,strong) UILabel *nickLable;//昵称的内容
@property (nonatomic,strong) UILabel *nameLable;//昵称
@property (nonatomic,strong) UIView *vepeView;

@property (nonatomic,weak) id<testfiCellDelegate> delegate;
@property (nonatomic,strong) messDetailModel *messageMdoel;

@end
