//
//  discussDetailView.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "discussDetailView.h"

@implementation discussDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.commentField];
        [self addSubview:self.commenBtn];
        [self addSubview:self.likeBtn];
        [self addSubview:self.nextBtn];
        [self addSubview:self.lineView];
        [self layOutUI];
    }
    return self;
}

-(UITextField *)commentField{
    
    if (!_commentField) {
    
        _commentField = [[UITextField alloc]init];
        
        _commentField.placeholder = @"写评论...";
        _commentField.layer.cornerRadius = 12;
        _commentField.layer.borderWidth = 0.5;
        _commentField.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        _commentField.delegate = (id)self;
        _commentField.layer.borderColor = [UIColor grayColor].CGColor;
        [_commentField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_commentField setValue:[UIFont systemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 14)];
        _commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        imgView.image = [UIImage imageNamed:@"papty"];
        _commentField.leftView = imgView;
        _commentField.leftViewMode = UITextFieldViewModeAlways;
        _commentField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
        
        NSMutableParagraphStyle *style = [_commentField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        style.minimumLineHeight = _commentField.font.lineHeight - (_commentField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    }
    return _commentField;
}

-(UIButton *)commenBtn{
    
    if (!_commenBtn) {
        
        _commenBtn = [[UIButton alloc]init];
        [_commenBtn setImage:[UIImage imageNamed:@"Review"] forState:UIControlStateNormal];
        
        [_commenBtn addTarget:self action:@selector(commenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commenBtn;
}

-(UIButton *)likeBtn{
    
    if (!_likeBtn) {
        
        _likeBtn = [[UIButton alloc]init];
        [_likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

-(UIButton *)nextBtn{
    
    if (!_nextBtn) {
        
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setImage:[UIImage imageNamed:@"nest_answer"] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

-(UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    return _lineView;
}

-(void)layOutUI{
    
    [self.commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH/2 -10);
    }];
    
    [self.commenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.commentField.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo((ScreenWidth/2 )/3);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.commenBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo((ScreenWidth/2 )/3);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.likeBtn.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo((ScreenWidth/2 )/3);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegate:)]) {
        [_delegate textFieldDelegate:self];
    }
}

-(void)commenBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(commentBtnInView:)]) {
        [_delegate commentBtnInView:self];
    }
}

-(void)likeBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(likeBtnInView:)]) {
        [_delegate likeBtnInView:self];
    }
}

-(void)nextClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(nextBtnInView:)]) {
        [_delegate nextBtnInView:self];
    }
}

@end
