//
//  interReplyView.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/10.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interReplyView.h"

@implementation interReplyView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self.imageView addSubview:self.titleLable];
        [self layOutUI];
    }
    return self;
}

-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"inter_background"];
    }
    return _imageView;
}

-(UILabel *)titleLable{
    
    if (!_titleLable) {
    
        _titleLable = [[UILabel alloc]init];
        _titleLable.text = @"人生若只如初见，何事秋风悲画扇";
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.alpha = 0.7;
        _titleLable.numberOfLines = 0;
    }
    return _titleLable;
}


-(void)layOutUI{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(ScreenWidth -30);
        make.height.mas_equalTo(self.mas_height);
    }];
}

-(CGFloat)cellHeightWithString:(NSString *)titleStr{
    
    self.titleLable.text = titleStr;
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH -30, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    CGRect contenRect = [self.titleLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return contenRect.size.height;
}

@end
