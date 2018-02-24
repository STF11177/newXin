//
//  bugCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bugPhotoView.h"
#import "commentView.h"
#import "bugListModel.h"
#import "bugCommentModel.h"
#import "copyLable.h"

@class bugCell;

@protocol bugCellDelegate <NSObject>

- (void)onDeleteInCell:(bugCell *)cell;
- (void)onCommentInCell:(bugCell *)cell;
//- (void)onCommentInCell:(bugCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)selectBugId:(NSString *)bugId selectBugStatus:(NSString*)status;

@end

@interface bugCell : UITableViewCell

@property (nonatomic,strong) copyLable *titleLb;
@property (nonatomic,strong) UIButton *statusBtn;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *imgCountLb;

@property (nonatomic,strong) UIView *sepView;//分割线
@property (nonatomic,strong) UIView *bugGroundView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) bugPhotoView *bugImgView;
@property (nonatomic) NSIndexPath *indexpath;

@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat bugCommentHeight;
@property (nonatomic) CGFloat tableViewHeight;
     
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) commentView *commentView;
//@property (nonatomic,strong) bugListModel *bugModel;
@property (nonatomic,strong) bugCommentModel *model;

@property (nonatomic, weak) id<bugCellDelegate> delegate;

- (CGFloat)cellHeight:(bugListModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)configCellWithModel:(bugListModel *)model indexPath:(NSIndexPath *)indexPath;

@end
