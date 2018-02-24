//
//  headCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mineModel.h"

@interface headCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel * titleLb;
@property (nonatomic,strong) UIImageView *arrowImg;
@property (nonatomic,strong) UIImageView *pointImg;

- (void)setCellWithModel:(mineModel *)model;

@end
