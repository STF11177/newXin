//
//  DetailCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textDetailListModel.h"

typedef void(^blockReturnSelectedBtn)(NSInteger index);

@interface DetailCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,strong) UIButton *categoryBtn;
@property (nonatomic,strong) UILabel *categoryLb;
@property (nonatomic,strong) UIView *sepeView;

@property (nonatomic,strong) textDetailListModel *listModel;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,copy) blockReturnSelectedBtn block;

- (void)blockReturnSelectedBtn:(blockReturnSelectedBtn)block;

@end
