//
//  eduPayFootView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduPayFootView.h"

@implementation eduPayFootView

-(instancetype)initWithFrame:(CGRect)frame{

    self =[super initWithFrame:frame];
    if (self) {
        
        [self createView];
        [self layOutUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)createView{

    _payBtn = [[UIButton alloc]init];
    [_payBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    self.payBtn.backgroundColor = [UIColor colorWithHexString:@"#ff4539"];
    [self addSubview:self.payBtn];
 
    _priceLb = [[UILabel alloc]init];
    _priceLb.text = @"合计：¥255";
    [self addSubview:self.priceLb];
}

-(void)layOutUI{

    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(SCREEN_WIDTH*0.3);
    }];

    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.payBtn.mas_left).offset(-20);
        make.centerY.equalTo(self);
    }];
}

-(void)payClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(payFootView)]) {
        [_delegate payFootView];
    }
}

@end
