//
//  educationVIew.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface educationVIew : UIView

@property (strong,nonatomic) NSArray *picArray;
@property (assign,nonatomic) CGFloat imageHeight;

- (instancetype)initWithWidth:(CGFloat)width;

@end
