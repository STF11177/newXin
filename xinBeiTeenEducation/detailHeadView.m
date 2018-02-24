//
//  detailHeadView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "detailHeadView.h"

@implementation detailHeadView

+(instancetype)headView{

    return [[detailHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275)];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
        [self layoutUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)createView{

    self.topLb = [[UILabel alloc]init];
    self.topLb.text = @"[课程内容]";
    self.topLb.textAlignment = NSTextAlignmentCenter;
    self.topLb.textColor = [UIColor colorWithHexString:@"#45b7ff"];
    [self addSubview:self.topLb];
    
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.image = [UIImage imageNamed:@"kaozpick"];
    [self addSubview:self.headImgView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"“小机灵杯”小学生数学竞赛";
    self.titleLb.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.titleLb];
    
    self.timeLb = [[UILabel alloc]init];
    self.timeLb.text = @"报名时间：08月15日-08月23日";
    self.timeLb.textColor = [UIColor lightGrayColor];
    self.timeLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.timeLb];
    
    self.personHeadLb = [[UILabel alloc]init];
    self.personHeadLb.text = @"已有102名人报名";
    self.personHeadLb.font = [UIFont systemFontOfSize:14];
    self.personHeadLb.textColor = [UIColor colorWithHexString:@"#45b7ff"];
    [self addSubview:self.personHeadLb];
    
    self.enrollImg = [[UIImageView alloc]init];
    [self addSubview:self.enrollImg];
    
    self.sepeHeadView = [[UIView alloc]init];
    self.sepeHeadView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeHeadView];
}

-(void)layoutUI{

    [self.topLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self.headImgView.mas_top).offset(- 5);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(25);
    }];

    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(157);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImgView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.enrollImg.mas_left).offset(-10);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLb.mas_left);
        make.top.equalTo(self.titleLb.mas_bottom).offset(5);
        make.right.equalTo(self.titleLb.mas_right);
    }];
    
    [self.personHeadLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLb.mas_left);
        make.top.equalTo(self.timeLb.mas_bottom).offset(5);
        make.right.equalTo(self.titleLb.mas_right);
    }];
    
    [self.enrollImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.top.equalTo(self.headImgView.mas_bottom);
        make.left.equalTo(self.titleLb.mas_right);
        make.width.height.mas_equalTo(59);
    }];
    
    [self.sepeHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.personHeadLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
    }];
}

-(void)setModel:(textDetailModel *)model{

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.comment_img] placeholderImage:[UIImage imageNamed:@"nsme_ke"]];
    
    self.titleLb.text = model.title;
    NSString *timeStr = [model.biginDate stringByAppendingString:@"-"];
    NSString *timeStr1 = [timeStr stringByAppendingString:model.endDate];
    self.timeLb.text = timeStr1;
    
    self.personHeadLb.text = [NSString stringWithFormat:@"已有%@人报名",model.apply_count];
    
    
    // ------实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];//这里的格式必须和DateString格式一致
    // ------将需要转换的时间转换成 NSDate 对象
    NSDate * nowDate = [NSDate date];
    NSDate *beginDate = [dateFormatter dateFromString:model.biginDate];
    // ------取当前时间和转换时间两个日期对象的时间间隔
    NSTimeInterval time = [nowDate timeIntervalSinceDate:beginDate];
    NSDate *endDate = [dateFormatter dateFromString:model.endDate];
    NSTimeInterval time1 = [nowDate timeIntervalSinceDate:endDate];
    
    if (time1 <0 && time >= 0) {
        
        self.enrollImg.image = [UIImage imageNamed:@"kz_hot"];
    }else if(time1 > 0){
        
        self.enrollImg.image = [UIImage imageNamed:@"kz_over"];
    }
}

//头视图的高度
-(void)getHeadViewHeight{

    CGFloat enrollHeight = 0;
    enrollHeight = enrollHeight + 10 + 10 + 25 + 125 + 5;
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX);
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    CGRect contenRect = [self.titleLb.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

    enrollHeight = enrollHeight + contenRect.size.height;

    NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
    CGRect contenRect1 = [self.timeLb.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
    
    enrollHeight = enrollHeight + contenRect1.size.height;
    
    NSDictionary *dict2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
    CGRect contenRect2 = [self.personHeadLb.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil];
    
    enrollHeight = enrollHeight + contenRect2.size.height + 30;
}

@end
