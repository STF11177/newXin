//
//  examTimeCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "examTimeCell.h"

@implementation examTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style  reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
    self.headLb = [[copyLable alloc]init];
    self.headLb.font = [UIFont systemFontOfSize:17];
    self.headLb.numberOfLines = 0;
    self.headLb.text = @"";
    self.headLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self.contentView addSubview:self.headLb];
}

-(void)layOutUI{
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 15);
    }];
}

-(void)setModel:(allRecommentModel *)model{

    self.headLb.text = model.examDate;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.headLb.text attributes:dic];
    self.headLb.attributedText = attributeStr;
}

@end
