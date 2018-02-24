//
//  interDiscussCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "interlocutionCell.h"

@implementation interlocutionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.contentLb];
        [self addSubview:self.photoContainer];
        [self addSubview:self.discussCountLb];
        [self layOutUI];
    }
    return self;
}

-(UILabel *)contentLb{
    
    if (!_contentLb) {
        
        _contentLb = [[UILabel alloc]init];
        _contentLb.numberOfLines = 0;
        _contentLb.font = [UIFont systemFontOfSize:18];
        _contentLb.text = @"如果是情侣但有没有到一定程度，出去旅游应该怎样去住";
    }
    return _contentLb;
}

-(interlocutionView *)photoContainer{
    
    if (!_photoContainer) {
        
        _photoContainer = [[interlocutionView alloc]initWithWidth:ScreenWidth - 30];
    }
    return _photoContainer;
}

-(UILabel *)discussCountLb{
    
    if (!_discussCountLb) {
        
        _discussCountLb = [[UILabel alloc]init];
        _discussCountLb.text = @"1402回答";
        _discussCountLb.textColor = [UIColor lightGrayColor];
        _discussCountLb.font = [UIFont systemFontOfSize:12];
//      _discussCountLb.backgroundColor = [UIColor yellowColor];
    }
    return _discussCountLb;
}

-(void)layOutUI{
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [self.photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLb.mas_bottom).offset(8);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(73);
        make.right.mas_greaterThanOrEqualTo(self).offset(-10);
    }];
    [self.photoContainer setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.photoContainer setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
    
    [self.discussCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLb.mas_left);
        make.top.equalTo(self.photoContainer.mas_bottom).offset(9);
    }];
}

-(void)setModel:(interlocutionModel *)model{
    
    _model = model;
    self.contentLb.text = model.title;
    
    NSString *labelText = self.contentLb.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.contentLb.attributedText = attributedString;
    [self.contentLb sizeToFit];
    
    self.discussCountLb.text = [NSString stringWithFormat:@"%@回答",model.comment_count];
    
    NSArray *picViews;
    
    if (![ETRegularUtil isEmptyString:model.imgs]) {

      picViews =[model.imgs componentsSeparatedByString:@"|"];
    }

    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picViews) {

        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.photoContainer.picUrlArray = picViews;
}

-(CGFloat)cellHeightWithModel:(interlocutionModel *)model{
    
    return model.cellHeight;
}

@end
