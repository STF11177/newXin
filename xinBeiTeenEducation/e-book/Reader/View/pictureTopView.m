//
//  pictureTopView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "pictureTopView.h"
#import "pictureBottomView.h"

#define AnimationDelay 0.3f
#define TopViewHeight 64.0f
@interface pictureTopView ()
@property (nonatomic,strong) UIButton *backBtn;
//@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) UIButton *setBtn;
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIButton *catalogbtn;
@property (nonatomic,strong) pictureBottomView *bottomView;
@end
@implementation pictureTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.menuView];
        [self.menuView addSubview:self.backBtn];
//      [self.menuView addSubview:self.moreBtn];
        [self.menuView addSubview:self.setBtn];
        [self.menuView addSubview:self.catalogbtn];
        [self addSubview:self.bottomView];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)]];
    }
    return self;
}

-(UIView *)menuView{
    
    if (!_menuView) {
        
        _menuView = [[UIView alloc]init];
        _menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    }
    return _menuView;
}

-(UIButton*)backBtn{
    if (!_backBtn) {
        
        _backBtn = [LSYReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_backBtn setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

//-(UIButton *)moreBtn
//{
//    if (!_moreBtn) {
//        _moreBtn = [LSYReadUtilites commonButtonSEL:@selector(moreOption) target:self];
//        [_moreBtn setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
//        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(7.5, 12.5, 7.5, 12.5)];
//    }
//    return _moreBtn;
//}

-(UIButton *)catalogbtn{
    
    if (!_catalogbtn) {
        
        _catalogbtn = [LSYReadUtilites commonButtonSEL:@selector(showCatalog) target:self];
        [_catalogbtn setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
    }
    return _catalogbtn;
}

-(UIButton*)setBtn{
    if (!_setBtn) {
        
        _setBtn = [LSYReadUtilites commonButtonSEL:@selector(bottomViewClick) target:self];
        [_setBtn setTitle:@"BG" forState:UIControlStateNormal];
        [_setBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    }
    return _setBtn;
}

-(pictureBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[pictureBottomView alloc]init];
    }
    return _bottomView;
}

#pragma mark -- 显示底部栏
-(void)bottomViewClick{
    
    [UIView animateWithDuration:0.3 animations:^{
        
      _bottomView.frame = CGRectMake(0, ViewSize(self).height - 70, ScreenWidth, 70);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -- 目录
-(void)showCatalog{
    
 if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
    
     [self.delegate menuViewInvokeCatalog:self];
 }
}

#pragma mark -- 标签
-(void)moreOption{
    
}

-(void)backView{
    [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

-(void)hiddenSelf{
    
    [self hiddenAnimation:YES];
}

-(void)hiddenAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        
        _menuView.frame = CGRectMake(0, -TopViewHeight, ViewSize(self).width, TopViewHeight);
        _bottomView.frame = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,70);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    if ([self.delegate respondsToSelector:@selector(menuViewDidHidden:)]) {
        [self.delegate menuViewDidHidden:self];
    }
}

-(void)showAnimation:(BOOL)animation{
    
    self.hidden = NO;
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        _menuView.frame = CGRectMake(0, 0, ViewSize(self).width, TopViewHeight);
        _bottomView.frame = CGRectMake(0, ScreenHeight,ScreenWidth , 70);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _menuView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _backBtn.frame = CGRectMake(0, 24, 40, 40);
//  _moreBtn.frame = CGRectMake(ViewSize(self).width-50, 24, 40, 40);
    _setBtn.frame = CGRectMake(ViewSize(self).width-50 , 24, 40, 40);
    _catalogbtn.frame = CGRectMake( 60, 24, 40, 40);
    _bottomView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 70);
}

@end
