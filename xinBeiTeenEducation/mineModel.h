//
//  mineModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mineModel : NSObject

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *faceImg;

@property (nonatomic,strong) NSString *headImageName;
@property (nonatomic,strong) NSString *titleLb;
@property (nonatomic, copy) NSString *rightImageName;
@property (nonatomic, copy) NSString *rightText;

+ (NSArray *)mineData;

@end
