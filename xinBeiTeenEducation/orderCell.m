//
//  orderCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "orderCell.h"

@interface orderCell()<orderFootViewDelegate>

@end

@implementation orderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"学前语文考试";
    self.titleLb.textColor = [UIColor colorWithHexString:@"#000000"];
    self.titleLb.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.titleLb];

    self.completeLb = [[UILabel alloc]init];
    self.completeLb.text = @"已完成";
    self.completeLb.font = [UIFont systemFontOfSize:14];
    self.completeLb.textColor = [UIColor colorWithHexString:@"#fe6400"];
    self.completeLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.completeLb];
    
    self.deleteImg = [[UIImageView alloc]init];
    self.deleteImg.image = [UIImage imageNamed:@"delete"];
    self.deleteImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ondeleteImg:)];
    [self.deleteImg addGestureRecognizer:tapImage];
    [self.contentView addSubview:self.deleteImg];
    
    self.levelLb = [[UILabel alloc]init];
    self.levelLb.font = [UIFont systemFontOfSize:14];
    self.levelLb.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:self.levelLb];
    
    self.timeLb = [[UILabel alloc]init];
    self.timeLb.font = [UIFont systemFontOfSize:14];
    self.timeLb.text = @"2016-8-25";
    self.timeLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    [self.contentView addSubview:self.timeLb];
    
    self.priceLb = [[UILabel alloc]init];
    self.priceLb.font = [UIFont systemFontOfSize:14];
    self.priceLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    self.priceLb.text = @"报名费用：¥125";
    self.priceLb.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.priceLb.text];
    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5c5c5c"] range:NSMakeRange(5,  self.priceLb.text.length - 5)];
    [centStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(6, self.priceLb.text.length - 6)];
    self.priceLb.attributedText = centStr;
    [self.contentView addSubview:self.priceLb];
    
    self.testTimeLb = [[UILabel alloc]init];
    self.testTimeLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.testTimeLb];
    
    self.nameLb = [[UILabel alloc]init];
    self.nameLb.text = @"考生姓名：lily";
    self.nameLb.textColor = [UIColor colorWithHexString:@"#5c5c5c"];
    NSMutableAttributedString *centStr1 = [[NSMutableAttributedString alloc]initWithString:self.nameLb.text];
    [centStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5c5c5c"] range:NSMakeRange(0, 5)];
    self.nameLb.attributedText = centStr1;
    self.nameLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLb];
    
    self.sepeView = [[UIView alloc]init];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.sepeView];
    
    self.lineView = [[UIView alloc]init];
     self.lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.lineView];
    
    self.footView = [[orderFootView alloc]init];
    self.footView.delegate = self;
    [self.contentView addSubview:self.footView];
}

-(void)layoutUI{
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLb.mas_right).offset(15);
        make.top.equalTo(self.timeLb.mas_top);
    }];
    
    [self.completeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLb.mas_top);
        make.right.equalTo(self.deleteImg.mas_left).offset(-10);
        make.bottom.equalTo(self.timeLb.mas_bottom);
    }];
    
    [self.deleteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
       make.top.equalTo(self.contentView).offset(8);
       make.right.equalTo(self.contentView).offset(-15);
       make.width.mas_equalTo(21);
       make.height.mas_equalTo(23);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLb.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.equalTo(self.titleLb.mas_bottom).offset(10);
         make.left.equalTo(self.titleLb.mas_left);
    }];
    
    [self.levelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLb.mas_bottom).offset(5);
        make.left.equalTo(self.titleLb.mas_left);
    }];
    
    
    [self.testTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.levelLb.mas_bottom).offset(5);
        make.left.equalTo(self.levelLb.mas_left);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testTimeLb.mas_bottom).offset(15).priorityLow();
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
}

-(void)setModel:(allorderModel *)model{

    self.titleLb.text = [NSString stringWithFormat:@"%@",model.title];

    NSString *payStr = [NSString stringWithFormat:@"%@",model.payStatus];
        if ([payStr isEqualToString:@"1"]) {
        self.completeLb.text = @"已支付";
        self.deleteImg.hidden = YES;
        self.deleteImg.userInteractionEnabled = NO;
    }else if([payStr isEqualToString:@"2"]){
        
        self.completeLb.text = @"已退费";
        self.deleteImg.hidden = YES;
        self.deleteImg.userInteractionEnabled = NO;
    }else{
        
        self.completeLb.text = @"待支付";
    }
    
    self.levelLb.text = [NSString stringWithFormat:@"考试级别：%@",model.type_name];
    NSMutableAttributedString *leveStr = [[NSMutableAttributedString alloc]initWithString:self.levelLb.text];
    [leveStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#323232"] range:NSMakeRange(0, 5)];
    [leveStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, self.levelLb.text.length - 5)];
    self.levelLb.attributedText = leveStr;

    self.nameLb.text = [NSString stringWithFormat:@"考生姓名：%@",model.examinee_name];
    self.nameLb.textColor = [UIColor colorWithHexString:@"#666666"];
    NSMutableAttributedString *centStr1 = [[NSMutableAttributedString alloc]initWithString:self.nameLb.text];
    [centStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#323232"] range:NSMakeRange(0, 5)];
     [centStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, self.nameLb.text.length - 5)];
    self.nameLb.attributedText = centStr1;
    
    self.testTimeLb.text = [NSString stringWithFormat:@"考试时间：%@",model.subject_date];
    self.testTimeLb.textColor = [UIColor colorWithHexString:@"#666666"];
    NSMutableAttributedString *testCentStr = [[NSMutableAttributedString alloc]initWithString:self.testTimeLb.text];
    [testCentStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#323232"] range:NSMakeRange(0, 5)];
    [testCentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, self.testTimeLb.text.length - 5)];
    self.testTimeLb.attributedText = testCentStr;
    
    NSString *time= [NSString stringWithFormat:@"%@",model.orderCreateDate];//报名时间
    NSArray *tiemArray = [time componentsSeparatedByString:@"."];
    NSString *timeStr = tiemArray[0];
    self.timeLb.text = timeStr;
    self.priceLb.text = [NSString stringWithFormat:@"¥%@",model.orderMoney];
}

- (void)ondeleteImg:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onDeleteOrderInCell:)]) {
            [_delegate onDeleteOrderInCell:self];
        }
    }
}

-(void)onHelp{

    if (_delegate && [_delegate respondsToSelector:@selector(onBeforeTestInCell:)]) {
        [_delegate onBeforeTestInCell:self];
    }
}

-(void)onTestCard{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onTestDownLoadingInCell:)]) {
        [_delegate onTestDownLoadingInCell:self];
    }
}

-(void)onScore{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onCheckScoreInCell:)]) {
        [_delegate onCheckScoreInCell:self];
    }
}

@end
