//
//  newController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int status;
@property (nonatomic,strong) NSMutableArray *taskArray;//存放taskId的数据
@property (nonatomic,strong) NSString *userId;



@end
