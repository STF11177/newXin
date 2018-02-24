//
//  interDiscussDetailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface interDiscussDetailController : UIViewController

@property (nonatomic,strong) NSString *commentStr;
@property (nonatomic,strong) NSString *from_uid;
@property (nonatomic,strong) NSString *faceImage;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *taskStr;
@property (nonatomic,strong) NSMutableArray *createArray;
@property (nonatomic,strong) NSString *minDateStr;

@end
