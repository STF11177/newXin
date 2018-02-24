//
//  payFootView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payFootView.h"

@implementation payFootView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
        [self layoutUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)createView{

    self.priceLb = [[UILabel alloc]init];
    self.priceLb.text = @"价格: ¥150.00";
    
    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.priceLb.text];
    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, self.priceLb.text.length - 4)];
    [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(4, self.priceLb.text.length - 4)];
    self.priceLb.attributedText = centStr;
    [self addSubview:self.priceLb];
    
    self.payBtn = [[UIButton alloc]init];
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    self.payBtn.backgroundColor = [UIColor colorWithHexString:@"#f37f13"];
    [self.payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.payBtn];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView];
}

-(void)layoutUI{

    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(160);
    }];

    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH*0.3);
        make.height.mas_equalTo(44);
    }];
}

-(void)payClick{

    if (_delegate && [_delegate respondsToSelector:@selector(payFootView)]) {
        [_delegate payFootView];
    }
}

@end
