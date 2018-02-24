//
//  managerDefaultCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "managerDefaultCell.h"

@implementation managerDefaultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.defaultBtn = [[UIButton alloc]init];
    [self.defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
    self.defaultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.defaultBtn setImage:[UIImage imageNamed:@"moren2"] forState:UIControlStateNormal];
    [self.defaultBtn setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateNormal];
    [self.defaultBtn addTarget:self action:@selector(defaultBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.isSelect = NO;
    [self addSubview:self.defaultBtn];
    
    self.deleteBtn = [[UIButton alloc]init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.deleteBtn setImage:[UIImage imageNamed:@"dadlet"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    
    self.editBtn = [[UIButton alloc]init];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.editBtn setImage:[UIImage imageNamed:@"modify"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateNormal];
    [self addSubview:self.editBtn];
}

-(void)layOutUI{

    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-15);
    }];
}

-(void)defaultBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(defaultAddress:)]) {
        [_delegate defaultAddress:self];
    }
}

-(void)deleteBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteAddress:)]) {
        [_delegate deleteAddress:self];
    }
}

-(void)editBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(editAddress:)]) {
        [_delegate editAddress:self];
    }
}

-(void)setModel:(checkAddressModel *)model{

    if ([model.status isEqualToString:@"0"]) {
        
        [self.defaultBtn setImage:[UIImage imageNamed:@"coach"] forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[UIColor colorWithHexString:@"#fe6400"] forState:UIControlStateNormal];
    }else{
    
        [self.defaultBtn setImage:[UIImage imageNamed:@"moren2"] forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateNormal];
    }
}

@end
