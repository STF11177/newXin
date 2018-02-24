//
//  textualResearchCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "allRecommentModel.h"
#import "copyLable.h"

@class textualResearchCell;
@protocol textualCellDelegate <NSObject>

- (void)pressBtn:(textualResearchCell *)cell;

@end

@interface textualResearchCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UILabel *personLb;
@property (nonatomic,strong) UIImageView *signView;
@property (nonatomic,strong) UIButton *signButton;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,weak) id<textualCellDelegate> delegate;
@property (nonatomic,strong) allRecommentModel *allModel;
@property (nonatomic) NSIndexPath *indexpath;

@property (nonatomic) NSIndexPath *indexPath;

@end
