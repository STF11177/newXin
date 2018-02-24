//
//  interDisscussModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/8.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface interDisscussModel : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *clickSum;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *parent_cid;
@property (nonatomic,copy) NSString *likeCommentStatus;
@property (nonatomic,copy) NSString *commentImg;
@property (nonatomic,copy) NSString *commentLike;
@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,copy) NSString *faceImg;
@property (nonatomic,copy) NSString *from_nickName;
@property (nonatomic,copy) NSString *from_userId;
@property (nonatomic,copy) NSString *attachedContent;

@property (nonatomic,assign) BOOL isLike; //是否点赞

-(CGFloat)cellHeight;


@end
