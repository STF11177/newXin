//
//  replyFootView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "replyFootView.h"

@implementation replyFootView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
    self.field = [[UITextField alloc]init];
    self.field.text = @"回复评论";
    self.field.backgroundColor = [UIColor whiteColor];
    self.field.textColor = [UIColor lightGrayColor];
    self.field.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.field.layer.borderWidth = 0.5;
    self.field.layer.cornerRadius = 10;
    self.field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.field.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.field];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lineView];
}

-(void)layOutUI{
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(ScreenWidth - 20);
        make.height.mas_equalTo(46);
    }];
}

@end
