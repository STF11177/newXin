//
//  discussDetailCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import "discussDetailCell.h"

#define userDefault [NSUserDefaults standardUserDefaults]
@implementation discussDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.headLb];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.contentLb];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.replyBtn];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.lineView];
        
        [self layOutUI];
    }
    return self;
}

-(UIImageView *)headImageView{
    
    if (!_headImageView) {
        
        _headImageView = [[UIImageView alloc]init];
        _headImageView.image = [UIImage imageNamed:@"ride_snap_default"];
        _headImageView.layer.cornerRadius = 17.5;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

-(UILabel *)headLb{
    
    if (!_headLb) {
        
        _headLb = [[UILabel alloc]init];
        _headLb.text = @"五星红旗";
        _headLb.font = [UIFont systemFontOfSize:14];
        _headLb.textColor = [UIColor colorWithHexString:@"#5184BC"];
    }
    return _headLb;
}

-(UIButton *)likeBtn{
    
    if (!_likeBtn) {
        
        _likeBtn = [[UIButton alloc]init];
        [_likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

-(UILabel *)contentLb{
    
    if (!_contentLb) {
        
        _contentLb = [[UILabel alloc]init];
        _contentLb.numberOfLines = 0;
        _contentLb.text = @"人生若只如初见，何事秋风悲画扇，等闲变却故人心，却道古人心易变.";
    }
    return _contentLb;
}

-(UILabel *)timeLb{
    
    if (!_timeLb) {
        
        _timeLb = [[UILabel alloc]init];
        _timeLb.text = @"01-17 21:46";
        _timeLb.font = [UIFont systemFontOfSize:12];
    }
    return _timeLb;
}

-(UIButton *)replyBtn{
    
    if (!_replyBtn) {
        
        _replyBtn = [[UIButton alloc]init];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _replyBtn;
}

-(UIButton *)deleteBtn{
    
    if (!_deleteBtn) {
        
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#5184BC"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _deleteBtn;
}

-(UIView *)lineView{

    if (!_lineView) {

        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    return _lineView;
}

-(void)layOutUI{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
//      make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.centerY.equalTo(self.headImageView.mas_centerY);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.headImageView.mas_centerY);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headLb.mas_left);
        make.top.equalTo(self.headLb.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLb.mas_left);
        make.top.equalTo(self.contentLb.mas_bottom).offset(15);
    }];
    
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLb.mas_right).offset(15);
        make.top.equalTo(self.timeLb.mas_top).offset(-3);
        make.height.mas_equalTo(25);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.replyBtn.mas_top);
        make.height.mas_equalTo(25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(ScreenWidth - 15);
        make.height.mas_equalTo(1);
    }];
}

-(void)setModel:(detailCommentModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    self.headLb.text = [NSString stringWithFormat:@"%@",model.from_nickName];
    NSString *tiemStr = [self formateDate:[NSString stringWithFormat:@"%@",model.createDate]];
    self.timeLb.text = tiemStr;
    
    NSString *userId =   [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"userName"]];
    NSString *from_Uid = [NSString stringWithFormat:@"%@",model.from_userId];
    
    if ([userId isEqualToString:from_Uid]) {

        self.deleteBtn.hidden = NO;
    }else{

        self.deleteBtn.hidden = YES;
    }
    
     NSString *likeStatus = [NSString stringWithFormat:@"%@",model.likeCommentStatus];
    if ([likeStatus isEqualToString:@"0"]) {
        
        [self.likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
    }else{
        
        [self.likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    }
    
    if (model.commentLike == 0) {
        
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",@"赞"] forState:UIControlStateNormal];
    }else{
        
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d",model.commentLike] forState:UIControlStateNormal];
    }
    
    [self.likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    NSString *remarkContent = [NSString stringWithFormat:@"%@",model.remarkContent];
    if (![ETRegularUtil isEmptyString:remarkContent]) {
        
        NSString *beComment = [NSString stringWithFormat:@"@%@：",model.remarkName];
        NSString *contentStr = [NSString stringWithFormat:@"%@//%@%@",model.content,beComment,remarkContent];
        
        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithHexString:@"#5184BC"]
        range:NSMakeRange(model.content.length+2,beComment.length)];
        self.contentLb.attributedText = attrDescribeStr;
    }else{
        
        self.contentLb.text = [NSString stringWithFormat:@"%@",model.content];
    }
}

-(CGFloat)cellHeightWithModel:(detailCommentModel *)model{

    return model.cellHeight;
}

-(void)replyBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(replyBtnInCell:)]) {
        [_delegate replyBtnInCell:self];
    }
}

-(void)likeClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(likeInCell:)]) {
        [_delegate likeInCell:self];
    }
}

-(void)deleteClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteInCell:)]) {
        [_delegate deleteInCell:self];
    }
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
