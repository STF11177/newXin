//
//  commentView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bugCommentModel.h"

@class commentView;

@protocol commentViewDelegate <NSObject>

- (void)onTapCommentCell;

@end

@interface commentView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) bugCommentModel *model;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,assign) CGFloat cellHeight;
//@property (nonatomic,assign) CGFloat tableViewHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,weak) id<commentViewDelegate>delegate;

@end
