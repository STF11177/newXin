//
//  detailHeadCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "detailHeadCell.h"

@implementation detailHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOut];
    }
    return self;
}

-(void)createView{
    
    _sepeView = [[UIView alloc]init];
    _sepeView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:_sepeView];
    
    _signBtn = [[UIButton alloc]init];
    [_signBtn setTitle:@"正版" forState:UIControlStateNormal];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _signBtn.backgroundColor = [UIColor colorWithHexString:@"#ff2b24"];
    _signBtn.layer.cornerRadius = 2;
    [self addSubview:_signBtn];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont systemFontOfSize:17];
    _titleLb.textColor = [UIColor colorWithHexString:@"#19191b"];
    _titleLb.text = @"新概念英语青少年版";
    _titleLb.numberOfLines = 0;
    [self addSubview:_titleLb];
    
    _saleLb = [[UILabel alloc]init];
    _saleLb.textColor = [UIColor colorWithHexString:@"#ff2b24"];
    _saleLb.text = @"¥50";
    [self addSubview:_saleLb];

    _originPriceLb = [[UILabel alloc]init];
    _originPriceLb.font = [UIFont systemFontOfSize:15];
    _originPriceLb.textColor = [UIColor colorWithHexString:@"#737373"];
    _originPriceLb.text = @"¥40";
    [self addSubview:_originPriceLb];
    
    _expressLb = [[UILabel alloc]init];
    _expressLb.text = @"快递：10.00";
    _expressLb.textColor = [UIColor colorWithHexString:@"#737373"];
    _expressLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:_expressLb];
    
    _monthSaleLb = [[UILabel alloc]init];
    _monthSaleLb.text = @"销售2017笔";
    _monthSaleLb.textColor = [UIColor lightGrayColor];
    _monthSaleLb.textColor = [UIColor colorWithHexString:@"#737373"];
    _monthSaleLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:_monthSaleLb];
    
    _addressLb = [[UILabel alloc]init];
    _addressLb.text = @"上海";
    _addressLb.textColor = [UIColor colorWithHexString:@"#737373"];
    _addressLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:_addressLb];
    
    _detailImage = [[UIImageView alloc]init];
//  _detailImage.image = [UIImage imageNamed:@"edu_Sale"];
    [self addSubview:_detailImage];
}

-(void)layOut{
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(10);
    }];
    
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepeView.mas_bottom).offset(17);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepeView.mas_bottom).offset(17);
        make.left.equalTo(self.signBtn.mas_right).offset(3);
    }];
    
    [self.saleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
    }];
    
//    [self.originPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(self.saleLb.mas_centerY);
//        make.left.equalTo(self.saleLb.mas_right).offset(8);
//    }];
    
    [self.expressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.saleLb.mas_bottom).offset(8);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.monthSaleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.expressLb.mas_top);
        make.centerX.equalTo(self);
    }];
    
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.expressLb.mas_top);
        make.right.equalTo(self).offset(-15);
    }];
}

@end
