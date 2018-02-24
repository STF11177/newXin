//
//  hotCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hotArticleModel.h"
#import "YHWorkGroupPhotoContainer.h"

@interface hotCell : UITableViewCell

@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *commentLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) hotArticleModel *hotModel;
@property (nonatomic) NSIndexPath *indexpath;

@end
