
//
//  payNumberCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payNumberCell.h"

@implementation payNumberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    _headLb = [[UILabel alloc]init];
    _headLb.text = @"购买数量";
    [self addSubview:_headLb];

    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:_deleteBtn];
    
    _numberLb = [[UILabel alloc]init];
    _numberLb.text = @"1";
    _numberLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numberLb];
    
    _addBtn = [[UIButton alloc]init];
    [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    _addBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:_addBtn];
}

-(void)layOutUI{

    [_headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];

    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-15);
        make.width.height.mas_equalTo(20);
    }];
    
    [_numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.addBtn.mas_left).offset(1);
        make.bottom.equalTo(self.addBtn);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.numberLb.mas_left).offset(1);
        make.bottom.equalTo(self.addBtn);
        make.width.height.mas_equalTo(20);
    }];
    
}

-(void)addClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(addProductNumWith:)]) {
        [_delegate addProductNumWith:self];
    }
}

-(void)deleteClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteProductNumWith:)]) {
        [_delegate deleteProductNumWith:self];
    }
}

@end
