//
//  eBookCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/18.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eBookCell.h"

@implementation eBookCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _eBookImgView = [[UIImageView alloc]init];
        _eBookImgView.image = [UIImage imageNamed:@"book_background"];
        [self addSubview:_eBookImgView];
        
        [self layOutUI];
    }
    return self;
}

-(void)layOutUI{
    
    [self.eBookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(125);
    }];
}

-(void)setModel:(eBookModel *)model{
    
    _model = model;
    [_eBookImgView sd_setImageWithURL:[NSURL URLWithString:model.iconImg] placeholderImage:[UIImage imageNamed:@"book_background"]];
}

@end
