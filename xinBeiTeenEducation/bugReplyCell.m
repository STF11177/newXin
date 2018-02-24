//
//  bugReplyCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bugReplyCell.h"

@implementation bugReplyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOuTUI];
    }
    return self;
}

-(void)createView{
    
    self.contentLb = [[UILabel alloc]init];
    self.contentLb.font = [UIFont systemFontOfSize:16];
    self.contentLb.text = @"";
    self.contentLb.numberOfLines = 0;
    [self addSubview:self.contentLb];
}

-(void)layOuTUI{
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(11);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
}


@end
