//
//  textualRearchTableView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textualRearchTableView.h"

@interface UIView (Add)

-(void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)Opacity;

@end

@implementation UIView (Add)

-(void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)Opacity{
    
    self.layer.cornerRadius = radius;
    if (shadow) {
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = Opacity;
        self.layer.shadowOffset = CGSizeMake(-4, 4);
        self.layer.shadowRadius = 4;
        self.layer.shouldRasterize = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius]CGPath];
    }
    
    self.layer.masksToBounds = !shadow;
}

@end

@implementation textualRearchTableView



@end
