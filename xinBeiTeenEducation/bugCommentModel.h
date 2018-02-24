//
//  bugCommentModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bugCommentModel : NSObject

@property(nonatomic,copy) NSString *from_uid;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *parent_cid;
@property(nonatomic,copy) NSString *imgs;
@property(nonatomic,copy) NSString *createDate;
@property(nonatomic,copy) NSString *sumCount;
@property(nonatomic,copy) NSString *bugId;
@property(nonatomic,copy) NSString *status;

@end
