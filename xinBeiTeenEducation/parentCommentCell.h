//
//  parentCommentCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parentDiscusstView.h"
#import "parentdiscussModel.h"
#import "YHWorkGroupPhotoContainer.h"
#import "parentdiscussModel.h"

@class parentCommentCell;
@protocol parentCommentDelegate <NSObject>

- (void)onImageInCell:(parentCommentCell *)cell;
- (void)onCommentInCell:(parentCommentCell *)cell;
- (void)onCheckInCell:(parentCommentCell *)cell;

@end

@interface parentCommentCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgvAvatar; //头像 imgvAvatar
@property (nonatomic,strong)UILabel     *labelName; //姓名 labelName
@property (nonatomic,strong)UIImageView *imgSex; //性别 labelIndustry
@property (nonatomic,strong)UILabel     *timeLable; //labelCompany
@property (nonatomic,strong)UILabel     *labelContent;//内容
//@property (nonatomic,strong)UIButton    *likeBtn;//点赞
//@property (nonatomic,strong)UIButton    *comemntBtn;//评论
@property (nonatomic,strong)UILabel     *checkLb;//查看
@property (nonatomic,strong)parentdiscussModel *model;

//@property (nonatomic,strong) parentdiscussModel *model;
@property (nonatomic,strong) parentDiscusstView *picContainerView;
@property (nonatomic, weak) id<parentCommentDelegate> delegate;

@end
