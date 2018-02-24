//
//  instroduceCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "instroduceCell.h"

@implementation instroduceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.headView = [[UIImageView alloc]init];
    self.headView.image = [UIImage imageNamed:@"shuxian"];
    [self.contentView addSubview:self.headView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"活动介绍";
    self.titleLb.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.titleLb];
    
    self.contentLb = [[copyLable alloc]init];
    self.contentLb.numberOfLines = 0;
    self.contentLb.text = @"";
    self.contentLb.font = [UIFont systemFontOfSize:17];
    self.contentLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self addSubview:self.contentLb];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lineView];
}

-(void)layOutUI{

    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.titleLb.mas_left).offset(-15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];

    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(15);
        make.top.equalTo(self.headView.mas_top);
         
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(44);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH -15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    // 不然在6/6plus上就不准确了
    self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15;
}

-(void)setModel:(allRecommentModel *)model{

    self.contentLb.text = model.referral;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.contentLb.text attributes:dic];
    self.contentLb.attributedText = attributeStr;
}

- (CGFloat)cellHeight{
    
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
    CGRect contenRect1 = [self.contentLb.text boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
    
    _cellHeight = contenRect1.size.height + 44 + 15 + 15;
    return _cellHeight;
}

@end
