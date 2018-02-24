//
//  inviteCodeView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "inviteCodeView.h"

@implementation inviteCodeView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.headLb = [[UILabel alloc]init];
    self.headLb.text = @"您的邀请码";
    [self.backView addSubview:self.headLb];
    
    self.inviteBtn = [[UIButton alloc]init];
    self.inviteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.inviteBtn setTitle:@"复制" forState:UIControlStateNormal];
    [self.backView addSubview:self.inviteBtn];
    
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor colorWithHexString:@"#1b82d2"];
    [self addSubview:self.backView];
    
    self.inviteImg = [[UIImageView alloc]init];
    self.inviteImg.image = [UIImage imageNamed:@"diyq"];
    [self addSubview:self.inviteImg];
    
    self.inviteLb = [[UILabel alloc]init];
    self.inviteLb.text = @"UUJZYQ9868N";
    [self addSubview:self.inviteLb];
    
    self.introduceLb = [[UILabel alloc]init];
    self.introduceLb.text = @"每成功邀请一个好友，即可获得一张抵用券";
    [self addSubview:self.introduceLb];
}

-(void)layOutUI{

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(SCREEN_WIDTH*0.07);
        make.height.mas_equalTo(88);
        make.width.mas_equalTo(SCREEN_WIDTH - SCREEN_WIDTH*0.07*2);
    }];

    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backView.mas_left).offset(20);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.backView.mas_right).offset(-20);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.inviteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headLb.mas_bottom).offset(20);
        make.left.equalTo(self.headLb.mas_left);
        make.right.equalTo(self.headLb.mas_right);
    }];
}

@end
