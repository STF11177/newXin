//
//  detailTextCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "detailTextCell.h"

@implementation detailTextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOuTUI];
    }
    return self;
}

-(void)createView{

    self.contentLb = [[copyLable alloc]init];
    self.contentLb.text = @"";
    
    self.contentLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    self.contentLb.numberOfLines = 0;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.contentLb.text attributes:dic];
    self.contentLb.attributedText = attributeStr;
    [self addSubview:self.contentLb];
}

-(void)layOuTUI{

    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
}



-(CGFloat)cellHeight{

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    /** 行高 */
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle};
    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    
    //  计算内容label的高度
    
    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    _cellHeight = contenRect.size.height + 15.0 + 15;
    
    return _cellHeight;
}

@end
