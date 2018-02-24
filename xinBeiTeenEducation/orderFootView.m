//
//  orderFootView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "orderFootView.h"

@interface orderFootView()

@property (nonatomic,strong) UIView *viewTopLine;//顶部横线
@property (nonatomic,strong) UIView *viewVLine1;//竖线1
@property (nonatomic,strong) UIView *viewVLine2;//竖线2

@end

@implementation orderFootView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{

    self.btnHelp = [[UIButton alloc]init];
    [self.btnHelp setTitle:@"考前辅导" forState:UIControlStateNormal];
    [self.btnHelp setImage:[UIImage imageNamed:@"coach"] forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor colorWithHexString:@"#fe6400"] forState:UIControlStateNormal];
    [self.btnHelp addTarget:self action:@selector(onHelp:) forControlEvents:UIControlEventTouchUpInside];
//  self.btnHelp.backgroundColor = [UIColor redColor];
    self.btnHelp.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btnHelp.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.btnHelp];
    
    self.btnTestCard = [[UIButton alloc]init];
    [self.btnTestCard setTitle:@"准考证下载" forState:UIControlStateNormal];
    [self.btnTestCard setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
//  [self.btnTestCard setImage:[UIImage imageNamed:@"download2"] forState:UIControlStateSelected];
    [self.btnTestCard setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateNormal];
    [self.btnTestCard addTarget:self action:@selector(onTestCard:) forControlEvents:UIControlEventTouchUpInside];
    self.btnTestCard.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btnTestCard.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.btnTestCard];
    
    self.testCardImg = [[UIImageView alloc]init];
    self.testCardImg.image = [UIImage imageNamed:@"bigin"];
    [self addSubview:self.testCardImg];
    
    self.btnScore = [[UIButton alloc]init];
    [self.btnScore setTitle:@"成绩查询" forState:UIControlStateNormal];
    [self.btnScore setImage:[UIImage imageNamed:@"footSuch"] forState:UIControlStateNormal];
//  [self.btnScore setImage:[UIImage imageNamed:@"such2"] forState:UIControlStateNormal];
    [self.btnScore setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateNormal];
    [self.btnScore addTarget:self action:@selector(onScore:) forControlEvents:UIControlEventTouchUpInside];
    self.btnScore.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btnScore.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.btnScore];
    
    self.scoreImg = [[UIImageView alloc]init];
    self.scoreImg.image = [UIImage imageNamed:@"bigin"];
    [self addSubview:self.scoreImg];
    
    UIView *viewTopLine = [UIView new];
    viewTopLine.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:viewTopLine];
    self.viewTopLine = viewTopLine;
    
    UIView *viewVLine1 = [UIView new];
    [self addSubview:viewVLine1];
    viewVLine1.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.viewVLine1 = viewVLine1;
    
    UIView *viewVLine2 = [UIView new];
    [self addSubview:viewVLine2];
    viewVLine2.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.viewVLine2 = viewVLine2;
}

-(void)layOutUI{
    
    [self.viewTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.top.mas_equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(1);
    }];
    
    [self.btnHelp mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self.viewTopLine.mas_bottom);
        make.width.equalTo(self.mas_width).dividedBy(3.5);
    }];
    
    [self.btnTestCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnHelp.mas_right).offset(8);
        make.centerY.equalTo(self.btnHelp.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH/3 -23 - 10);
//      make.right.equalTo(self.testCardImg.mas_left).offset(-5);
        make.height.mas_equalTo(self.btnHelp.mas_height);
    }];
    
    [self.testCardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.btnTestCard.mas_right).offset(5);
//      make.right.equalTo(self.viewVLine2.mas_left).offset(-5);
        make.centerY.equalTo(self.btnHelp.mas_centerY);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(10);
    }];
    
    [self.btnScore mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.btnHelp.mas_centerY);
        make.right.equalTo(self.scoreImg.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH/3 -23 - 10);
        make.height.mas_equalTo(self.btnHelp.mas_height);
    }];
    
    [self.scoreImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.btnHelp.mas_centerY);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(10);
    }];
    
    [self.viewVLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(1);
        make.centerY.equalTo(self.btnHelp.mas_centerY);
        make.left.equalTo(self.btnHelp.mas_right);
//      make.right.equalTo(self.btnTestCard.mas_left).offset(- 3);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
  
    [self.viewVLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(1);
        make.centerY.equalTo(self.btnHelp.mas_centerY);
        make.right.equalTo(self.btnScore.mas_left);
        make.top.equalTo(self.viewVLine1.mas_top);
        make.bottom.equalTo(self.viewVLine1.mas_bottom);
    }];
}

#pragma mark - Action

- (void)onHelp:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onHelp)]) {
        [_delegate onHelp];
    }
}

- (void)onTestCard:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(onTestCard)]) {
        [_delegate onTestCard];
    }
}

- (void)onScore:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onScore)]) {
        [_delegate onScore];
    }
}


@end
