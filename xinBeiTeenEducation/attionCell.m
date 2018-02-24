//
//  attionCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "attionCell.h"
#import "ETRegularUtil.h"

@implementation attionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        [self layout];
    }
    return self;
}

-(void)createView{

    self.headImage = [[UIImageView alloc]init];
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.userInteractionEnabled = YES;
    self.headImage.image = [UIImage imageNamed:@"ride_snap_default"];
    [self.contentView addSubview:self.headImage];
    
    self.titilelable = [[UILabel alloc]init];
    [self.contentView addSubview:self.titilelable];
    
    self.contLable = [[UILabel alloc]init];
    self.contLable.textColor = [UIColor lightGrayColor];
    self.contLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.contLable];
    
    self.deleteBtn = [[UIButton alloc]init];
//  self.timeLb.textAlignment = NSTextAlignmentRight;
//  self.timeLb.textColor = [UIColor lightGrayColor];
//  self.timeLb.font = [UIFont systemFontOfSize:12];
    
    [self.deleteBtn setImage:[UIImage imageNamed:@"noAttention"] forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.deleteBtn];
}

-(void)layout{
    
    __weak typeof(self)weakSelf = self;
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.titilelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.headImage.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.contLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titilelable.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.titilelable.mas_left);
        make.right.equalTo(weakSelf.deleteBtn.mas_left).offset(-15);
    }];

    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
}

-(void)setNamicModel:(namicInfoBeanModel *)namicModel{

    _namicModel = namicModel;
    DDLog(@"%@",namicModel);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:namicModel.typeImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];

    self.titilelable.text = namicModel.typeName;
    if ([ETRegularUtil isEmptyString:[namicModel.namicInfoBean objectForKey:@"content"]]) {
        
        self.contLable.text = @"";
    }else{
        
        self.contLable.text = [namicModel.namicInfoBean objectForKey:@"content"];
    }
    
//  NSArray *timeArray = [[namicModel.namicInfoBean objectForKey:@"createDate"] componentsSeparatedByString:@" "];
    
//  self.timeLb.text = [timeArray lastObject];
}

-(void)deleteBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(onDeleteOrderInCell:)]) {
        [_delegate onDeleteOrderInCell:self];
    }
}

@end
