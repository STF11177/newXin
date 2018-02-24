


//
//  payDetailCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payDetailCell.h"

@implementation payDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    self.headLb = [[UILabel alloc]init];
    self.headLb.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.headLb];
    
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.font = [UIFont systemFontOfSize:15];
    self.contentLb.textAlignment = NSTextAlignmentRight;
    self.contentLb.numberOfLines = 0;
    self.contentLb.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.contentLb];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutUI{

    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentLb.mas_left).offset(-15);
        
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        
    }];
}

@end
