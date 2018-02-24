//
//  messageCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageModel.h"

@interface messageCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImgView;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UIImageView *pictureView;
@property(nonatomic,strong) messageModel *model;

@end
