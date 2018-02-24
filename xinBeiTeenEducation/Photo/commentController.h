//
//  commentController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appListController.h"
#import "contentImageController.h"

@interface commentController : contentImageController

@property (nonatomic,strong) NSString *commentTaskId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *biaojiStr;//从详情进入

@end
