//
//  RegularUtil.h
//  AlertYao
//
//  Created by omiyang on 1/17/13.
//  Copyright (c) 2013 omiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETRegularUtil : NSObject

+ (BOOL)isEmptyString:(NSString *)string;
+ (BOOL)stringLength:(NSString *)string max:(NSInteger)max min:(NSInteger)min;
+ (BOOL)regular:(NSString *)regular withString:(NSString *)string;
@end
