//
//  payController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payController : UIViewController

@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *iconImg;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *subjectStr;
@property (nonatomic,strong) NSString *personStr;
@property (nonatomic,strong) NSString *typeName;//考试级别
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *examDate;

@property (nonatomic,strong) NSString *address;//领取地点
@property (nonatomic,strong) NSString *getAddress;//领取地点
@property (nonatomic,strong) NSString *getTime;//领取时间
@property (nonatomic,strong) NSString *payNameStr;//姓名
@property (nonatomic,strong) NSString *phoneNumber;//电话号码
@property (nonatomic,strong) NSString *fromWhere;//从哪里到这个界面

@property (nonatomic,strong) NSString *selectId;//tableview选中，remark状态

@property (nonatomic,strong) NSString *pictureImg;//图片
@property (nonatomic,strong) NSString *activityTitle;
@property (nonatomic,strong) NSString *subId;//某一条动态
@property (nonatomic,strong) NSString *firsrAddressStr;//第一次添加地址

@end
