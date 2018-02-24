//
//  RegularUtil.m
//  AlertYao
//
//  Created by omiyang on 1/17/13.
//  Copyright (c) 2013 omiyang. All rights reserved.
//

#import "ETRegularUtil.h"

@implementation ETRegularUtil

+ (BOOL)isEmptyString:(NSString *)string {
    
    NSString *str = [NSString stringWithFormat:@"%@",string];
    if (string == nil || [str isKindOfClass:[NSNull class]]|| [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]||[@"<null>" isEqualToString:str]||[@"(null)" isEqualToString:str]) {
        return YES;
    }
    return NO;
}

+ (BOOL)stringLength:(NSString *)string max:(NSInteger)max min:(NSInteger)min {
    NSUInteger length = [string length];
    
    if (max>0 && length>max) {
        return NO;
    }
    if (min>0 && length<min) {
        return NO;
    }
    return YES;
}

+ (BOOL)regular:(NSString *)regular withString:(NSString *)string {
    NSError *error = NULL;
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:&error];
    
    NSTextCheckingResult *result = [regularExpression firstMatchInString:string
                                                                 options:0
                                                                   range:NSMakeRange(0, [string length])];
    
    if (result > 0) {
        return YES;
    }
    return NO;
}
@end
