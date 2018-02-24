//
//  personDataOtherCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "personDataOtherCell.h"

@implementation personDataOtherCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layout];
    }
    return self;
}

-(void)createView{
    
    self.titleLb = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLb];
    
    self.headLb = [[UILabel alloc]init];
    self.headLb.textColor = [UIColor lightGrayColor];
    [self.headLb sizeToFit];
    self.headLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.headLb];
    
    self.arrowImg = [[UIImageView alloc]init];
    self.arrowImg.image = [UIImage imageNamed:@"jiantou"];
    [self.contentView addSubview:self.arrowImg];
}

-(void)layout{
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [_headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLb.mas_right).offset(10);
        make.right.equalTo(self.arrowImg.mas_left).offset(-10);
        
    }];
}


@end
