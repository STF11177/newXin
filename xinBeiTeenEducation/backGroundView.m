//
//  backGroundView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "backGroundView.h"

@implementation backGroundView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
//      self.backgroundColor = [UIColor whiteColor];
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lian"]];
    [self addSubview:self.headImageView];
    
    self.netBtn = [[UIButton alloc]init];
    [self.netBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self.netBtn setTitle:@"网络不佳，请点击屏幕重试" forState:UIControlStateNormal];
    [self.netBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.netBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.netBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.netBtn];
}

-(void)layOutUI{

    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerY.equalTo(self).offset(-(64 +44 +49)/2);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(73);
    }];

    [self.netBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
}

-(void)btnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(netClickDelegate:)]) {
        [_delegate netClickDelegate:self];
    }
}

#pragma 隐藏
- (void)hiddenView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }
    }];
}

@end
