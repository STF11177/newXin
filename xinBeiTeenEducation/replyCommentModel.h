//
//  replyCommentModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface replyCommentModel : NSObject

@property(nonatomic,copy) NSString *to_remarkName;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *commentId;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *createDate;
@property(nonatomic,copy) NSString *parent_cid;
@property(nonatomic,copy) NSString *commentImg;
@property(nonatomic,copy) NSString *likeCommentStatus;

@property(nonatomic,copy) NSString *from_remarkName;
@property(nonatomic,copy) NSString *to_nickName;
@property(nonatomic,copy) NSString *commentLike;
@property(nonatomic,copy) NSString *taskId;

@property(nonatomic,copy) NSString *to_userId;
@property(nonatomic,copy) NSString *faceImg;
@property(nonatomic,copy) NSString *from_nickName;
@property(nonatomic,copy) NSString *from_userId;
@property(nonatomic,copy) NSString *sex;

@end
