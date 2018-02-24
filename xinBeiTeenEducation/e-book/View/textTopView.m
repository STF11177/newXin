//
//  textTopView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textTopView.h"
#import "LSYReadUtilites.h"

@implementation textTopView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backBtn];
        [self layOutUI];
    }
    return self;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        
        _backBtn = [LSYReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_backBtn setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(void)backView{
    
    [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

-(void)layOutUI{
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(24);
        make.height.width.mas_equalTo(40);
    }];
}

@end
