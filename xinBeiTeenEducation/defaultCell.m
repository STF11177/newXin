//
//  defaultCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "defaultCell.h"

@implementation defaultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    _headLable = [[UILabel alloc]init];
    _headLable.text = @"设置为默认";
    [self addSubview:_headLable];
    
    self.switchBtn = [[UISwitch alloc]init];
    [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchBtn];
}

-(void)layOutUI{

    [_headLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
}

-(void)switchAction:(UISwitch*)Btn{

    if (_delegate && [_delegate respondsToSelector:@selector(onSwitchInCell:)]) {
        [_delegate onSwitchInCell:self];
    }
}

@end
