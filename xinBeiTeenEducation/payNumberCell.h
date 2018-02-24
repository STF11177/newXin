//
//  payNumberCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class payNumberCell;
@protocol payNumberCellDelegate <NSObject>

-(void)addProductNumWith:(payNumberCell*)cell;
-(void)deleteProductNumWith:(payNumberCell*)cell;

@end

@interface payNumberCell : UITableViewCell

@property (nonatomic,strong) UILabel *headLb;

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *numberLb;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,weak) id<payNumberCellDelegate> delegate;

@end
