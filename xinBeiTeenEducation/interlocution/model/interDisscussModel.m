//
//  interDisscussModel.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/8.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interDisscussModel.h"

@implementation interDisscussModel

-(CGFloat)cellHeight{
    
    CGFloat Height;
    CGFloat contentHeight1;
    // 计算内容label的高度
    contentHeight1 = [self getSpaceLabelHeightwithSpeace:3 withFont:[UIFont systemFontOfSize:17] withWidth:SCREEN_WIDTH - 30];
    
    if ([ETRegularUtil isEmptyString:self.attachedContent]) {
        
        contentHeight1 = 0;
    }
    CGFloat contastFloat = 15 + 45 + 15 + 5;

    CGFloat contentHeight;
    if (![ETRegularUtil isEmptyString:self.commentImg]) {
        
        if (contentHeight1 >70) {
            
            contentHeight = 84;
        }else{
            
            contentHeight = contentHeight1;
        }
        Height = contastFloat+ contentHeight + 120 + 30;
    }else{
        
        if (contentHeight1 >112) {
            
            contentHeight = 112 +10;
        }else{
            
            contentHeight = contentHeight1;
        }
        Height  = contastFloat + contentHeight + 21 +5;
    }
    return Height;
}

-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f};
    CGSize size = [self.attachedContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
