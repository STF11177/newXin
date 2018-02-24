//
//  bugHeadCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bugHeadCell.h"

@implementation bugHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.issueBtn = [[UIButton alloc]init];
    [self.issueBtn setTitle:@"问题反馈" forState:UIControlStateNormal];
    self.issueBtn.layer.cornerRadius = 10;
    [self.issueBtn setBackgroundColor:[UIColor colorWithHexString:@"#3696d3"]];
    [self.issueBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.issueBtn];
}

-(void)layOutUI{

    [self.issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(30);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.width.mas_equalTo(SCREEN_WIDTH - 80);
        make.height.mas_equalTo(40);
    }];
}

-(void)backBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(issueBtnInCell:)]) {
        [_delegate issueBtnInCell:self];
    }
}

@end
