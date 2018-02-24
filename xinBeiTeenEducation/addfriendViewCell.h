//
//  addfriendViewCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addfriendController.h"
#import "InvitationManager.h"
#import "chatViewModel.h"

@protocol addfriendViewCellDelegate;

@interface addfriendViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIButton *jieShouBtn;//接受按钮
@property (strong, nonatomic) UILabel *nameLable;//名字
@property (strong, nonatomic) UILabel *contentLable;//详情
@property (strong, nonatomic) UIImageView *headView;//头像
@property (nonatomic,weak) id <addfriendViewCellDelegate> delegate;
@property (strong, nonatomic) chatViewModel *chatModel;


+ (CGFloat)heightWithContent:(NSString *)content;

- (void)setApplyEntity:(ApplyEntity *)entity ApplyStyle:(ApplyStyle)applyStyle;

@end

@protocol addfriendViewCellDelegate <NSObject>

- (void)applyCellAddFriendCell:(addfriendViewCell *)cell;


@end
