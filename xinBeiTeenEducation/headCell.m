//
//  headCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "headCell.h"

@implementation headCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{

    _headImage = [[UIImageView alloc]init];
    _headImage.layer.cornerRadius = 17.5;
//  _headImage.layer.masksToBounds = YES;
    _headImage.userInteractionEnabled = YES;
    [self addSubview:_headImage];
    
    _titleLb = [[UILabel alloc]init];
    [self addSubview:_titleLb];

    _pointImg = [[UIImageView alloc]init];
    _pointImg.layer.cornerRadius = 4;
    _pointImg.layer.masksToBounds = YES;
    [self addSubview:_pointImg];
    
    _arrowImg = [[UIImageView alloc]init];
    _arrowImg.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:_arrowImg];
}

-(void)layoutUI{
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(24);
        
    }];
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_headImage.mas_right).offset(15);
        
    }];
    
    [_pointImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-38);
        make.width.height.mas_equalTo(8);
    }];
    
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
}

- (void)setCellWithModel:(mineModel *)model {
    
    self.headImage.image = [UIImage imageNamed:model.headImageName];
    self.titleLb.text = model.titleLb;
}

@end
