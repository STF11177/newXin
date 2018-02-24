

//
//  payPriceCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payPriceCell.h"

@implementation payPriceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    self.courseLb = [[UILabel alloc]init];
    self.courseLb.text = @"课程价格";
    self.courseLb.font = [UIFont systemFontOfSize:16];
    self.courseLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.courseLb];
    
    self.coursePriceLb = [[UILabel alloc]init];
    self.coursePriceLb.text = @"¥150.00";
    self.coursePriceLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.coursePriceLb];
    
    self.discountLb = [[UILabel alloc]init];
    self.discountLb.text = @"已优惠";
    self.discountLb.font = [UIFont systemFontOfSize:16];
    self.discountLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.discountLb];
    
    self.discountPriceLb = [[UILabel alloc]init];
    self.discountPriceLb.text = @"-¥0.00";
    self.discountPriceLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.discountPriceLb];
    
    self.shouldPayLb = [[UILabel alloc]init];
    self.shouldPayLb.text = @"需支付";
    self.shouldPayLb.font = [UIFont systemFontOfSize:16];
    self.shouldPayLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.shouldPayLb];
    
    self.shouldPayPriceLb = [[UILabel alloc]init];
    self.shouldPayPriceLb.text = @"¥150.00";
    self.shouldPayPriceLb.textColor = [UIColor orangeColor];
    self.shouldPayPriceLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.shouldPayPriceLb];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.lineView];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView];
}

-(void)layoutUI{

    [self.courseLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.coursePriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.discountPriceLb.mas_top).offset(-5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.discountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.courseLb.mas_bottom).offset(5);
        make.left.equalTo(self.courseLb.mas_left);
        make.bottom.equalTo(self.lineView.mas_top).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.discountPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.coursePriceLb.mas_bottom).offset(5);
        make.bottom.equalTo(self.discountLb.mas_bottom);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.discountLb.mas_bottom).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(2);
    }];
    
    [self.shouldPayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.courseLb.mas_left);
        make.bottom.equalTo(self.sepeView.mas_top).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.shouldPayPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.shouldPayLb.mas_top);
        make.bottom.equalTo(self.shouldPayLb.mas_bottom);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.shouldPayLb.mas_bottom).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
    }];
}

@end
