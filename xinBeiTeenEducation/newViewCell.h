//
//  newViewCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/8.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fooView.h"
#import "menuListModel.h"
#import "newStatusModel.h"
#import "YHWorkGroupPhotoContainer.h"
#import "ETRegularUtil.h"
#import "copyLable.h"

@class newViewCell;
@protocol newCellDelegate <NSObject>

- (void)onAvatarInCell:(newViewCell *)cell;
- (void)onMoreInCell:(newViewCell *)cell;
- (void)onCommentInCell:(newViewCell *)cell;
- (void)onLikeInCell:(newViewCell *)cell;
- (void)onShareInCell:(newViewCell *)cell;
- (void)onPulldownInCell:(newViewCell *)cell;

@optional
- (void)onDeleteInCell:(newViewCell *)cell;

@end

@interface newViewCell : UITableViewCell

@property (nonatomic,strong) menuListModel *menuListModel;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic, weak) id<newCellDelegate> delegate;
@property (nonatomic,strong)fooView  *viewBottom;

@property (nonatomic,strong)UIImageView *imgvAvatar; //头像 imgvAvatar
@property (nonatomic,strong)UILabel     *labelName; //姓名 labelName
@property (nonatomic,strong)UIImageView *imgSex; //性别 labelIndustry
@property (nonatomic,strong)UIImageView *imgArrow; // labelPubTime
@property (nonatomic,strong)UILabel     *timeLable; //labelCompany
@property (nonatomic,strong)UILabel     *labelJob; //小升初
@property (nonatomic,strong)copyLable    *labelContent;//内容
@property (nonatomic,strong)UILabel     *labelDelete;//删除
@property (nonatomic,strong)UILabel     *labelMore;//展开 收起

/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);

@property (nonatomic,strong)UIImageView   *backImageView;
@property (nonatomic,strong)UIButton   *playBtn;
@property (nonatomic,strong)UIBlurEffect   *blur;

@property (nonatomic,strong) YHWorkGroupPhotoContainer *picContainerView;
@property (nonatomic,strong) UIView      *viewSeparator;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *contLb;

@end

