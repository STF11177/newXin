//
//  personDataCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 user. All rights reserved.
//

#import "personDataCell.h"

@implementation personDataCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layout];
    }
    return self;
}

-(void)createView{

    self.titleLb = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLb];

    self.headImgView =[[UIImageView alloc]init];
    self.headImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadView)];
    [self.headImgView addGestureRecognizer:tapGuesture];
    [self.contentView addSubview:self.headImgView];

    self.headLb = [[UILabel alloc]init];
    self.headLb.textColor = [UIColor lightGrayColor];
    [self.headLb sizeToFit];
    self.headLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.headLb];
    
    self.arrowImg = [[UIImageView alloc]init];
    self.arrowImg.image = [UIImage imageNamed:@"jiantou"];
    [self.contentView addSubview:self.arrowImg];
}

-(void)layout{

    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.arrowImg.mas_left).offset(-15);
        make.width.height.mas_equalTo(68);
        
    }];
    
    [_headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLb.mas_right).offset(10);
        make.right.equalTo(self.arrowImg.mas_left).offset(-10);
        
    }];
}

-(void)onHeadView{
    if (_delegate && [_delegate respondsToSelector:@selector(pressHeadView:)]) {
        [_delegate pressHeadView:self];
    }
}

#pragma mark --计算title的size,自动计算高度
- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    CGSize labelSize;
    UIFont *font =[UIFont systemFontOfSize:14.f];
    labelSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options: NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
}

@end
