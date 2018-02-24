//
//  interDIscussHeadView.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interDIscussHeadView.h"

@implementation interDIscussHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
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
    }
    return _titleLb;
}

-(UILabel *)contentLb{
    if (!_contentLb) {
        
        _contentLb = [[UILabel alloc]init];
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
        make.top.equalTo(self).offset(15);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.left.equalTo(self.titleLb.mas_left);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    
    [self.expressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLb.mas_top);
        make.right.equalTo(self).offset(-5);
        make.width.mas_equalTo(70);
    }];
    
    [self.photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLb.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(0);
        make.right.mas_greaterThanOrEqualTo(self).offset(-10);
    }];
    [self.photoContainer setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.photoContainer setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
}

-(void)setModel:(interlocutionModel *)model{
    
    self.titleLb.text = model.title;
    self.contentLb.text = model.content;
    
    NSArray *picViews =[model.imgStr componentsSeparatedByString:@"|"];
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picViews) {
        
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.photoContainer.picUrlArray = picViews;
}

-(CGFloat)cellHeightWith:(NSString *)imgStr isOpen:(BOOL)isOpen{
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    CGRect contenRect = [self.titleLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    _contentLb.numberOfLines = 1;
    
    CGFloat openFloat;
    if (isOpen == YES) {
        
        _expressBtn.hidden = YES;
        _contentLb.numberOfLines = 0;
        CGRect contenRect1 = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        
        openFloat = contenRect1.size.height;
    }else{
        
        openFloat = 0;
    }
    
    if (imgStr) {
        
        _cellHeight = 15 + contenRect.size.height + 67 + 15 + 15 + 21 + openFloat;
    }else{
        
        _cellHeight = 15 + contenRect.size.height + 15 +21 + openFloat;
    }
    
    self.isOpen = NO;
    return _cellHeight;
}

-(void)expreBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(exprandInView:)]) {
        [_delegate exprandInView:self];
    }
}

@end
