//
//  eduDetailFootView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduDetailFootView.h"

@implementation eduDetailFootView

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
    
    self.payBtn = [[UIButton alloc]init];
    [self.payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.payBtn.backgroundColor = [UIColor colorWithHexString:@"#ff4539"];
    [self.payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.payBtn];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"];
    [self addSubview:self.sepeView];
    
    self.likeBtn = [[UIButton alloc]init];
    [self.likeBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateSelected];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    [self.likeBtn setBackgroundColor:[UIColor redColor]];
    [self.likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.likeBtn];
    
    self.collectBtn = [[UIButton alloc]init];
    [self.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"nices2"] forState:UIControlStateSelected];
    [self.collectBtn setTitle:@"0" forState:UIControlStateNormal];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.collectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    [self.collectBtn setBackgroundColor:[UIColor redColor]];
    [self.collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:self.collectBtn];
}

-(void)layoutUI{
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(70);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.likeBtn.mas_right);
        make.width.mas_equalTo(70);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
        make.height.mas_equalTo(44);
    }];
}

-(void)payClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(payFootView)]) {
        [_delegate payFootView];
    }
}

-(void)collectClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(collectFootView:)]) {
        [_delegate collectFootView:self];
    }
}

-(void)likeClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(likeFootView:)]) {
        [_delegate likeFootView:self];
    }
}


@end
