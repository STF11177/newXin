//
//  payImgCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "payImgCell.h"

@implementation payImgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    _bookLb = [[UILabel alloc]init];
    _bookLb.text = @"三生三世十里桃花";
    [self addSubview:_bookLb];
    
    _bookImg = [[UIImageView alloc]init];
    _bookImg.image = [UIImage imageNamed:@"lianjie"];
    _bookImg.contentMode = UIViewContentModeScaleAspectFill;
    _bookImg.clipsToBounds = YES;
    [self addSubview:_bookImg];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.text = @"2015年中国年度小学生优秀作文盛典";
    _titleLb.textColor = [UIColor lightGrayColor];
    [self addSubview:_titleLb];
    
    _priceLb = [[UILabel alloc]init];
    _priceLb.text = @"¥255";
    _priceLb.textColor = [UIColor redColor];
    [self addSubview:_priceLb];

    _numberLb = [[UILabel alloc]init];
    _numberLb.text = @"x1";
    [self addSubview:_numberLb];
}

-(void)layOutUI{
    
    [_bookImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    
    [_bookLb mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.bookImg.mas_top).offset(2);
        make.left.equalTo(self.bookImg.mas_right).offset(15);
        make.right.equalTo(self).offset(15);
    }];
    
    [_priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.bookImg.mas_bottom);
        make.left.equalTo(self.bookLb.mas_left);
    }];
    
    [_numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.priceLb);
    }];
}

@end
