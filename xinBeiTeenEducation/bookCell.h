//
//  bookCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eduBookModel.h"

@interface bookCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bookImageView;
@property (nonatomic,strong) YYLabel *titleLable;
@property (nonatomic,strong) UILabel *authorLb;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UILabel *saleLb;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) eduBookModel *model;
@property (nonatomic) NSIndexPath *indexpath;

@end
