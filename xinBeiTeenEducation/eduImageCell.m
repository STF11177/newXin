

//
//  eduImageCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eduImageCell.h"

@implementation eduImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

   if (self) {
        
    self.backgroundColor = [UIColor whiteColor];
    [self setUp];
  }
    return self;
}

-(void)setUp{

    self.eduImageView = [[educationVIew alloc]initWithWidth:ScreenWidth];
    [self addSubview:self.eduImageView];

    [self.eduImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_greaterThanOrEqualTo(CGFLOAT_MAX);
    }];
    [self.eduImageView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.eduImageView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
}

-(void)setEduModel:(eduDetailModel *)eduModel{

    _eduModel = eduModel;
    
    NSArray *array = [_eduModel.introduceImg componentsSeparatedByString:@"|"];
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in array) {
        
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.eduImageView.picArray = array;
}

@end
