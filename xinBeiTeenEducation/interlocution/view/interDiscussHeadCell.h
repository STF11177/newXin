//
//  interDiscussHeadCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "interPhotoView.h"
#import "interDisscussHeadModel.h"

@class interDiscussHeadCell;
@protocol discussHeadCellDelegate <NSObject>

- (void)exprandInCell:(interDiscussHeadCell *)cell;

@end

@interface interDiscussHeadCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UIButton *expressBtn;
@property (nonatomic,strong) interPhotoView *photoContainer;
//@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) interDisscussHeadModel *model;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id<discussHeadCellDelegate> delegate;

-(CGFloat)cellHeightWith:(NSString*)imgStr isOpen:(BOOL)isOpen;
-(void)setModel:(interDisscussHeadModel *)model isOpen:(BOOL)isOpen;

@end
