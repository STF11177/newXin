//
//  detailFootView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "detailFootView.h"

@implementation detailFootView

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
    self.priceLb.text = @"价格：¥150.00";
    
    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.priceLb.text];
    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, self.priceLb.text.length - 3)];
    [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(3, self.priceLb.text.length - 3)];
    
    self.priceLb.attributedText = centStr;
    [self addSubview:self.priceLb];
    
    self.payBtn = [[UIButton alloc]init];
    [self.payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.payBtn.backgroundColor = [UIColor orangeColor];
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
        make.width.mas_equalTo(130);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH*0.3);
        make.height.mas_equalTo(50);
    }];
}

-(void)payClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(payFootView)]) {
        [_delegate payFootView];
    }
}

@end
