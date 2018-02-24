//
//  ResultData.m
//  iYepu
//
//  Created by Omiyang on 13-11-26.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import "ResultData.h"

@implementation ResultData

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (BOOL)isSucc {
    if ([@"ok" isEqualToString:self.status]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)columns {
    return @[
             @{@"key":@"status", @"prop":@"status", @"class":@"NSString"},
             @{@"key":@"total", @"prop":@"total", @"class":@"NSNumber"},
             @{@"key":@"data", @"prop":@"data", @"class":@"NSArray"}
            
             ];
}

@end
