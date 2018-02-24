//
//  discussDetailCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailCommentModel.h"

@class discussDetailCell;
@protocol discussDetailDelegate <NSObject>

- (void)replyBtnInCell:(discussDetailCell *)cell;
- (void)likeInCell:(discussDetailCell *)cell;
- (void)deleteInCell:(discussDetailCell *)cell;

@end

@interface discussDetailCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *headLb;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) detailCommentModel *model;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id<discussDetailDelegate> delegate;

-(CGFloat)cellHeightWithModel:(detailCommentModel *)model;

@end
