//
//  newStatusModel.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "menuListModel.h"

@interface newStatusModel : NSObject


@property (nonatomic,assign) int status;



-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;
@end
