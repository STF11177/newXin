//
//  tabbarView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import "tabbarView.h"

@implementation tabbarView
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

    self.textFiled = [[UITextField alloc]init];
    self.textFiled.placeholder = @"我来说2句...";
    self.textFiled.layer.cornerRadius = 17;
    self.textFiled.layer.borderWidth = 0.5;

    self.textFiled.delegate = (id)self;
    self.textFiled.layer.borderColor = [UIColor grayColor].CGColor;
    [self.textFiled setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textFiled setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 14)];
    self.textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    imgView.image = [UIImage imageNamed:@"papty"];
    self.textFiled.leftView = imgView;
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    self.textFiled.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    
    NSMutableParagraphStyle *style = [self.textFiled.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = self.textFiled.font.lineHeight - (self.textFiled.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    [self addSubview:self.textFiled];

    self.likeBtn = [[UIButton alloc]init];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    self.likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.likeBtn];
    
    self.collectBtn = [[UIButton alloc]init];
    [self.collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn setImage:[UIImage imageNamed:@"nices"] forState:UIControlStateNormal];
    [self addSubview:self.collectBtn];
    
    self.shareBtn = [[UIButton alloc]init];
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setImage:[UIImage imageNamed:@"chuct"] forState:UIControlStateNormal];
    [self addSubview:self.shareBtn];
    
    self.pictureView = [[UIView alloc]init];
    self.pictureView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.pictureView];
}

-(void)layoutUI{

    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.likeBtn.mas_left).offset(-20);
        make.height.mas_equalTo(32);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFiled.mas_top).offset(5);
        make.right.equalTo(self.collectBtn.mas_left).offset(-20);
        make.width.mas_equalTo(50);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeBtn.mas_top);
        make.right.equalTo(self.shareBtn.mas_left).offset(-30);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeBtn.mas_top);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegate:)]) {
        [_delegate textFieldDelegate:self];
    }
}

-(void)likeBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(liekTabbarDelegate:)]) {
        [_delegate liekTabbarDelegate:self];
    }
}

-(void)collectBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(collectTabbarDelegate:)]) {
        [_delegate collectTabbarDelegate:self];
    }
}

-(void)shareBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(shareTabbarDelegate:)]) {
        [_delegate shareTabbarDelegate:self];
    }
}

@end
