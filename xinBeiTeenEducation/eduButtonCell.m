//
//  eduButtonCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduButtonCell.h"
#import "CommonSheet.h"

@implementation eduButtonCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
    self.eduBtn1 = [[UIButton alloc]init];
    [self.eduBtn1 setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.eduBtn1 setTitle:@"正品保证" forState:UIControlStateNormal];
    [self.eduBtn1 setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
    self.eduBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.eduBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self addSubview:self.eduBtn1];
    
    self.eduBtn2 = [[UIButton alloc]init];
    [self.eduBtn2 setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.eduBtn2 setTitle:@"极速退款" forState:UIControlStateNormal];
    [self.eduBtn2 setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
    self.eduBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.eduBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self addSubview:self.eduBtn2];
    
    self.eduBtn3 = [[UIButton alloc]init];
    [self.eduBtn3 setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.eduBtn3 setTitle:@"公益宝贝" forState:UIControlStateNormal];
    [self.eduBtn3 setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
    self.eduBtn3.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.eduBtn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self addSubview:self.eduBtn3];
    
    self.eduBtn4 = [[UIButton alloc]init];
    [self.eduBtn4 setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.eduBtn4 setTitle:@"七天退换" forState:UIControlStateNormal];
    [self.eduBtn4 setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
    self.eduBtn4.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.eduBtn4 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self addSubview:self.eduBtn4];

}

-(void)layOutUI{

    [self.eduBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(self.mas_width).dividedBy(4);
        make.bottom.equalTo(self).offset(-0.5);
    }];
    
    [self.eduBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.eduBtn1.mas_right);
        make.centerY.equalTo(self);
        make.width.equalTo(self.mas_width).dividedBy(4);
        make.bottom.equalTo(self).offset(-0.5);
    }];

    [self.eduBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.eduBtn2.mas_right);
        make.centerY.equalTo(self);
        make.width.equalTo(self.mas_width).dividedBy(4);
        make.bottom.equalTo(self).offset(-0.5);
    }];

    [self.eduBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.eduBtn3.mas_right);
        make.centerY.equalTo(self);
        make.width.equalTo(self.mas_width).dividedBy(4);
        make.bottom.equalTo(self).offset(-0.5);
    }];
}

@end
