//
//  commentCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bugCommentModel.h"

@interface commentCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;

- (void)configCellWithModel:(bugCommentModel *)model;

@end
