//
//  addfriendViewCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "addfriendViewCell.h"

@implementation addfriendViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layotUI];
    }
    return self;
}

-(void)createView{

    self.headView = [[UIImageView alloc]init];
    self.headView.layer.cornerRadius = 22.5;
    self.headView.layer.masksToBounds = YES;
    self.headView.userInteractionEnabled = YES;
    self.headView.image = [UIImage imageNamed:@"ride_snap_default"];
    [self addSubview:self.headView];

    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = @"张三";
    [self addSubview:self.nameLable];
    
    self.contentLable = [[UILabel alloc]init];
    self.contentLable.text = @"大家哈立场坚定放你出来这几年里疯狂聚；OKCoin";
    self.contentLable.textColor = [UIColor lightGrayColor];
    self.contentLable.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.contentLable];
    
    self.jieShouBtn = [[UIButton alloc]init];
    self.jieShouBtn.layer.cornerRadius = 5;
    self.jieShouBtn.backgroundColor = [UIColor colorWithHexString:@"#45b7ff"];
    [self.jieShouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.jieShouBtn setTitle:@"接受" forState:UIControlStateNormal];
    self.jieShouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.jieShouBtn addTarget:self action:@selector(jieshouBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.jieShouBtn];
    
}

-(void)layotUI{
    __weak typeof(self)weakSelf = self;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf).offset(10);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(15);
        make.left.equalTo(weakSelf.headView.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLable.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.nameLable.mas_left);
//        make.right.equalTo(weakSelf.jieShouBtn.mas_left).offset(-5);
        
    }];

    [self.jieShouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
}

-(void)jieshouBtnClick{
    
        if(_delegate && [_delegate respondsToSelector:@selector(applyCellAddFriendCell:)])
        {
            [_delegate applyCellAddFriendCell:self];
        }
}

-(void)setApplyEntity:(ApplyEntity *)entity ApplyStyle:(ApplyStyle)applyStyle{

    DDLog(@"%@",entity.reason);
    self.contentLable.text = entity.reason;
    self.contentLable.width = [self.contentLable.text safelySizeWithFont:self.contentLable.font constrainedToSize:CGSizeMake(kScreenWidth*0.36, self.contentLable.height)].width;
    
    if (applyStyle == ApplyStyleAgreedFriend){
        
        self.nameLable.text = [ETRegularUtil isEmptyString:entity.applicantNick] ? @"" : entity.applicantNick;
        [self.headView setImageWithURL:[NSURL URLWithString:entity.applicantSanp] placeholder:[UIImage imageBundleNamed:@"ride_snap_default.png"]];
        [self.jieShouBtn setTitle:@"已接受" forState:UIControlStateNormal];
       
    }else if (applyStyle == ApplyStyleFriend){
        
        self.contentLable.text = [ETRegularUtil isEmptyString:entity.applicantNick] ? @"" : entity.applicantNick;
        [self.headView setImageWithURL:[NSURL URLWithString:entity.applicantSanp] placeholder:[UIImage imageBundleNamed:@"ride_snap_default.png"]];
    
        
        if ([ETRegularUtil isEmptyString:entity.reason]) {
            
            self.contentLable.text = @"来自家长圈";
        }
    }
}

-(void)setChatModel:(chatViewModel *)chatModel{
    
    self.contentLable.text = [NSString stringWithFormat:@"申请理由：%@",chatModel.remarks] ;
    self.nameLable.text = chatModel.nickName;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:chatModel.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
}

+ (CGFloat)heightWithContent:(NSString *)content
{
    if (!content || content.length == 0) {
        return 60;
    }
    else{
        NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0], NSFontAttributeName,nil];
        CGSize size = [content boundingRectWithSize:CGSizeMake(320 - 60 - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        return size.height > 20 ? (size.height + 40) : 60;
    }
}

@end
