//
//  noAttentionCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "noAttentionCell.h"
#import "ETRegularUtil.h"

@implementation noAttentionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        [self layout];
        
    }
    return self;
}

-(void)createView{
    
    self.headImage = [[UIImageView alloc]init];
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.userInteractionEnabled = YES;
    self.headImage.image = [UIImage imageNamed:@"ride_snap_default"];
    [self addSubview:self.headImage];
    
    self.titilelable = [[UILabel alloc]init];
    [self addSubview:self.titilelable];
    
    self.contLable = [[UILabel alloc]init];
    self.contLable.textColor = [UIColor lightGrayColor];
    self.contLable.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.contLable];
    
    self.addButton = [[UIButton alloc]init];
    self.addButton.layer.cornerRadius = 5;
    self.addButton.userInteractionEnabled = YES;
//    self.addButton.backgroundColor = [UIColor redColor];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    
}

-(void)layout{
    
    __weak typeof(self)weakSelf = self;
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.titilelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(15);
        make.left.equalTo(weakSelf.headImage.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.contLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titilelable.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.titilelable.mas_left);
        make.right.equalTo(weakSelf.addButton.mas_left).offset(-5);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-15);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
    }];
}

-(void)setNoAtendModel:(noAttionModel *)noAtendModel{

    _noAtendModel = noAtendModel;
    DDLog(@"%@",_noAtendModel);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:noAtendModel.typeImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    
      self.titilelable.text = noAtendModel.typeName;
    
    if ([ETRegularUtil isEmptyString:[noAtendModel.namicInfoBean objectForKey:@"content"]]) {
        
        self.contLable.text = @"";
    }else{
    
        self.contLable.text = [noAtendModel.namicInfoBean objectForKey:@"content"];
    }
}

-(void)addBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(addAttentionInCell:)]) {
        [_delegate addAttentionInCell:self];
    }
}

@end
