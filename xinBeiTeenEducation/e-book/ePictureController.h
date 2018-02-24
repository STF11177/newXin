//
//  ePictureController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appListController.h"
#import "LSYReadModel.h"

@interface ePictureController : appListController

@property (nonatomic,strong) NSString *bookIdStr;
@property (nonatomic,strong) LSYReadModel *model;

@end
