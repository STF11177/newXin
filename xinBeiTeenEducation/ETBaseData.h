//
//  ETBaseData.h
//  iYepu
//
//  Created by Omiyang on 13-11-26.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ObjectMapping.h"

@interface ETBaseData :NSObject

//@property (strong, nonatomic) NSArray *columns;

//- (ObjectMapping *)objectMapping;
- (NSString *)toJson;
//- (NSString *)toString;
//- (NSMutableDictionary *)toDictionary;

@end

