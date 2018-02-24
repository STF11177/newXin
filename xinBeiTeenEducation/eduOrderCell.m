//
//  eduOrderCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduOrderCell.h"

@implementation eduOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.image = [UIImage imageNamed:@"fenmian"];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.clipsToBounds = YES;
    [self addSubview:self.headImageView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.numberOfLines = 1;
    self.titleLb.text = @"假如生活欺骗了你，假如生活欺骗了你，假如生活欺骗了你";
    [self addSubview:self.titleLb];
    
    self.authorLb = [[UILabel alloc]init];
    self.authorLb.text = @"普希金";
    self.authorLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    [self addSubview:self.authorLb];
    
    self.statusLb = [[UILabel alloc]init];
    self.statusLb.text = @"已发货";
    self.statusLb.font = [UIFont systemFontOfSize:15];
    self.statusLb.textAlignment = NSTextAlignmentRight;
    self.statusLb.textColor = [UIColor orangeColor];
    [self addSubview:self.statusLb];
    
    self.saleLb = [[UILabel alloc]init];
    self.saleLb.text = @"¥50";
    self.saleLb.textColor = [UIColor colorWithHexString:@"#ff2b24"];
    self.saleLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.saleLb];
    
    self.orginPriceLb = [[UILabel alloc]init];
    self.orginPriceLb.text = @"¥60";
    self.orginPriceLb.textColor = [UIColor lightGrayColor];
    self.orginPriceLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.orginPriceLb];
    
    self.countLb = [[UILabel alloc]init];
    self.countLb.text = @"x1";
    self.countLb.textColor = [UIColor lightGrayColor];
    [self addSubview:self.countLb];
    
    self.sumLb = [[UILabel alloc]init];
    self.sumLb.font = [UIFont systemFontOfSize:14];
    self.sumLb.text = @"共件商品 合计：¥(包含运费)";
    [self addSubview:self.sumLb];
    
    self.timeLb = [[UILabel alloc]init];
    self.timeLb.text = @"2017-09-22 14:02:09";
    self.timeLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    self.timeLb.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.timeLb];
    
    self.deleteBtn = [[UIButton alloc]init];
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    
//    self.realBtn = [[UIButton alloc]init];
//    [self.realBtn setTitle:@"正品" forState:UIControlStateNormal];
//    [self.realBtn setTitleColor:[UIColor colorWithHexString:@"ff2b24"] forState:UIControlStateNormal];
//    self.realBtn.layer.borderColor = [UIColor colorWithHexString:@"ff2b24"].CGColor;
//    self.realBtn.layer.cornerRadius = 2;
//    self.realBtn.layer.borderWidth = 1;
//    [self addSubview:self.realBtn];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.lineView];
}

-(void)layOutUI{

    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(23);
    }];

    [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.saleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_top);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(60);
    }];
    
//    [self.orginPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.saleLb.mas_bottom).offset(8);
//        make.right.equalTo(self).offset(-10);
//    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.saleLb.mas_left).offset(-5);
    }];
    
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLb.mas_left);
        make.top.equalTo(self.saleLb.mas_bottom).offset(8);
    }];
    
    [self.sumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.countLb);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self.headImageView.mas_bottom);
    }];
}

-(void)setModel:(orderModel *)model{

    NSString *time= [NSString stringWithFormat:@"%@",model.orderCreateDate];//报名时间
    NSArray *tiemArray = [time componentsSeparatedByString:@"."];
    NSString *timeStr = tiemArray[0];
    self.timeLb.text = timeStr;

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImg] placeholderImage:[UIImage imageNamed:@"fenmian"]];

    NSString *payStr = [NSString stringWithFormat:@"%@",model.payStatus];
    if ([payStr isEqualToString:@"0"]) {
        
        self.statusLb.text = @"待支付";
    }else if([payStr isEqualToString:@"1"]){
        
        self.deleteBtn.hidden = YES;
        self.statusLb.text = @"已支付";
    }else{
        
        self.deleteBtn.hidden = YES;
        self.statusLb.text = @"已发货";
    }

    self.titleLb.text = model.bookName;
    self.authorLb.text = model.author;
    
    self.saleLb.text = [NSString stringWithFormat:@"¥%.2f",[model.money floatValue]];
    self.countLb.text = [NSString stringWithFormat:@"数量：x%@",model.bookCount];
    self.sumLb.text = [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f(含运费¥%.2f)",model.bookCount,[model.money floatValue],[model.expressFee floatValue]];
    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.sumLb.text];
    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff2b24"] range:NSMakeRange(8+model.count.length, model.money.length+4)];
    
//    float salePrice = [model.constPrice floatValue];
//    self.orginPriceLb.text = [NSString stringWithFormat:@"¥%.2f",salePrice];
    
//    给文字添加贯穿横线
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.orginPriceLb.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.orginPriceLb.attributedText = newPrice;
    
    self.sumLb.attributedText = centStr;
}

-(void)deleteClick{

    if (_delegate && [_delegate respondsToSelector:@selector(deleteInCell:)]) {
        [_delegate deleteInCell:self];
    }
}

@end

