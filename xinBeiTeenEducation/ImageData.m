//
//  ImageData.m
//  Carcool
//
//  Created by yizheming on 15/8/25.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData
-(NSArray *)columns{
    return @[
             @{@"key":@"url",@"prop":@"url",@"class":@"NSString"},
             @{@"key":@"uri",@"prop":@"uri",@"class":@"NSString"}
             ];
}
@end
