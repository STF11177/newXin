//
//  interDiscussCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "interDiscussPhotoView.h"
#import "interDisscussModel.h"
#import "interPhotoView.h"
#import "SDWeiXinPhotoContainerView.h"

@class interDiscussCell;
@protocol interDiscussCellDelegate <NSObject>

- (void)likeInCell:(interDiscussCell *)cell;

@end

@interface interDiscussCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *jobLb;
@property(nonatomic,strong) UIButton *likeBtn;
@property(nonatomic,strong) UIButton *pullBtn;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UILabel *likeCountLb;
@property(nonatomic,strong) UILabel *discussCountLb;
@property(nonatomic,strong) interDiscussPhotoView *photoContainer;
@property(nonatomic,strong) interDisscussModel *model;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) NSArray *imageArray;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id<interDiscussCellDelegate> delegate;

-(CGFloat)cellHeightWithModel:(interDisscussModel *)model;

@end
