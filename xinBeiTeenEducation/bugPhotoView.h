//
//  bugPhotoView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bugPhotoView : UIView

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url

- (instancetype)initWithWidth:(CGFloat)width;

@end
