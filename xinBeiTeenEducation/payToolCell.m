
//
//  payToolCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payToolCell.h"

@implementation payToolCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
        
    }
    return self;
}

-(void)createView{

    self.toolImageView = [[UIImageView alloc]init];
    self.toolImageView.image = [UIImage imageNamed:@"wicuh"];

    [self addSubview:self.toolImageView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.font = [UIFont systemFontOfSize:15];
//    self.titleLb.backgroundColor = [UIColor grayColor];
    [self addSubview:self.titleLb];
    
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.font = [UIFont systemFontOfSize:15];
//  self.contentLb.backgroundColor = [UIColor grayColor];
    [self addSubview:self.contentLb];
}

-(void)layoutUI{

    [self.toolImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(32);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolImageView.mas_top).offset(-8);
        make.left.equalTo(self.toolImageView.mas_right).offset(15);
        make.width.mas_equalTo(70);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.left.equalTo(self.titleLb);
        make.width.mas_equalTo(SCREEN_WIDTH - 35 - 15);
    }];
    
}

@end
