//
//  testAddressCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testAddressCell.h"

@implementation testAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self =[super initWithStyle:style  reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
    self.headView = [[UIImageView alloc]init];
    self.headView.image = [UIImage imageNamed:@"shuxian"];
    [self.contentView addSubview:self.headView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"";
    self.titleLb.font = [UIFont systemFontOfSize:17];
    self.titleLb.textColor = [UIColor colorWithHexString:@"#282828"];
    [self.contentView addSubview:self.titleLb];
    
    self.arrowImage = [[UIImageView alloc]init];
    self.arrowImage.image = [UIImage imageNamed:@"jiantou"];
    [self.contentView addSubview:self.arrowImage];
}

-(void)layOutUI{
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.titleLb.mas_left).offset(-15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
        
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(15);
        make.top.equalTo(self.headView.mas_top);
        
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
        
    }];
}

@end
