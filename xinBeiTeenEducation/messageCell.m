//
//  messageCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import "messageCell.h"

@implementation messageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.titleLb];
//        [self.contentView addSubview:self.pictureView];
        [self.contentView addSubview:self.contentLb];
        [self.contentView addSubview:self.timeLb];
        
        [self layOut];
    }
    return self;
}

-(UIImageView *)headImgView{
    
    if (!_headImgView) {
        
        _headImgView = [[UIImageView alloc]init];
        _headImgView.image = [UIImage imageNamed:@"ride_snap_default"];
        _headImgView.layer.cornerRadius = 22.5;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.userInteractionEnabled = YES;
    }
    return _headImgView;
}

-(UILabel *)titleLb{
    
    if (!_titleLb) {
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.text = @"🌈 回复了 晴天";
        _titleLb.numberOfLines = 2;
        _titleLb.font = [UIFont systemFontOfSize:17];
    }
    return _titleLb;
}

-(UIImageView *)pictureView{
    
    if (!_pictureView) {
        
        _pictureView = [[UIImageView alloc]init];
        _pictureView.image = [UIImage imageNamed:@"ride_snap_default"];
        _pictureView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureView;
}

-(UILabel *)contentLb{
    
    if (!_contentLb) {
        
        _contentLb = [[UILabel alloc]init];
        _contentLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
        _contentLb.font = [UIFont systemFontOfSize:15];
        _contentLb.text = @"人生若只如初见，何事秋风悲画扇。";
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}

-(UILabel *)timeLb{
    
    if (!_timeLb) {
        
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = [UIColor lightGrayColor];
        _timeLb.text = @"12-7";
    }
    return _timeLb;
}

-(void)layOut{
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.left.equalTo(self.titleLb.mas_left);
        make.right.equalTo(self.contentView).offset(55);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.titleLb.mas_top);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

-(void)setModel:(messageModel *)model{
    
    _model = model;
    self.titleLb.text = model.title;
    self.contentLb.text = model.context;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",model.createDate];
    self.timeLb.text = timeStr;
}

@end
