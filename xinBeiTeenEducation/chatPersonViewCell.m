//
//  chatPersonViewCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "chatPersonViewCell.h"

@implementation chatPersonViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutPersonUI];
    }
    return self;
}

-(void)createView{

    self.imgView = [[UIImageView alloc]init];
    self.imgView.layer.cornerRadius = 32.5;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.userInteractionEnabled = YES;
    [self.headView addSubview:self.imgView];
    
    self.headLab = [[UILabel alloc]init];
    self.headLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:self.headLab];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.lineView];
    
    self.nameLable = [[UILabel alloc]init];
    [self.headView addSubview:self.nameLable];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.sepeView];

}

-(void)layoutPersonUI{
    __weak typeof(self)weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView).offset(20);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.width.height.mas_equalTo(65);
    }];
    
    [self.headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgView.mas_bottom);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headLab.mas_bottom).offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.headView).offset(15);
        make.bottom.equalTo(weakSelf.sepeView.mas_top).offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
}


@end
