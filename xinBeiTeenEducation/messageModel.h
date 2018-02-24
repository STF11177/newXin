//
//  messageModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/8.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageModel : NSObject

@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *context;
@property(nonatomic,copy) NSString *createDate;

@end
