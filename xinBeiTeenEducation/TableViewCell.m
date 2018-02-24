//
//  TableViewCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import "TableViewCell.h"
#import "Masonry.h"

@implementation TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self autoLayout];
    }
    return self;
}

-(void)createView{

    self.nameLable = [[UILabel alloc]init];
    self.nameLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLable];
    
    self.textLable1 = [[UILabel alloc]init];
    self.textLable1.font = [UIFont systemFontOfSize:15];
    self.textLable1.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.textLable1];
    
    self.arrowImageView = [[UIImageView alloc]init];
    self.arrowImageView.image = [UIImage imageNamed:@"jiantou"];
    
    self.arrowImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatar:)];
    [self.arrowImageView addGestureRecognizer:tapGuesture];
    [self.contentView addSubview:self.arrowImageView];
}

-(void)autoLayout{
 
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.leading.offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    
    }];
    
    [self.textLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right).offset(30);
        make.height.offset(20.0);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-15);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
}

-(void)setCellInfowithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withArrow:(BOOL)isHas{

    if (!isHas) {
        
        self.arrowImageView.hidden = YES;
    }
    
    self.nameLable.text = title;
    self.textLable1.text = subTitle;
    
}

-(void)setMessageModel:(messDetailModel *)messageModel{

    _messageModel = messageModel;
}

#pragma mark - Gesture
- (void)onAvatar:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onDefaultInCell:)]) {
            [_delegate onDefaultInCell:self];
        }
    }
}

@end
