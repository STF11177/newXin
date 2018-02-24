//
//  replyCommentCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "replyCommentModel.h"
#import "copyLable.h"

@class replyCommentCell;
@protocol replyCommentDelegate <NSObject>

- (void)onAvatarInCell:(replyCommentCell *)cell;
- (void)onLikeInCell:(replyCommentCell *)cell;

@end

@interface replyCommentCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgvAvatar; //头像 imgvAvatar
@property (nonatomic,strong)UILabel     *labelName; //姓名 labelName
@property (nonatomic,strong)UIImageView *imgSex; //性别 labelIndustry
@property (nonatomic,strong)UILabel     *timeLable; //labelCompany
@property (nonatomic,strong)copyLable   *labelContent;//内容
@property (nonatomic,strong)UIButton    *likeBtn;//点赞
@property (nonatomic) NSIndexPath  *indexPath;
@property (nonatomic,strong)replyCommentModel  *replyModel;//点赞
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic, weak) id<replyCommentDelegate> delegate;

@end
