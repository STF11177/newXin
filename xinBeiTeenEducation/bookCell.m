//
//  bookCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bookCell.h"

@implementation bookCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
        [self layOut];
    }
    return self;
}

-(void)createView{

    _bookImageView = [[UIImageView alloc]init];
    _bookImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    _bookImageView.layer.shadowOffset = CGSizeMake(0, 0);
    _bookImageView.layer.shadowOpacity = 0.5;
    _bookImageView.layer.shadowRadius = 2.0;
    [self addSubview:_bookImageView];
    
    _titleLable = [[YYLabel alloc]init];
    _titleLable.font = [UIFont systemFontOfSize:12];
    _titleLable.textColor = [UIColor colorWithHexString:@"#282828"];
    _titleLable.text = @"新概念英语青少版";
    _titleLable.numberOfLines = 2;
    _titleLable.textVerticalAlignment = YYTextVerticalAlignmentTop;
    [_titleLable sizeToFit];
    [self addSubview:_titleLable];
    
    _authorLb = [[UILabel alloc]init];
    _authorLb.font = [UIFont systemFontOfSize:10];
    _authorLb.textColor = [UIColor lightGrayColor];
    _authorLb.text = @"亚历山大L.G.Alexander";
    [self addSubview:_authorLb];
    
    _priceLb = [[UILabel alloc]init];
    _priceLb.font = [UIFont systemFontOfSize:10];
    _priceLb.textColor = [UIColor colorWithHexString:@"#ff2b24"];
    _priceLb.text = @"¥100";
    [self addSubview:_priceLb];
    
    _saleLb = [[UILabel alloc]init];
    _saleLb.font = [UIFont systemFontOfSize:10];
    _saleLb.textColor = [UIColor lightGrayColor];
    _saleLb.text = @"¥200";
    [self addSubview:_saleLb];
}

-(void)layOut{

    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(125);
    }];

    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bookImageView.mas_bottom).offset(7);
        make.left.equalTo(self.bookImageView.mas_left);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(36);
    }];
    
    [self.authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLable.mas_bottom);
        make.left.equalTo(self.bookImageView.mas_left);
        make.width.mas_equalTo(88);
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.authorLb.mas_bottom).offset(5);
        make.left.equalTo(self.bookImageView.mas_left);
    }];
    
//    [self.saleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.priceLb.mas_top);
//        make.left.equalTo(self.priceLb.mas_right).offset(5);
//        make.right.equalTo(self.bookImageView.mas_right);
//    }];
}

-(void)setModel:(eduBookModel *)model{

    _model = model;

    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImg] placeholderImage:[UIImage imageNamed:@"book_background"]];
    _titleLable.text = model.bookName;

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{ NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.2f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_titleLable.text attributes:dic];
    
    _titleLable.attributedText = attributeStr;
    
    _authorLb.text = model.author;
    float price = [model.price floatValue];
    _priceLb.text = [NSString stringWithFormat:@"¥%.2f",price];
    
//    float salePrice = [model.constPrice floatValue];
//    self.saleLb.text = [NSString stringWithFormat:@"¥%.2f",salePrice];
    
//   给文字添加贯穿横线
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.saleLb.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.saleLb.attributedText = newPrice;
    [self.titleLable sizeToFit];
}

- (CGFloat)cellHeight{
    
    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(88, CGFLOAT_MAX);
    
    //  计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
    CGRect contenRect = [_titleLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

    _cellHeight = contenRect.size.height + 125 + 5 + 8 + 21 + 7;
    return _cellHeight;
}

@end
