//
//  managerDetailCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "managerDetailCell.h"

@implementation managerDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.nameLb = [[UILabel alloc]init];
    self.nameLb.text = @"流潋紫";
    self.nameLb.font = [UIFont systemFontOfSize:17];
    self.nameLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    [self addSubview:self.nameLb];
    
    self.phoneLb = [[UILabel alloc]init];
    self.phoneLb.text = @"12345678901";
    self.phoneLb.textAlignment = NSTextAlignmentRight;
    self.phoneLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    [self addSubview:self.phoneLb];
    
    self.addressLb = [[UILabel alloc]init];
    self.addressLb.text = @"上海市 黄浦区 凤阳路29号";
    self.addressLb.font = [UIFont systemFontOfSize:17];
    self.addressLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    [self addSubview:self.addressLb];
}

-(void)layOutUI{

    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.phoneLb.mas_left).offset(-15);
    }];
    
    [self.phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(120);
    }];
    
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.nameLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
}

-(void)setModel:(checkAddressModel *)model{

    self.nameLb.text = model.consignee;
    self.phoneLb.text = model.phone;
    self.addressLb.text = model.address;
}

@end
