//
//  testTimeCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testTimeCell.h"

@implementation testTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
 
    self.planLb = [[copyLable alloc]init];
    self.planLb.text = @"考试安排";
    [self addSubview:self.planLb];
    
    self.endTimeLb = [[copyLable alloc]init];
    self.endTimeLb.text = @"报名截止时间：2016-8-20";
    self.endTimeLb.font = [UIFont systemFontOfSize:16];
    self.endTimeLb.textColor = [UIColor lightGrayColor];
//    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.endTimeLb.text];
//    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 7)];
//    self.endTimeLb.attributedText = centStr;
    [self addSubview:self.endTimeLb];
    
    self.testTimeLb = [[copyLable alloc]init];
    self.testTimeLb.text = @"考试时间：2016.08.30 AM8:30~9:30";
    self.testTimeLb.font = [UIFont systemFontOfSize:16];
    self.testTimeLb.textColor = [UIColor lightGrayColor];
//    NSMutableAttributedString *centStr1 = [[NSMutableAttributedString alloc]initWithString:self.testTimeLb.text];
//    [centStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
//    self.testTimeLb.attributedText = centStr1;
    [self addSubview:self.testTimeLb];
    
    self.priceLb = [[copyLable alloc]init];
    self.priceLb.text = @"报名费用：150元/课";
    self.priceLb.font = [UIFont systemFontOfSize:16];
    self.priceLb.textColor = [UIColor lightGrayColor];
//    NSMutableAttributedString *centStr3 = [[NSMutableAttributedString alloc]initWithString:self.priceLb.text];
//    [centStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
//    self.priceLb.attributedText = centStr3;
    [self addSubview:self.priceLb];
    
    self.adressLb = [[copyLable alloc]init];
    self.adressLb.text = @"考场地址：上海市鲁班路369号";
    self.adressLb.font = [UIFont systemFontOfSize:16];
    self.adressLb.textColor = [UIColor lightGrayColor];
//    NSMutableAttributedString *centStr4 = [[NSMutableAttributedString alloc]initWithString:self.adressLb.text];
//    [centStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
//    self.adressLb.attributedText = centStr4;
    [self addSubview:self.adressLb];
    
    self.admissionCardLb = [[copyLable alloc]init];
    self.admissionCardLb.text = @"准考证领取地址：凤阳路29号12F";
    self.admissionCardLb.font = [UIFont systemFontOfSize:16];
    self.admissionCardLb.textColor = [UIColor lightGrayColor];
//    NSMutableAttributedString *centStr5 = [[NSMutableAttributedString alloc]initWithString:self.admissionCardLb.text];
//    [centStr5 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8)];
//    self.admissionCardLb.attributedText = centStr5;
    [self addSubview:self.admissionCardLb];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.lineView];
    
}

-(void)layoutUI{

    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
    }];
    
    [self.planLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepeView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(80);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.planLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.left.equalTo(self.planLb.mas_left);
    }];
    
    [self.testTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.endTimeLb.mas_bottom).offset(5);
        make.left.equalTo(self.planLb.mas_left);
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.testTimeLb.mas_bottom).offset(5);
        make.left.equalTo(self.planLb.mas_left);
    }];
    
    [self.adressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLb.mas_bottom).offset(5);
        make.left.equalTo(self.planLb.mas_left);
    }];
    
    [self.admissionCardLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.adressLb.mas_bottom).offset(5);
        make.left.equalTo(self.planLb.mas_left);
    }];

}

@end
