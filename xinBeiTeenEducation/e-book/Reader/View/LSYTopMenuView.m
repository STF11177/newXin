//
//  LSYTopMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYTopMenuView.h"
#import "LSYMenuView.h"
@interface LSYTopMenuView ()
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) UIButton *more;
@property (nonatomic,strong) UIButton *catalog;
@property (nonatomic,strong) UIButton *setBtn;
@end
@implementation LSYTopMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.back];
    [self addSubview:self.more];
    [self addSubview:self.catalog];
    [self addSubview:self.setBtn];
}

-(void)setState:(BOOL)state
{
    _state = state;
    if (state) {
        [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        return;
    }
    [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
}
-(UIButton *)back
{
    if (!_back) {
        _back = [LSYReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_back setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _back;
}

-(UIButton *)catalog
{
    if (!_catalog) {
        _catalog = [LSYReadUtilites commonButtonSEL:@selector(showCatalog) target:self];
        [_catalog setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
    }
    return _catalog;
}

-(UIButton*)setBtn{
    
    if (!_setBtn) {
        
        _setBtn = [LSYReadUtilites commonButtonSEL:@selector(setClick) target:self];
        [_setBtn setTitle:@"ST" forState:UIControlStateNormal];
        [_setBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    }
    return _setBtn;
}

-(UIButton *)more
{
    if (!_more) {
        _more = [LSYReadUtilites commonButtonSEL:@selector(moreOption) target:self];
        [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
        [_more setImageEdgeInsets:UIEdgeInsetsMake(7.5, 12.5, 7.5, 12.5)];
    }
    return _more;
}

-(void)moreOption
{
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.delegate menuViewMark:self];
    }
}

-(void)showCatalog{
    
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeTopCatalog:)]) {
        [self.delegate menuViewInvokeTopCatalog:self];
    }
}

-(void)setClick{
    
    if ([self.delegate respondsToSelector:@selector(menuViewSetting:)]) {
        [self.delegate menuViewSetting:self];
    }
}

-(void)backView
{
    [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _back.frame = CGRectMake(0, 24, 40, 40);
    _more.frame = CGRectMake(ViewSize(self).width-50, 24, 40, 40);
    _catalog.frame = CGRectMake( 60, 24, 40, 40);
    _setBtn.frame = CGRectMake( ScreenWidth - 50 - 40 -10, 24, 40, 40);
}

@end
