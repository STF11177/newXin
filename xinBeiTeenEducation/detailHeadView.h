//
//  detailHeadView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textDetailModel.h"

@interface detailHeadView : UIView

@property (nonatomic,strong) UILabel *topLb;//课程内容
@property (nonatomic,strong) UIImageView *headImgView;//头视图
@property (nonatomic,strong) UILabel *titleLb;//标题
@property (nonatomic,strong) UILabel *timeLb;//报名时间
@property (nonatomic,strong) UILabel *personHeadLb;//报名的人数
@property (nonatomic,strong) UIImageView *enrollImg;//报名的标记
@property (nonatomic,strong) UIView *sepeHeadView;
@property (nonatomic,strong) textDetailModel *model;

+ (instancetype)headView;

@end
