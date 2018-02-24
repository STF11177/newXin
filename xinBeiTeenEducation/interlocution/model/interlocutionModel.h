//
//  interDiscussModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface interlocutionModel : NSObject

@property (nonatomic,copy) NSString *like;
@property (nonatomic,copy) NSString *comment_count;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *collect_count;
@property (nonatomic,copy) NSString *stickStatus;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *from_uid;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *transmit_count;
@property (nonatomic,copy) NSString *collectStatus;
@property (nonatomic,copy) NSString *ip_address;
@property (nonatomic,copy) NSString *voideImg;
@property (nonatomic,copy) NSString *imgStr;

-(CGFloat)cellHeight;

@end
