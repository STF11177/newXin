//
//  menuListModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menuListModel : NSObject

@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,assign) int comment_count;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *faceImg;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *remarkName;
@property (nonatomic,assign) int transmit_count;
@property (nonatomic,copy) NSString *typeName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *from_uid;
@property (nonatomic,assign) int collect_count;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,assign) int collectStatus;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *voideImg;
@property (nonatomic,copy) NSString *maskStatus;
@property (nonatomic,copy) NSString *stickStatus;

@property (nonatomic, assign) int commentCount;     //评论数
@property (nonatomic, assign) BOOL isLike;          //是否喜欢

@property (nonatomic) BOOL shouldShowMoreButton;
@property (nonatomic) BOOL isOpening;



@end
