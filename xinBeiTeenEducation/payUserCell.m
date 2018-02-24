//
//  payUserCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payUserCell.h"

@implementation payUserCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"考生信息";
    self.titleLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.titleLb];
    
    self.nameLb = [[UILabel alloc]init];
    self.nameLb.font = [UIFont systemFontOfSize:17];
    self.nameLb.textAlignment = NSTextAlignmentRight;
    self.nameLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.nameLb];
    
    self.phoneLb = [[UILabel alloc]init];
    self.phoneLb.textAlignment = NSTextAlignmentRight;
    self.phoneLb.font = [UIFont systemFontOfSize:17];
    self.phoneLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.phoneLb];
    
    self.arrowImage = [[UIImageView alloc]init];
    self.arrowImage.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:self.arrowImage];
}

-(void)layoutUI{
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.nameLb.mas_left).offset(-15);
        
    }];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.phoneLb.mas_left).offset(-15);
        
    }];
    
    [self.phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLb.mas_right).offset(15);
        make.right.equalTo(self.arrowImage.mas_left).offset(-15);
        
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
        
    }];
}

@end
