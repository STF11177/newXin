//
//  orderCompleteCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "orderCompleteCell.h"

@implementation orderCompleteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.titleLable = [[UILabel alloc]init];
    [self addSubview:self.titleLable];
}

-(void)layOutUI{

    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
      
    }];

}

@end
