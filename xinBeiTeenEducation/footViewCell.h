//
//  footViewCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class footViewCell;
@protocol  footViewCellDelete <NSObject>

-(void)payFootView;
-(void)commentFootCell:(footViewCell*)cell;
-(void)collectFootCell:(footViewCell*)cell;
-(void)likeFootCell:(footViewCell*)cell;

@end

@interface footViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIView *sepeView;

@property (nonatomic, weak) id<footViewCellDelete> delegate;

@end
