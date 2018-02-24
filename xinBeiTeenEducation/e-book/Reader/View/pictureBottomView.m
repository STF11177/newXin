//
//  pictureBottomView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "pictureBottomView.h"
#define AnimationDelay 0.3f

@interface pictureBottomView()
@property (nonatomic,strong) UIView *theme1;
@property (nonatomic,strong) UIView *theme2;
@property (nonatomic,strong) UIView *theme3;

@end

@implementation pictureBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.theme1];
    [self addSubview:self.theme2];
    [self addSubview:self.theme3];
}
-(UIView *)theme1
{
    if (!_theme1) {
        _theme1 = [[UIView alloc] init];
        _theme1.tag = 1;
        _theme1.backgroundColor = [UIColor whiteColor];
        [_theme1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme1;
}
-(UIView *)theme2
{
    if (!_theme2) {
        _theme2 = [[UIView alloc] init];
        _theme2.tag = 2;
        _theme2.backgroundColor = RGB(188, 178, 190);
        [_theme2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme2;
}
-(UIView *)theme3
{
    if (!_theme3) {
        _theme3 = [[UIView alloc] init];
        _theme3.tag = 3;
        _theme3.backgroundColor = RGB(190, 182, 162);
        [_theme3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme3;
}
-(void)changeTheme:(UITapGestureRecognizer *)tap{
    
    NSString *tagStr = [NSString stringWithFormat:@"%ld",tap.view.tag];
    
    NSDictionary *param = @{@"color":tagStr};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"color" object:nil userInfo:param];
}

-(void)layoutSubviews
{
    CGFloat spacing = (ViewSize(self).width-40*3)/4;
    _theme1.frame = CGRectMake(spacing, 15, 40, 40);
    _theme2.frame = CGRectMake(DistanceFromLeftGuiden(_theme1)+spacing, 15, 40, 40);
    _theme3.frame = CGRectMake(DistanceFromLeftGuiden(_theme2)+spacing, 15, 40, 40);
}

@end
