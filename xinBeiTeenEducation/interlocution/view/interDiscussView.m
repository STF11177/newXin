//
//  interDiscussView.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interDiscussView.h"

@implementation interDiscussView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
    
        [self addSubview:self.lineView];
        [self addSubview:self.discussCountBtn];
        [self addSubview:self.collectBtn];
        [self addSubview:self.discussBtn];
        [self layOutUI];
    }
    return self;
}

-(UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

-(UIButton *)discussCountBtn{
    
    if (!_discussCountBtn) {
        
        _discussCountBtn = [[UIButton alloc]init];
        
        [_discussCountBtn setTitle:@"0个回答" forState:UIControlStateNormal];
        [_discussCountBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _discussCountBtn;
}

-(UIButton *)discussBtn{
    
    if (!_discussBtn) {
        
        _discussBtn = [[UIButton alloc]init];
        [_discussBtn setTitle:@"回答" forState:UIControlStateNormal];
        [_discussBtn addTarget:self action:@selector(discussClick) forControlEvents:UIControlEventTouchUpInside];
        [_discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _discussBtn.backgroundColor = [UIColor redColor];
    }
    return _discussBtn;
}

-(UIButton *)collectBtn{
    
    if (!_collectBtn) {
        
        _collectBtn = [[UIButton alloc]init];
        [_collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setTitle:@"0个收藏" forState:UIControlStateNormal];
        [_collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    return _collectBtn;
}

-(void)layOutUI{
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
    }];
    
    [self.discussCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom);
        make.width.equalTo(self.mas_width).dividedBy(3);
        make.bottom.equalTo(self).offset(-0.5);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.discussCountBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.discussCountBtn.mas_width);
        make.height.mas_equalTo(self.discussCountBtn.mas_height);
    }];
    
    [self.discussBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.collectBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.discussCountBtn.mas_width);
        make.height.mas_equalTo(self.discussCountBtn.mas_height);
    }];
}

-(void)discussClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(discussInCell:)]) {
        [_delegate discussInCell:self];
    }
}

-(void)collectClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(collectInView:)]) {
        [_delegate collectInView:self];
    }
}

@end
