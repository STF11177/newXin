//
//  bugListModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/30.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bugListModel : NSObject

@property(nonatomic,copy) NSString *bugId;
@property(nonatomic,copy) NSString *parent_cid;//
@property(nonatomic,copy) NSArray *imgs;//数组
@property(nonatomic,copy) NSString *Iconimgs;
@property(nonatomic,copy) NSString *createDate;//
@property(nonatomic,copy) NSString *content;//
@property(nonatomic,copy) NSString *from_uid;//
@property(nonatomic,copy) NSString *status;//
@property(nonatomic,copy) NSString *sumCount;///


@end
