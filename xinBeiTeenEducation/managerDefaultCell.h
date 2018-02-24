//
//  managerDefaultCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkAddressModel.h"

@class managerDefaultCell;
@protocol managerDefaultCellDelegate <NSObject>

-(void)defaultAddress:(managerDefaultCell*)cell;
-(void)deleteAddress:(managerDefaultCell*)cell;
-(void)editAddress:(managerDefaultCell*)cell;

@end

@interface managerDefaultCell : UITableViewCell

@property (nonatomic,strong) UIButton *defaultBtn;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,weak) id<managerDefaultCellDelegate> delegate;
@property (nonatomic,strong) checkAddressModel *model;
@property (nonatomic) NSIndexPath *indexPath;

@end
