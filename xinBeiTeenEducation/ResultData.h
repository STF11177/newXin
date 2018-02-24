//
//  ResultData.h
//  iYepu
//
//  Created by Omiyang on 13-11-26.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import "ETBaseData.h"

@interface ResultData : ETBaseData

@property (strong) NSString *status;
@property (strong) NSNumber *total;
@property (strong, nonatomic) NSMutableArray *data;

- (BOOL)isSucc;
@end
