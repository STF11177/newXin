//
//  textViewCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/11.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textViewCell.h"

@implementation textViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return  self;
}

-(void)createView{

    self.textView = [[YYTextView alloc]init];
    self.textView.placeholderText = @"请填写地址详细信息";
    self.textView.placeholderFont = [UIFont systemFontOfSize:17];
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.delegate = self;
    self.textView.placeholderTextColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.textView];
}

-(void)layOutUI{

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.height.mas_equalTo(100);
    }];
}

-(void)textViewDidChange:(YYTextView *)textView{

    if (_delegate && [_delegate respondsToSelector:@selector(selectTextView:)]) {
        [_delegate selectTextView:self];
    }
}

@end
