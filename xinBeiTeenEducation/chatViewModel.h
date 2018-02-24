//
//  chatViewModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/5.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatViewModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *remarkName;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *sdasd;
@property (nonatomic,copy) NSString *faceImg;
@property (nonatomic,copy) NSString *status;//0是好友，2是黑名单,1是待通过的好友，3是已经通过的好友
@property (nonatomic,copy) NSString *remarks;

@end
