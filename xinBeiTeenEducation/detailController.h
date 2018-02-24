//
//  detailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailController : UIViewController

@property (nonatomic,strong) NSString *subjectId;
@property (nonatomic,strong) NSString *activityTitle;

@property (nonatomic,assign) float headHeight;
@property (nonatomic,assign) float subjectHeight;//课程介绍高度
@property (nonatomic,strong) NSString *fromWhere;//从选择地址的界面进行跳转
@property (nonatomic,strong) NSString *selectId;
@property (nonatomic,strong) NSString *pictureImg;//图片

@end
