//
//  interDiscussCommentCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interDiscussCommentCell.h"

@implementation interDiscussCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.commentLb];
        [self.contentView addSubview:self.likeLb];
        [self.contentView addSubview:self.lineView];
        [self layOutUI];
    }
    return self;
}

-(UILabel *)commentLb{
    
    if (!_commentLb) {
        
        _commentLb = [[UILabel alloc]init];
        _commentLb.text = @"评论 0";
    }
    return _commentLb;
}

-(UILabel *)likeLb{
    
    if (!_likeLb) {
        
        _likeLb = [[UILabel alloc]init];
        _likeLb.textAlignment = NSTextAlignmentRight;
        _likeLb.text = @"0 赞";
    }
    return _likeLb;
}

-(UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    return _lineView;
}

-(void)layOutUI{
    
    [self.commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(ScreenWidth/2 - 15);
    }];
    
    [self.likeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(ScreenWidth/2 - 15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
    }];
}

@end
