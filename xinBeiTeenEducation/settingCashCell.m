//
//  settingCashCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import "settingCashCell.h"

@implementation settingCashCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
    self.cashImgView = [[UIImageView alloc]init];
    self.cashImgView.image = [UIImage imageNamed:@"shu_bian"];

    [self.contentView addSubview:self.cashImgView];

    self.priceView = [[UIView alloc]init];
    self.priceView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    [self.contentView addSubview:self.priceView];
    
    self.cashView = [[UIView alloc]init];
    self.cashView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.cashView];
    
    self.leftImgView = [[UIImageView alloc]init];
    self.leftImgView.image = [UIImage imageNamed:@"border_xian"];
    [self.contentView addSubview:self.leftImgView];

    self.priceLb = [[UILabel alloc]init];
    self.priceLb.text = @"¥10";
    self.priceLb.font = [UIFont systemFontOfSize:17];
    self.priceLb.textColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.contentView addSubview:self.priceLb];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"抵用券";
    self.titleLb.textColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self.contentView addSubview:self.titleLb];
    
    self.headLb = [[UILabel alloc]init];
    self.headLb.text = @"考证10元课程抵用券";
    [self.contentView addSubview:self.headLb];
    
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.font = [UIFont systemFontOfSize:14];
    self.contentLb.text = @"抵用券";
    self.contentLb.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:self.contentLb];
    
    self.dateLb = [[UILabel alloc]init];
    self.dateLb.text = @"2017-08-08 至 2017-09-10";
    self.dateLb.textColor = [UIColor colorWithHexString:@"#999999"];
    self.dateLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.dateLb];
    
//    self.sepeView = [[UIView alloc]init];
//    self.sepeView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:self.sepeView];
}

-(void)layOutUI{

    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(100);
    }];

    [self.cashView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.priceView.mas_right);
        make.height.mas_equalTo(100);
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(30);
        make.left.equalTo(self.contentView).offset(40);
    }];

    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLb.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(35);
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceView.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(100);
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLb.mas_top);
        make.left.equalTo(self.priceView.mas_right).offset(15);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLb.mas_top);
        make.left.equalTo(self.headLb.mas_left);
    }];
    
    [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLb.mas_top);
        make.left.equalTo(self.contentLb.mas_right);
    }];
    
    [self.cashImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self.cashView.mas_right);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(100);
    }];
    
//    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.cashView.mas_bottom).offset(-15);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.height.mas_equalTo(15);
//    }];
}

@end
