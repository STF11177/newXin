//
//  interDiscussCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "interDiscussCell.h"


@implementation interDiscussCell
static NSString *contentStr;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.headImageView];
        [self addSubview:self.titleLb];
        [self addSubview:self.jobLb];
        [self addSubview:self.likeBtn];
        [self addSubview:self.contentLb];
        [self addSubview:self.photoContainer];
        [self addSubview:self.likeCountLb];
        [self addSubview:self.discussCountLb];
        [self layoutUI];
    }
    return self;
}

-(UIImageView *)headImageView{
    
    if (!_headImageView) {
        
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.cornerRadius = 17.5;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.image = [UIImage imageNamed:@"parent_picker"];
    }
    return _headImageView;
}

-(UILabel*)titleLb{
    if (!_titleLb) {
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.text = @"彬彬有礼";
    }
    return _titleLb;
}

-(UILabel *)jobLb{
    
    if (!_jobLb) {
        _jobLb = [[UILabel alloc]init];
        _jobLb.text = @"香港大学哲学博士";
        _jobLb.textColor = [UIColor lightGrayColor];
    }
    return _jobLb;
}

-(UIButton *)likeBtn{
    if (!_likeBtn) {
        
        _likeBtn = [[UIButton alloc]init];
        [_likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

-(UILabel *)contentLb{
    if (!_contentLb) {
    
        _contentLb = [[UILabel alloc]init];
        _contentLb.font = [UIFont systemFontOfSize:17];
        _contentLb.text = @"";
    }
    return _contentLb;
}

-(interDiscussPhotoView *)photoContainer{
    if (!_photoContainer) {
        
        _photoContainer = [[interDiscussPhotoView alloc]initWithWidth:ScreenWidth - 30];
    }
    return _photoContainer;
}

-(UILabel*)likeCountLb{
    
    if (!_likeCountLb) {
        
        _likeCountLb = [[UILabel alloc]init];
        _likeCountLb.text = @"100赞";
        _likeCountLb.font = [UIFont systemFontOfSize:12];
        _likeCountLb.textColor = [UIColor lightGrayColor];
    }
    return _likeCountLb;
}

-(UILabel *)discussCountLb{
    
    if (!_discussCountLb) {
        _discussCountLb = [[UILabel alloc]init];
        _discussCountLb.text = @"50万阅读";
        _discussCountLb.font = [UIFont systemFontOfSize:12];
        _discussCountLb.textColor = [UIColor lightGrayColor];
    }
    return _discussCountLb;
}

-(UIButton *)pullBtn{
    
    if (!_pullBtn) {
     
        _pullBtn = [[UIButton alloc]init];
        [_pullBtn setImage:[UIImage imageNamed:@"pull_down"] forState:UIControlStateNormal];
    }
    return _pullBtn;
}

-(void)layoutUI{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.centerY.equalTo(self.headImageView.mas_centerY);
    }];
    
    [self.jobLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLb.mas_left);
        make.bottom.equalTo(self.headImageView.mas_bottom);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.titleLb.mas_top);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [self.photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLb.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(0);
        make.right.mas_greaterThanOrEqualTo(self).offset(-10);
    }];
    [self.photoContainer setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.photoContainer setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
    
    [self.likeCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.photoContainer.mas_bottom).offset(15);
    }];

    [self.discussCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.likeCountLb.mas_right).offset(15);
        make.top.equalTo(self.likeCountLb.mas_top);
    }];
}

-(void)setModel:(interDisscussModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    self.titleLb.text = model.from_nickName;
    self.jobLb.text = @"";

    self.contentLb.text = model.attachedContent;
    
    self.contentLb.attributedText = [self getSpaceLabelHeightwithSpeace:3 withString:model.attachedContent];
    
    self.likeCountLb.text = [NSString stringWithFormat:@"%@赞",model.commentLike];
    self.discussCountLb.text = [NSString stringWithFormat:@"%@阅读",model.clickSum];
    
    self.likeBtn.selected = model.isLike? YES: NO;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@",model.commentImg];
    
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
//    计算内容label的高度
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
//    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

//    CGFloat rectfloat = contenRect.size.height;

//    CGFloat viewBottom;
    NSArray *picViews;
    if (![ETRegularUtil isEmptyString:imgStr]) {

        self.contentLb.numberOfLines = 4;
//        viewBottom =0;
        picViews = [NSArray arrayWithObject:imgStr];
        
        [self.photoContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentLb.mas_bottom).offset(5);
        }];
//        if (rectfloat > 84) {

//            NSString *str = [self.contentLb.text stringByReplacingCharactersInRange:NSMakeRange(67, self.contentLb.text.length - 67) withString:@"...全文"];

//            NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];

//            [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#406599"] range:NSMakeRange(67, 5)];
//            self.contentLb.text = attrDescribeStr;
//        }
    
    }else{

//        if (rectfloat > 126) {
//
//                    NSString *str = [self.contentLb.text stringByReplacingCharactersInRange:NSMakeRange(105, self.contentLb.text.length - 105) withString:@"...全文"];

//                    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];

//                    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#406599"] range:NSMakeRange(105, 5)];
//                    self.contentLb.attributedText = attrDescribeStr;
//        }
        self.contentLb.numberOfLines = 6;
//        viewBottom = 10;
        
        [self.photoContainer mas_updateConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.contentLb.mas_bottom).offset(0);
        }];
    }

//    [self.likeCountLb mas_updateConstraints:^(MASConstraintMaker *make) {
//     make.top.equalTo(self.photoContainer.mas_bottom).offset(viewBottom).priorityLow();
//    }];

    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picViews) {
        
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.photoContainer.picUrlArray = picViews;
}

-(CGFloat)cellHeightWithModel:(interDisscussModel *)model{
    
    return model.cellHeight;
}

-(NSMutableAttributedString *)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withString:(NSString *)string{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

-(void)likeClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(likeInCell:)]) {
        [_delegate likeInCell:self];
    }
}

@end
