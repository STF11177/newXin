//
//  interlocutionView.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/4.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface interlocutionView : UIView

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url

- (instancetype)initWithWidth:(CGFloat)width;

@end
