//
//  UIImage+RSSet.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UIImage+RSSet.h"

@implementation UIImage (RSSet)

+ (UIImage *)imageName:(NSString *)name {
    if (!name) {
        
        return nil;
    }
    return [UIImage imageNamed:name];
}

@end
