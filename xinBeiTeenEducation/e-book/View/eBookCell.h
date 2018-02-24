//
//  eBookCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/18.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eBookModel.h"

@interface eBookCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *eBookImgView;
@property(nonatomic,strong) eBookModel *model;

@end
