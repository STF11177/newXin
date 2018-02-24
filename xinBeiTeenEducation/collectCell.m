//
//  collectCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/12.
//  Copyright © 2017年 user. All rights reserved.
//

#import "collectCell.h"

@implementation collectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    _titleLb = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLb];
    
    _arrowImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_arrowImg];
}

-(void)layoutUI{

    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(120);
    }];

    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];
}

@end
