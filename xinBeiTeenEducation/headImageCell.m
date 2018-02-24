//
//  headImageCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import "headImageCell.h"

@implementation headImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
    
    self.headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.headImageView];
    
    self.headLb = [[UILabel alloc]init];
    self.headLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    self.headLb.font = [UIFont systemFontOfSize:17];
    self.headLb.numberOfLines = 0;
    [self.contentView addSubview:self.headLb];
    
    self.priceLb = [[UILabel alloc]init];
    self.priceLb.textColor = [UIColor orangeColor];
    self.priceLb.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.priceLb];
    
    self.arrowImage = [[UIImageView alloc]init];
    self.arrowImage.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:self.arrowImage];
}

-(void)layoutUI{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top).offset(5);
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.right.equalTo(self.arrowImage.mas_left).offset(-5);
        
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headLb.mas_bottom).offset(5);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
        
    }];
}



@end
