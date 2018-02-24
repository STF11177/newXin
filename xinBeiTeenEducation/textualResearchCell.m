//
//  textualResearchCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import "textualResearchCell.h"
#import <sys/utsname.h>

@implementation textualResearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
    
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.image = [UIImage imageNamed:@"nsme_ke"];
    [self addSubview:self.headImgView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"读写新天地读写新天地读写新天地读写新天地";
    self.titleLb.font = [UIFont systemFontOfSize:17];
    self.titleLb.numberOfLines = 0;
    self.titleLb.textColor = [UIColor colorWithHexString:@"#161615"];
    [self addSubview:self.titleLb];
    
    self.timeLb = [[UILabel alloc]init];
    self.timeLb.textColor = [UIColor colorWithHexString:@"#9f9f9f"];
    self.timeLb.text = @"考试时间：17-05-01";
    self.timeLb.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.timeLb];
    
    self.priceLb = [[UILabel alloc]init];
    self.priceLb.text = @"¥52.00";
    self.priceLb.font = [UIFont systemFontOfSize:15];
    self.priceLb.textColor = [UIColor colorWithHexString:@"#ff6600"];
    [self addSubview:self.priceLb];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    //5或者5s不显示
    if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]||[platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]||[platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,2"]) {
        
    }else{
    
        self.personLb = [[UILabel alloc]init];
        self.personLb.text = @"已有102人报名";
        self.personLb.font = [UIFont systemFontOfSize:13];
        self.personLb.textColor = [UIColor colorWithHexString:@"#9f9f9f"];
        [self addSubview:self.personLb];
    }
    
    self.signView = [[UIImageView alloc]init];
    [self addSubview:self.signView];
    
    self.signButton = [[UIButton alloc]init];
    self.signButton.layer.cornerRadius = 3;
    self.signButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.signButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.signButton addTarget:self action:@selector(pressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.signButton];
}

-(void)layoutUI{
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.width.height.mas_equalTo(100);
        
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgView.mas_top).offset(2);
        make.left.equalTo(self.headImgView.mas_right).offset(15);
        
    }];
    
    // 不然在6/6plus上就不准确了
    self.titleLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 - 100 - 15 -15;
    
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(8);
        make.left.equalTo(self.headImgView.mas_right).offset(13);
        make.width.height.mas_equalTo(13);
        
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signView.mas_top).offset(-2);
        make.left.equalTo(self.signView.mas_right).offset(5);
        
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signView.mas_bottom).offset(4);
        make.left.equalTo(self.signView.mas_left);
        
    }];
    
    [self.personLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLb.mas_bottom).offset(-2);
        make.left.equalTo(self.priceLb.mas_right).offset(5);
 
    }];
    
    [self.signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLb.mas_bottom).offset(2);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
        
    }];
}

-(void)setAllModel:(allRecommentModel *)allModel{
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:allModel.comment_img] placeholderImage:[UIImage imageNamed:@"nsme_ke"]];
    self.titleLb.text = allModel.title;
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 100 -15 - 15 - 13, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    CGRect contenRect = [self.titleLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    if (contenRect.size.height < 21) {
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImgView).offset(17);
            make.left.equalTo(self.headImgView.mas_right).offset(13);
            
        }];
        
    }else if (contenRect.size.height >41){
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImgView).offset(-5);
            make.left.equalTo(self.headImgView.mas_right).offset(13);
            
        }];
    }else{
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImgView.mas_top).offset(8);
            make.left.equalTo(self.headImgView.mas_right).offset(13);
            
        }];
    }
    
    // 不然在6/6plus上就不准确了
    self.titleLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 - 100 - 15 -15;
    NSString *moneyStr = [NSString stringWithFormat:@"¥ %@",allModel.money];
    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
    [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, [moneyStr length] - 1)];
    self.priceLb.attributedText = centStr;
    self.timeLb.text = [NSString stringWithFormat:@"截止时间：%@",allModel.endDate];
    
    
    // ------实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];//这里的格式必须和DateString格式一致
    
    // ------将需要转换的时间转换成 NSDate 对象
    NSDate * nowDate = [NSDate date];
    //    NSDate *beginDate = [dateFormatter dateFromString:menuList[@"biginDate"]];
    NSDate *endDate = [dateFormatter dateFromString:allModel.endDate];
    
    // ------取当前时间和转换时间两个日期对象的时间间隔
    //    NSTimeInterval time = [nowDate timeIntervalSinceDate:beginDate];
    NSTimeInterval overTime = [nowDate timeIntervalSinceDate:endDate];
    
    if (overTime > 0) {
      
        [self.signButton setTitle:@"报名结束" forState:UIControlStateNormal];
        self.signButton.backgroundColor = [UIColor colorWithHexString:@"#b1b4b3"];
    }else{
    
        [self.signButton setTitle:@"立即报名" forState:UIControlStateNormal];
        [self.signButton setBackgroundColor:[UIColor colorWithHexString:@"#f85555"]];
        [self.signButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    }
    
    if (!allModel.apply_count) {
        
        self.personLb.text = @"已有0人报名";
    }else{
        
        int count = [allModel.count intValue];
        int applyCount = [allModel.apply_count intValue];
        int count1 = count + applyCount;
        NSString *countStr = [NSString stringWithFormat:@"%d",count1];
        self.personLb.text = [NSString stringWithFormat:@"已有%@人报名",countStr];
    }
    self.signView.image = [UIImage imageNamed:@"time"];
}

-(CGFloat)cellHeight{

    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 100 -15 - 15 - 13, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    CGRect contenRect = [self.titleLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

    if (contenRect.size.height < 41) {
        
        _cellHeight = 130;
    }else{
        
        _cellHeight = contenRect.size.height + 15 + 20 + 16 + 16 + 30;
    }

    return _cellHeight;
}

-(void)pressBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(pressBtn:)]) {
        [_delegate pressBtn:self];
    }
}

@end
