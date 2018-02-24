//
//  hotCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotCell.h"

@implementation hotCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        [self layoutUI];
    }
    return self;
}

-(void)createView{
    
    _contentLb = [[UILabel alloc]init];
    _contentLb.numberOfLines = 0;
    _contentLb.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_contentLb];

    _nameLb = [[UILabel alloc]init];
    _nameLb.font = [UIFont systemFontOfSize:12];
    _nameLb.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_nameLb];

//    _commentLb = [[UILabel alloc]init];
//    _commentLb.font = [UIFont systemFontOfSize:12];
//    _commentLb.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_commentLb];

    _timeLb = [[UILabel alloc]init];
    _timeLb.font = [UIFont systemFontOfSize:12];
    _timeLb.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLb];

    _headImgView = [[UIImageView alloc]init];
    _headImgView.clipsToBounds = YES;
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_headImgView];
}

-(void)layoutUI{
    __weak typeof(self) weakSelf = self;
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.right.equalTo(weakSelf.headImgView.mas_left).offset(-15);
        make.left.equalTo(weakSelf.contentView).offset(15);
        
    }];
    
    // 不然在6/6plus上就不准确了
    self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15 - 70 -15;
    [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLb.mas_bottom).offset(4);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.height.mas_equalTo(20);

    }];
    
//    [_commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.nameLb.mas_top);
//        make.left.equalTo(weakSelf.nameLb.mas_right).offset(10);
//        make.height.mas_equalTo(20);
//        
//    }];
    
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLb.mas_top);
        make.left.equalTo(weakSelf.nameLb.mas_right).offset(10);
        make.height.mas_equalTo(20);

    }];
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.width.height.mas_equalTo(70);
    
    }];
}

-(void)setHotModel:(hotArticleModel *)hotModel{
    
    _hotModel = hotModel;
    _contentLb.text =_hotModel.title;
    _contentLb.numberOfLines = 0;
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 - 15 - 70 - 15, CGFLOAT_MAX);
    //  计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    if (contenRect.size.height < 21) {
        
       [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.contentView).offset(26);
           make.right.equalTo(self.headImgView.mas_left).offset(-15);
           make.left.equalTo(self.contentView).offset(15);
           make.height.mas_equalTo(21);
           
        }];
        
        // 不然在6/6plus上就不准确了
        self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15 - 70 -15;
        [_headImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);
            
        }];
    }
    else if(contenRect.size.height > 21 && contenRect.size.height <41){

        [_headImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);

        }];
    
        [_contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(18);
            make.right.equalTo(self.headImgView.mas_left).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
            
        }];
    
        // 不然在6/6plus上就不准确了
        self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15 - 70 -15;
    }else{
    
        [_contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15);
            make.right.equalTo(self.headImgView.mas_left).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
            
        }];
    }

    _nameLb.text = _hotModel.source;
    NSString *tiemStr = [self formateDate:[NSString stringWithFormat:@"%@",_hotModel.createDate]];
    _timeLb.text = tiemStr;
    _commentLb.text = [NSString stringWithFormat:@"评论%@",_hotModel.comment_count];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_hotModel.imgs] placeholderImage:[UIImage imageNamed:@"nsme_ke"]];
}

- (CGFloat)cellHeight{
    
    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 -15 - 70 - 15, CGFLOAT_MAX);
    
    //  计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    if (contenRect.size.height < 41) {
     
        _cellHeight = 41 + 20 + 15 + 15 + 5 + 5;
    }else{
    
        _cellHeight = contenRect.size.height + 20 + 15 + 15 + 8;
    }
    
    return _cellHeight;
}

#pragma mark--时间转化的方法
- (NSString *)formateDate:(NSString *)dateString
{
    @try {
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        NSDate * nowDate = [NSDate date];
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        // ------再然后，把间隔的秒数折算成天数和小时数：
        NSString *dateStr = [[NSString alloc] init];
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        }else if(time<=60*60*24){  //在两天内的
            
            int hours = time/3600;
            dateStr = [NSString stringWithFormat:@"%d小时前",hours];
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

@end
