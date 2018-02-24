//
//  interDiscussModel.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "interlocutionModel.h"

@implementation interlocutionModel

-(CGFloat)cellHeight{
    
    CGFloat Height;
    
    CGFloat contastFloat = 13 + 5 + 9 +15;
    NSString *imageStr = [NSString stringWithFormat:@"%@",self.imgs];
    
    if (![ETRegularUtil isEmptyString:imageStr]) {
        
        contastFloat = contastFloat + 73 + 21;
    }else{
    
        contastFloat  = contastFloat  + 21 + 5;
    }
    
    Height = contastFloat + [self getSpaceLabelHeightwithSpeace:5 withFont:[UIFont systemFontOfSize:18] withWidth:ScreenWidth - 30];
    return Height;
}

-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
   
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f};
    CGSize size = [self.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
