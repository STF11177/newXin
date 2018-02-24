//
//  noAttentionCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "noAttionModel.h"

@class noAttentionCell;
@protocol  noAttionCellDelete <NSObject>

-(void)addAttentionInCell:(noAttentionCell*)cell;

@end

@interface noAttentionCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *titilelable;
@property (strong, nonatomic) UILabel *contLable;
@property (strong, nonatomic) UIButton *addButton;

@property (nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) noAttionModel *noAtendModel;
@property (weak, nonatomic) id<noAttionCellDelete> delegate;

@end
