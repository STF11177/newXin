//
//  testfiCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "testfiCell.h"

@implementation testfiCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI1];
    }
    return self;
}


-(void)createView{

    self.headView.backgroundColor = [UIColor whiteColor];
    
    self.vepeView = [[UIView alloc]init];
    self.vepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.headView addSubview:self.vepeView];
    
    self.imgView = [[UIImageView alloc]init];
    [self.headView addSubview:self.imgView];
    
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.font = [UIFont systemFontOfSize:15];
    [self.headView addSubview:self.titleLable];
    
    self.sexView = [[UIImageView alloc]init];
    self.sexView.image =[UIImage imageNamed:@"ride_snap_default"];
    [self.headView addSubview:self.sexView];
    
    self.nickLable = [[UILabel alloc]init];
    self.nickLable.textColor = [UIColor lightGrayColor];
    self.nickLable.font = [UIFont systemFontOfSize:12];
    
    self.beizhuBtn = [[UIButton alloc]init];
    self.nameLable = [[UILabel alloc]init];
    
    [self.beizhuBtn setTitle:@"修改备注" forState:UIControlStateNormal];
    [self.beizhuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
    self.beizhuBtn.layer.cornerRadius = 5;
    self.beizhuBtn.layer.borderWidth = 0.1;
    [self.beizhuBtn addTarget:self action:@selector(xiuGaiClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLable.text = @"昵称:";
    self.nameLable.textColor = [UIColor lightGrayColor];
    self.nameLable.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:self.nickLable];
    [self addSubview:self.beizhuBtn];
    [self addSubview:self.nameLable];
    
    
}

- (void)layoutUI1{
    __weak typeof(self)weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView).offset(10);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView).offset(10);
        make.left.equalTo(weakSelf.imgView.mas_right).offset(10);
        make.right.equalTo(weakSelf.sexView.mas_left).offset(-10);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLable.mas_top);
        make.left.equalTo(weakSelf.titleLable.mas_right).offset(10);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.beizhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLable.mas_top);
        make.right.equalTo(weakSelf.headView).offset(-15);
        make.width.mas_greaterThanOrEqualTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sexView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.imgView.mas_right).offset(10);
        make.width.mas_equalTo(40);
    }];
    
    [self.nickLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_top);
        make.right.equalTo(weakSelf.headView).offset(-10);
        make.left.equalTo(weakSelf.nameLable.mas_right).offset(-5);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.vepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.bottom.equalTo(weakSelf.headView);
    }];
}

-(void)setMessageMdoel:(messDetailModel *)messageMdoel{

    _messageMdoel = messageMdoel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_messageMdoel.faceImg]placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    
    if (_messageMdoel.remarkName == nil) {
        
        self.titleLable.text = _messageMdoel.nickName;
    }else{
        
        self.titleLable.text = _messageMdoel.remarkName;
    }
    
    NSString *sexStr = [NSString stringWithFormat:@"%@",_messageMdoel.sex];
    if ([sexStr isEqualToString: @"0"]) {
        
        self.sexView.image = [UIImage imageNamed:@"girl"];
        
    }else {
        
        self.sexView.image = [UIImage imageNamed:@"boy"];
    }
    
        self.nickLable.text = messageMdoel.nickName;
    
}



-(void)xiuGaiClick{

    if (_delegate && [_delegate respondsToSelector:@selector(xiuGaiBeizhuInCell:)]) {
        [_delegate xiuGaiBeizhuInCell:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
