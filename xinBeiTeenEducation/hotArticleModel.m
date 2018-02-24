//
//  hotArticleModel.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotArticleModel.h"

@implementation hotArticleModel

- (CGFloat)cellHeight{
    
    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 -15 -70 -15, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    CGRect contenRect = [self.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    _cellHeight = contenRect.size.height + 15 + 20 + 15 + 15;
    DDLog(@"%f",_cellHeight);
    return _cellHeight;
}

@end
