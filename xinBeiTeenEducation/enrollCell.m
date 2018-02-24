
//
//  enrollCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import "enrollCell.h"

@implementation enrollCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    [self createBtn];
    [self layoutUI];
}
    return self;
}

-(void)createBtn{
    
    self.introduceLb = [[UILabel alloc]init];
    self.introduceLb.text = @"介绍";
    [self addSubview:self.introduceLb];
    
    self.contentLb = [[copyLable alloc]init];
    self.contentLb.textColor = [UIColor lightGrayColor];
    self.contentLb.font = [UIFont systemFontOfSize:16];
    self.contentLb.numberOfLines = 0;
    [self addSubview:self.contentLb];
    
    self.sepeBtnView = [[UIView alloc]init];
    self.sepeBtnView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeBtnView];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.lineView];
}

-(void)layoutUI{
    [self.sepeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
    }];
    
    [self.introduceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepeBtnView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        make.width.mas_equalTo(80);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.introduceLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];

    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
}

@end
