//
//  testdetailCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testdetailCell.h"

@implementation testdetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
    
    self.titleLale = [[copyLable alloc]init];
    self.titleLale.numberOfLines = 0;
    self.titleLale.numberOfLines = 0;
    self.titleLale.text = @"比赛";
    [self addSubview:self.titleLale];
    
    self.testTiemLb = [[UILabel alloc]init];
    self.testTiemLb.font = [UIFont systemFontOfSize:15];
    self.testTiemLb.text = @"考试时间：2017-6-15";
    self.testTiemLb.textColor = [UIColor colorWithHexString:@"#9f9f9f"];
    [self addSubview:self.testTiemLb];
    
    self.personLb = [[UILabel alloc]init];
    self.personLb.font = [UIFont systemFontOfSize:15];
    self.personLb.text = @"已有25254人报名";
    self.personLb.textColor = [UIColor colorWithHexString:@"#ff6600"];
    [self addSubview:self.personLb];
    
    self.collectBtn = [[UIButton alloc]init];
    [self.collectBtn setImage:[UIImage imageNamed:@"chuct"] forState:UIControlStateNormal];
    [self.collectBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.collectBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0 ,0, 0)];
    [self.collectBtn setImageEdgeInsets:UIEdgeInsetsMake( -15, 25, 0, 0)];
    [self addSubview:self.collectBtn];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lineView];
}

-(void)layoutUI{
    
    [self.titleLale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.lineView.mas_left).offset(-20);

        }];
    
        [self.testTiemLb mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.titleLale.mas_left);
          make.right.equalTo(self.personLb.mas_left).offset(-10);
          make.bottom.equalTo(self).offset(-18);
            
        }];
    
        [self.personLb mas_makeConstraints:^(MASConstraintMaker *make) {;
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self.testTiemLb.mas_right).offset(10);
            make.bottom.equalTo(self.testTiemLb.mas_bottom);
            
        }];
    
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(1);
        
        }];

        [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_top).offset(8);
            make.left.equalTo(self.lineView.mas_right);
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(50);
            
        }];
}

-(void)setModel:(allRecommentModel *)model{

    self.titleLale.text = model.title;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0; //设置行间距
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:22], NSParagraphStyleAttributeName:paraStyle };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.titleLale.text attributes:dic];
    self.titleLale.attributedText = attributeStr;

    if (!model.apply_count) {
        
        self.personLb.text = @"已有0人报名";
    }else{
        
        int count = [model.count intValue];
        int applyCount = [model.apply_count intValue];
        int count1 = count + applyCount;
        NSString *countStr = [NSString stringWithFormat:@"%d",count1];
        self.personLb.text = [NSString stringWithFormat:@"已有%@人报名",countStr];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",model.endDate];
    self.testTiemLb.text = [NSString stringWithFormat:@"截止时间：%@",str];

    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 -15 - 20 - 20 - 1 - 18, CGFLOAT_MAX);
    CGSize size = [model.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if (size.height < 27) {
        [self.titleLale mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(25);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self.lineView.mas_left).offset(-20);
            
        }];
    }
}

-(void)shareBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(shareCell:)]) {
        [_delegate shareCell:self];
    }
}

@end
