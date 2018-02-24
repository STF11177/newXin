//
//  paySumCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import "paySumCell.h"

@implementation paySumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    _productLb = [[UILabel alloc]init];
    _productLb.text = @"共1件商品";
    [self addSubview:_productLb];
    
    _priceLb = [[UILabel alloc]init];
    _priceLb.text = @"小计：";
    _priceLb.textColor = [UIColor redColor];
    [self addSubview:_priceLb];
}


-(void)layOutUI{

    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];

    [_productLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self.priceLb.mas_left).offset(-10);
    }];
}
@end
