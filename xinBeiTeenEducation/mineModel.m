//
//  mineModel.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 user. All rights reserved.

#import "mineModel.h"

@implementation mineModel
+ (NSArray *)mineData {
    mineModel *model1 = [mineModel new];
    model1.headImageName = @"person";
    model1.titleLb = @"个人资料";
    
    mineModel *model2 = [mineModel new];
    model2.headImageName = @"mychild";
    model2.titleLb = @"我的孩子";
    
    mineModel *model3 = [mineModel new];
    model3.headImageName = @"order";
    model3.titleLb = @"我的订单";
    
//    mineModel *model4 = [mineModel new];
//    model4.headImageName = @"invite";
//    model4.titleLb = @"邀请码";

//    mineModel *model5 = [mineModel new];
//    model5.headImageName = @"cash";
//    model5.titleLb = @"抵用劵";
    
    mineModel *model6 = [mineModel new];
    model6.headImageName = @"collectContent";
    model6.titleLb = @"我的收藏";
    
    mineModel *model7 = [mineModel new];
    model7.headImageName = @"me_Bug";
    model7.titleLb = @"用户反馈";
    
    mineModel *model8 = [mineModel new];
    model8.headImageName = @"me_query";
    model8.titleLb = @"成绩查询";
    
    mineModel *model9 = [mineModel new];
    model9.headImageName = @"set";
    model9.titleLb = @"设置";
    
    return @[model1, model2, model3,model6,model7,model8,model9];
//  return @[model1, model2, model3,model6,model8];
}


@end
