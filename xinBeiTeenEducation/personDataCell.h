//
//  personDataCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class personDataCell;
@protocol personDataDelegate <NSObject>

-(void)pressHeadView:(personDataCell*)cell;

@end

@interface personDataCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *headLb;
@property (nonatomic,strong) UIImageView *arrowImg;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<personDataDelegate> delegate;

@end
