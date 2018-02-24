//
//  sendStyleCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "sendStyleCell.h"

@implementation sendStyleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.headLb = [[UILabel alloc]init];
    self.headLb.text = @"配送方式";
    self.headLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.headLb];
    
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.text = @"快递费 5元";
    self.contentLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.contentLb];
    
    _arrowIMg = [[UIImageView alloc]init];
    _arrowIMg.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:_arrowIMg];
}

-(void)layOutUI{

    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];

    [self.arrowIMg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];

    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.arrowIMg.mas_left).offset(-10);
        make.centerY.equalTo(self);
    }];
}

@end
