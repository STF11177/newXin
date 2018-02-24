//
//  cashCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "cashCell.h"

@implementation cashCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    self.cashLb = [[UILabel alloc]init];
    self.cashLb.text = @"现金劵";
     self.cashLb.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.cashLb];
    
    self.cashDetailLb = [[UILabel alloc]init];
    self.cashDetailLb.text = @"暂无现金券";
    self.cashDetailLb.textAlignment = NSTextAlignmentRight;
    self.cashDetailLb.textColor = [UIColor orangeColor];
    [self addSubview:self.cashDetailLb];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView];
}

-(void)layoutUI{

    [self.cashLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self.sepeView.mas_top).offset(-15);
    }];
    
    [self.cashDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self.sepeView.mas_top).offset(-15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.mas_equalTo(100);
    }];
    
    [self.sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
    }];
}

@end
