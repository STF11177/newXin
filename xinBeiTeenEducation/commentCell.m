//
//  commentCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/9/6.
//  Copyright © 2017年 user. All rights reserved.
//


#import "commentCell.h"

@interface commentCell ()

@end

@implementation commentCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
        self.contentLabel.numberOfLines = 0;
    
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        __weak __typeof(self) weakSelf = self;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf.contentView);
        }];
    }
    return self;
}

-(void)configCellWithModel:(bugCommentModel *)model{

    if ([model.status isEqualToString:@"2"]) {
        
        self.contentLabel.text = [NSString stringWithFormat:@"管理员回复我 %@",model.content];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.contentLabel.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(0, 3)];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(5, 1)];
        self.contentLabel.attributedText = centStr;
        
    }else{
        
        self.contentLabel.text = [NSString stringWithFormat:@"我回复管理员 %@",model.content];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.contentLabel.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(0, 1)];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(3, 3)];
        self.contentLabel.attributedText = centStr;
    }
}

@end
