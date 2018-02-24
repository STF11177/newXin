//
//  sliderView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "sliderView.h"

@interface sliderView ()
@property (nonatomic,strong) UILabel *progressLb;
@end

@implementation sliderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self addSubview:self.progressLb];
    }
    return self;
}

-(UILabel *)progressLb
{
    if (!_progressLb) {
        _progressLb = [[UILabel alloc] init];
        _progressLb.font = [UIFont systemFontOfSize:[LSYReadConfig shareInstance].fontSize];
        _progressLb.textColor = [UIColor whiteColor];
        _progressLb.textAlignment = NSTextAlignmentCenter;
        _progressLb.numberOfLines = 0;
    }
    return _progressLb;
}

-(void)title:(NSString *)title progress:(NSString *)progress
{
    _progressLb.text = [NSString stringWithFormat:@"%@\n%@",title,progress];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _progressLb.frame = self.bounds;
}

@end
