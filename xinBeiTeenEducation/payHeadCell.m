//
//  payHeadCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payHeadCell.h"

@implementation payHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    _nameLb = [[UILabel alloc]init];
    _nameLb.text = @"收货人：流潋紫";
    _nameLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:_nameLb];

    _phoneLb = [[UILabel alloc]init];
    _phoneLb.text = @"12345678901";
    [self addSubview:_phoneLb];
    
    _addressIMg = [[UIImageView alloc]init];
    _addressIMg.image = [UIImage imageNamed:@"addess"];
    [self addSubview:self.addressIMg];
    
    _addressLb = [[UILabel alloc]init];
    _addressLb.text = @"上海市黄浦区凤阳路29号";
    _addressLb.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.addressLb];
    
    _arrowImg = [[UIImageView alloc]init];
    _arrowImg.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:_arrowImg];
}

-(void)layOutUI{

    [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(36);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self.phoneLb.mas_left).offset(-15);
    }];
    
    [_phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLb);
        make.right.equalTo(self).offset(-35);
        make.width.mas_equalTo(120);
    }];
    
    [_addressIMg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLb.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(17);
    }];
    
    [_addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLb.mas_bottom).offset(5);
        make.left.equalTo(self.addressIMg.mas_right).offset(8);
    }];
    
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];
}

@end
