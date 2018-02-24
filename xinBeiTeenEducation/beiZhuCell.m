//
//  beiZhuCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/5.
//  Copyright © 2017年 user. All rights reserved.
//

#import "beiZhuCell.h"

@implementation beiZhuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    self.headLb = [[copyLable alloc]init];
    self.headLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    self.headLb.font = [UIFont systemFontOfSize:17];
    self.headLb.numberOfLines = 0;
    [self.contentView addSubview:self.headLb];
    
    self.headLb1 = [[copyLable alloc]init];
    self.headLb1.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    self.headLb1.numberOfLines = 0;
    self.headLb1.font = [UIFont systemFontOfSize:17];
    
    self.headLb1.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    
    [self.headLb1 addGestureRecognizer:headTap];
    [self.contentView addSubview:self.headLb1];
    
    self.headLb2 = [[copyLable alloc]init];
    self.headLb2.numberOfLines = 0;
    self.headLb2.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    self.headLb2.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.headLb2];
}

-(void)layoutUI{

    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];

    [self.headLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headLb.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
    
    [self.headLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headLb1.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
}

-(void)headTap:(UITapGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(onPhoneInCell:)]) {
            [_delegate onPhoneInCell:self];
        }
    }
}

@end
