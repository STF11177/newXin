//
//  timeAndAdresCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "timeAndAdresCell.h"

@implementation timeAndAdresCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self =[super initWithStyle:style  reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    

    
    self.adressLb = [[UILabel alloc]init];
    self.adressLb.font = [UIFont systemFontOfSize:17];
    self.adressLb.textAlignment = NSTextAlignmentLeft;
    self.adressLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self.contentView addSubview:self.adressLb];
    
    self.timeLb = [[UILabel alloc]init];
    self.timeLb.font = [UIFont systemFontOfSize:17];
    self.timeLb.numberOfLines = 0;
    self.timeLb.textAlignment = NSTextAlignmentRight;
    self.timeLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self.timeLb sizeToFit];
    [self.contentView addSubview:self.timeLb];
    
    _arrowImg = [[UIImageView alloc]init];
    _arrowImg.image =[UIImage imageNamed:@"jiantou"];
    [self addSubview:_arrowImg];
    
    _headLb = [[UILabel alloc]init];
    _headLb.text = @"领取地点";
    self.headLb.font = [UIFont systemFontOfSize:17];
    self.headLb.textAlignment = NSTextAlignmentLeft;
    self.headLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self addSubview:_headLb];
}

-(void)layOutUI{

    [self.adressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 15);
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
//      make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(70);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.headLb.mas_right).offset(5);
        make.right.equalTo(self.arrowImg.mas_left).offset(-15);
    }];
    
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];
}

@end
