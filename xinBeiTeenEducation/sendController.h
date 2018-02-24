//
//  sendController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/8.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newController.h"
@class sendController;

@interface sendController : UIViewController

@property (nonatomic, strong) newController *homeVc;
@property (nonatomic, assign) NSString *source;
@property (nonatomic, strong) sendController* commentVc;
@property (nonatomic, strong) NSMutableArray *selectedImgs;
@property (nonatomic, copy) NSString *tgg;

@property (nonatomic, strong) NSMutableArray *dataArray;//选择板块
@property (nonatomic, strong) NSMutableArray *dataName;//名字
@property (nonatomic, strong) NSMutableArray *dataTypeId;//对应的id
@property (nonatomic, strong) NSMutableArray *dictArray;//存放名字，对应id字典的数组

@end
