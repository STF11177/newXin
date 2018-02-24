//
//  textFieldCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textFieldCell.h"

@implementation textFieldCell

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
    _headLb.text = @"买家留言:";
    _headLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.headLb];

    self.contentField = [[UITextField alloc]init];
    self.contentField.placeholder = @"选填:对本次交易的说明";
    self.contentField.delegate = self;
    [self.contentField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.contentField];
}

-(void)layOutUI{

    [_headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(100);
    }];

    [_contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.headLb.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 15 - 15 - 80);
    }];
}

-(void)endEditing{

    if (_delegate && [_delegate respondsToSelector:@selector(idCardInCell:)]) {
        [_delegate idCardInCell:self];
    }
}

@end
