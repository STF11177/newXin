//
//  hotArticleModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotArticleModel : NSObject

@property (nonatomic,copy) NSString *comment_count;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *ip_address;
@property (nonatomic,copy) NSString *from_uid;
@property (nonatomic,copy) NSString *transmit_count;
@property (nonatomic,copy) NSString *collectStatus;
@property (nonatomic,copy) NSString *faceImg;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *collect_count;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *like;
@property (nonatomic,copy) NSString *sum;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *attachedContent;

@property (nonatomic,assign) CGFloat cellHeight;

@end
