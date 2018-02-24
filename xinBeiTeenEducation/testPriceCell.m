//
//  testPriceCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testPriceCell.h"

@implementation testPriceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.headView = [[UIImageView alloc]init];
    self.headView.image = [UIImage imageNamed:@"shuxian"];
    [self.contentView addSubview:self.headView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"考试费用";
    self.titleLb.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.titleLb];
    
    self.headLb = [[UILabel alloc]init];
    self.headLb.font = [UIFont systemFontOfSize:17];
    self.headLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self.contentView addSubview:self.headLb];
    
    self.priceLb = [[UILabel alloc]init];
    self.priceLb.font = [UIFont systemFontOfSize:17];
    self.priceLb.textAlignment = NSTextAlignmentRight;
    self.priceLb.textColor = [UIColor colorWithHexString:@"#ff6600"];
    [self.contentView addSubview:self.priceLb];
}

-(void)layOutUI{

    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.titleLb.mas_left).offset(-15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(15);
        make.top.equalTo(self.headView.mas_top);
        
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.priceLb.mas_left).offset(15);
        
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(70);
    }];
}

-(void)setDetailModel:(textDetailListModel *)detailModel{

    self.headLb.text = detailModel.type_name;
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",detailModel.subject_money];
    self.priceLb.text = priceStr;
}

@end
