//
//  interKeyBoardView.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/10.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interKeyBoardView.h"

@implementation interKeyBoardView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backBtn];
        [self addSubview:self.pictureBtn];
        [self layOutUI];
    }
    return self;
}

-(UIButton *)backBtn{
    
    if (!_backBtn) {
        
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"inter_pull_down"] forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIButton *)pictureBtn{
    
    if (!_pictureBtn) {
        
        _pictureBtn = [[UIButton alloc]init];
        [_pictureBtn setImage:[UIImage imageNamed:@"interImage"] forState:UIControlStateNormal];
        [_pictureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_pictureBtn addTarget:self action:@selector(pictureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pictureBtn;
}

-(void)layOutUI{
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(19);
    }];
    
    [_pictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(19);
    }];
}

-(void)backClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(backInView:)]) {
        [_delegate backInView:self];
    }
}

-(void)pictureClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(showPictureInView)]) {
        [_delegate showPictureInView];
    }
}

@end
