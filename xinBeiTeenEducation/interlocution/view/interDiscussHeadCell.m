//
//  interDiscussHeadCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interDiscussHeadCell.h"

@implementation interDiscussHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.titleLb];
        [self addSubview:self.contentLb];
        [self addSubview:self.expressBtn];
        [self addSubview:self.photoContainer];
        [self layOutUI];
    }
    return self;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont boldSystemFontOfSize:18];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

-(UILabel *)contentLb{
    if (!_contentLb) {
        
        _contentLb = [[UILabel alloc]init];
        _contentLb.textColor = [UIColor colorWithHexString:@"#6b6b6b"];
        _contentLb.font = [UIFont systemFontOfSize:15];
    }
    return _contentLb;
}

-(UIButton *)expressBtn{
    if (!_expressBtn) {
        
        _expressBtn = [[UIButton alloc]init];
        [_expressBtn setTitle:@"...展开" forState:UIControlStateNormal];
        [_expressBtn setTitleColor:[UIColor colorWithHexString:@"#406599"] forState:UIControlStateNormal];
        _expressBtn.backgroundColor = [UIColor whiteColor];
        [_expressBtn setImage:[UIImage imageNamed:@"Expand"] forState:UIControlStateNormal];
        [_expressBtn addTarget:self action:@selector(expreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _expressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _expressBtn.backgroundColor = [UIColor whiteColor];
        [_expressBtn setImageEdgeInsets:UIEdgeInsetsMake(0,50, 0, 0)];
        
        [_expressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    }
    return _expressBtn;
}

-(interPhotoView*)photoContainer{
    
    if (!_photoContainer) {
        
        _photoContainer = [[interPhotoView alloc]initWithWidth:ScreenWidth - 30];
    }
    return _photoContainer;
}

-(void)layOutUI{
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(20);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLb.mas_bottom).offset(13);
        make.left.equalTo(self.titleLb.mas_left);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [self.expressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLb.mas_top);
        make.left.equalTo(self.contentLb.mas_right);
        make.right.equalTo(self).offset(-5);
        make.width.mas_equalTo(0);
    }];
    
    [self.photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLb.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(0);
        make.right.mas_greaterThanOrEqualTo(self).offset(-10);
    }];
    [self.photoContainer setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.photoContainer setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
}

-(void)setModel:(interDisscussHeadModel *)model isOpen:(BOOL)isOpen{
    
    
    self.titleLb.text = [NSString stringWithFormat:@"%@",model.title];
    self.contentLb.text = [NSString stringWithFormat:@"%@",model.content];
    if ([ETRegularUtil isEmptyString:self.contentLb.text]) {
        
        self.contentLb.text = @"";
        [self.contentLb mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLb.mas_bottom).offset(0);
        }];
    }
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    self.contentLb.attributedText = [self getSpaceLabelHeightwithSpeace:5 withString:self.contentLb.text];
    self.titleLb.attributedText = [self getSpaceLabelHeightwithSpeace:5 withString:self.titleLb.text];
    
    if (contenRect.size.height < 18|| isOpen == YES) {
        
        self.expressBtn.hidden = YES;
        [self.expressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(0);
        }];
    }else{
        
        [self.expressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(70);
        }];
    }
    
    NSArray *picViews =[model.imgs componentsSeparatedByString:@"|"];
    NSString *picStr = picViews[0];
    NSArray *picArray = [NSArray arrayWithObject:picStr];
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picArray) {

        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.photoContainer.picUrlArray = picArray;
}

-(CGFloat)cellHeightWith:(NSString *)imgStr isOpen:(BOOL)isOpen{
    
    CGFloat openFloat;
    CGFloat titleFloat;

    titleFloat = [self getSpaceLabelHeightwithSpeace:3 withFont:[UIFont boldSystemFontOfSize:18] withWidth:ScreenWidth - 30 withString:self.titleLb.text];
    _contentLb.numberOfLines = 1;

    if (isOpen == YES) {
        
    _expressBtn.hidden = YES;
    _contentLb.numberOfLines = 0;
        
    openFloat = [self getSpaceLabelHeightwithSpeace:3 withFont:[UIFont boldSystemFontOfSize:15] withWidth:ScreenWidth - 30 withString:self.contentLb.text] - 18;
    }else{
        
        openFloat = 0;
    }
        if (![ETRegularUtil isEmptyString:imgStr]) {
            
            _cellHeight = 15 + titleFloat + 120 *0.67 + 15 + 15 + 21 + openFloat + 15 ;
        }else{
            
            _cellHeight = 15 + titleFloat + 15 +21 + openFloat +15;
        }
    
    if ([ETRegularUtil isEmptyString:self.contentLb.text]) {
        
        _cellHeight = _cellHeight - 15 -15;
    }
    
    self.isOpen = NO;    
    return _cellHeight;
}

-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width withString:(NSString *)string {
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f};
    CGSize size = [string  boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(NSMutableAttributedString *)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withString:(NSString *)string{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];

    return attributedString;
}

-(void)expreBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(exprandInCell:)]) {
        [_delegate exprandInCell:self];
    }
}

@end
