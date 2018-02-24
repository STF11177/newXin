//
//  detailCommentModel.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "detailCommentModel.h"

@implementation detailCommentModel

-(CGFloat)cellHeight{
    
    CGFloat floatHeight = 15 + 30 + 15 +21 +15;
    
    NSString *remarkContent = [NSString stringWithFormat:@"%@",self.remarkContent];
    NSString *string;
    if (![ETRegularUtil isEmptyString:remarkContent]) {
        
        NSString *beComment = [NSString stringWithFormat:@"@%@：",self.remarkName];
        NSString *contentStr = [NSString stringWithFormat:@"%@//%@%@",self.content,beComment,remarkContent];
        
        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithHexString:@"#5184BC"]
         
                                range:NSMakeRange(self.content.length+2,beComment.length)];
        string = attrDescribeStr.string;
        
    }else{
        
        string = [NSString stringWithFormat:@"%@",self.content];
    }
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 -45 -15 -15, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    CGRect contenRect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGFloat rectfloat = contenRect.size.height;
    
    floatHeight = floatHeight + rectfloat +15;
    
    return floatHeight;
}

@end
