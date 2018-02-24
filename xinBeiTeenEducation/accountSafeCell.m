
//
//  accountSafeCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "accountSafeCell.h"

@implementation accountSafeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.nameLb = [[UILabel alloc]init];
    [self addSubview:self.nameLb];
    
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.font = [UIFont systemFontOfSize:14];
    self.contentLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.contentLb];
    
    _headImg = [[UIImageView alloc]init];
//    _headImg.image = [UIImage imageNamed:@"password1"];
    [self addSubview:_headImg];
    
    _redImg = [[UIImageView alloc]init];
//    _redImg.backgroundColor = [UIColor redColor];
    _redImg.layer.cornerRadius = 4;
    _redImg.layer.masksToBounds = YES;
    [self addSubview:_redImg];
    
    _arrowImg = [[UIImageView alloc]init];
    _arrowImg.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:_arrowImg];
}

-(void)layOutUI{

    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.headImg.mas_left).offset(-5);
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.redImg.mas_left).offset(-5);
    }];
    
    [self.redImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrowImg.mas_left).offset(-15);
        make.width.height.mas_equalTo(8);
    }];
    
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
}

@end
