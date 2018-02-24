//
//  authorCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "authorCell.h"

@implementation authorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        [self createView];
        [self layOut];
    }
    return self;
}

-(void)createView{

    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont systemFontOfSize:15];
    _titleLb.textColor = [UIColor lightGrayColor];
    _titleLb.textColor = [UIColor colorWithHexString:@"#737373"];
    _titleLb.numberOfLines = 0;
    _titleLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLb];
    
    _contentLb = [[UILabel alloc]init];
    _contentLb.font = [UIFont systemFontOfSize:15];
    _contentLb.textAlignment = NSTextAlignmentLeft;
    _contentLb.textColor = [UIColor colorWithHexString:@"#737373"];
    [self addSubview:_contentLb];
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //CGContextSetStrokeColorWithColor(context, COLORWHITE.CGColor);
    //CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithHexString:@"#efeff4"].CGColor);
    CGContextStrokeRect(context,CGRectMake(15, rect.size.height-0.5, rect.size.width,1));
}

-(void)layOut{

    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(60);
    }];
    
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLb.mas_right).offset(0);
        make.right.equalTo(self).offset(-15);
    }];
}

@end
