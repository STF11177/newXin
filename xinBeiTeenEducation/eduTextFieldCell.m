//
//  eduTextFieldCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/12.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduTextFieldCell.h"

@implementation eduTextFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(UILabel *)nameHeadLb{

    if (!_nameHeadLb) {
        
        _nameHeadLb = [[UILabel alloc]init];
        _nameHeadLb.text = @"收货人";
    }
    return _nameHeadLb;
}

-(UITextField *)nameField{

    if (!_nameField) {
        
        _nameField = [[UITextField alloc]init];
    }
    return _nameField;
}

-(UILabel *)phoneHeadLb{

    if (!_phoneHeadLb) {
        
        _phoneHeadLb = [[UILabel alloc]init];
    }
    return _phoneHeadLb;
}

-(UITextField *)phoneField{

    if (!_phoneField) {
        
        _phoneField = [[UITextField alloc]init];
    }
    return _phoneField;
}

-(UIView *)sepeView{

    if (!_sepeView) {
        
        _sepeView = [[UIView alloc]init];
        _sepeView.backgroundColor = [UIColor lightGrayColor];
    }
    return _sepeView;
}

-(UIView *)sepeView1{
    
    if (!_sepeView1) {
        
        _sepeView1 = [[UIView alloc]init];
        _sepeView1.backgroundColor = [UIColor lightGrayColor];
    }
    return _sepeView1;
}

-(void)createView{

    self.nameHeadLb.text = @"收货人姓名";
    [self addSubview:self.nameHeadLb];
    
    self.nameField.placeholder = @"请填写收货人姓名";
    [self.nameField addTarget:self action:@selector(nameEndEditing) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.nameField];
    
    self.phoneField.placeholder = @"请填写收货人电话";
    [self.phoneField addTarget:self action:@selector(phoneEndEditing) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.phoneField];
    
    self.phoneHeadLb.text = @"收货人电话";
    [self addSubview:self.phoneHeadLb];
    
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView];
    
    self.sepeView1.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView1];
}

-(void)layOutUI{

    [self.nameHeadLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self.nameHeadLb.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 15 - 15 - 80);
        make.height.mas_equalTo(44);
    }];

    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameHeadLb.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 15);
        make.height.mas_equalTo(1);
    }];
    
    [self.phoneHeadLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepeView.mas_bottom);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepeView.mas_bottom);
        make.left.equalTo(self.nameHeadLb.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 15 - 15 - 80);
        make.height.mas_equalTo(44);
    }];
    
    [self.sepeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.phoneHeadLb.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 15);
        make.height.mas_equalTo(1);
    }];
}

-(void)nameEndEditing{

    if (_delegate && [_delegate respondsToSelector:@selector(nameTextField:)]) {
        [_delegate nameTextField:self];
    }
}

-(void)phoneEndEditing{

    if (_delegate && [_delegate respondsToSelector:@selector(phoneTextField:)]) {
        [_delegate phoneTextField:self];
    }
}

@end
