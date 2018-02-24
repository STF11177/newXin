//
//  footViewCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "footViewCell.h"

@implementation footViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
    
    self.payBtn = [[UIButton alloc]init];
    [self.payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.payBtn.backgroundColor = [UIColor colorWithHexString:@"#f37f13"];
    [self.payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.payBtn];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.sepeView];
    
    self.likeBtn = [[UIButton alloc]init];
    [self.likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
    self.likeBtn.backgroundColor = [UIColor grayColor];
    [self.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateSelected];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0 ,0, 0)];
//    [self.likeBtn setImageEdgeInsets:UIEdgeInsetsMake( -15, 25, 0, 0)];
    [self.likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.likeBtn];
    
    self.collectBtn = [[UIButton alloc]init];
    [self.collectBtn setImage:[UIImage imageNamed:@"listshouc"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"listshouc2"] forState:UIControlStateSelected];
    [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0 ,0, 0)];
    [self.collectBtn setImageEdgeInsets:UIEdgeInsetsMake( -15, 25, 0, 0)];
    [self.collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.collectBtn];
    
    self.commentBtn = [[UIButton alloc]init];
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"discuss"] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0 ,0, 0)];
    [self.commentBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 22, 0, 0)];
    [self.commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.commentBtn];
}

-(void)layoutUI{
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.commentBtn.mas_left).offset(-30);
        make.width.mas_equalTo(30);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.likeBtn.mas_right).offset(30);
        make.right.equalTo(self.collectBtn.mas_left).offset(-30);
        
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.commentBtn.mas_right).offset(30);
        
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(void)commentClick{

    if (_delegate && [_delegate respondsToSelector:@selector(commentFootCell:)]) {
        [_delegate commentFootCell:self];
    }
}

-(void)collectClick{

    if (_delegate && [_delegate respondsToSelector:@selector(collectFootCell:)]) {
        [_delegate collectFootCell:self];
    }
}

-(void)likeClick{

    if (_delegate && [_delegate respondsToSelector:@selector(likeFootCell:)]) {
        [_delegate likeFootCell:self];
    }
}


@end
