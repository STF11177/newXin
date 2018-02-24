//
//  parentCommentCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "parentCommentCell.h"
#import "NSString+emojiy.h"

@implementation parentCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgvAvatar = [UIImageView new];
        _imgvAvatar.layer.cornerRadius = 22.5;
        _imgvAvatar.layer.masksToBounds = YES;
        _imgvAvatar.userInteractionEnabled = YES;
        _imgvAvatar.image = [UIImage imageNamed:@"ride_snap_default"];
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatar:)];
        [_imgvAvatar addGestureRecognizer:tapGuesture];
        [self.contentView addSubview:self.imgvAvatar];
        
        _labelName  = [UILabel new];
        _labelName.font = [UIFont systemFontOfSize:15.0f];
        _labelName.userInteractionEnabled = YES;
        _labelName.text = @"一个超酷的理科生";
        self.labelName.textColor = [UIColor colorWithHexString:@"#e0592b"];
        UITapGestureRecognizer *tapLable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatar:)];
        [_labelName addGestureRecognizer:tapLable];
        [self.contentView addSubview:self.labelName];
        
        _imgSex = [UIImageView new];
        _imgSex.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatar:)];
        [_imgSex addGestureRecognizer:tapImage];
        [self.contentView addSubview:self.imgSex];
        
        _timeLable = [UILabel new];
        _timeLable.text = @"11-21 07:01";
        self.timeLable.textColor = [UIColor lightGrayColor];
        _timeLable.font = [UIFont systemFontOfSize:12.0f];
//        _timeLable.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.timeLable];
        
//        _comemntBtn = [UIButton new];
//        [_comemntBtn setImage:[UIImage imageNamed:@"discuss"] forState:UIControlStateNormal];
//        [_comemntBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.comemntBtn];
        
//        _likeBtn = [UIButton new];
//        [_likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
//        [_likeBtn addTarget:self action:@selector(onLikeInCell:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.likeBtn];
        
        _labelContent = [UILabel new];
        _labelContent.font = [UIFont systemFontOfSize:16];
        _labelContent.text = @"语文是语言和文学、文化的简称，包括口头语言和书面语言；口头语言较随意，直接易懂，而书面语言讲究准确和语法；文学包括中外古今文学等。此解释概念较狭窄，因为语文中的文章";
        _labelContent.numberOfLines = 0;
        [self.contentView addSubview:self.labelContent];

        self.picContainerView = [[parentDiscusstView alloc] initWithWidth:SCREEN_WIDTH- 100];
        [self.contentView addSubview:self.picContainerView];
        
        _checkLb = [UILabel new];
        _checkLb.text = @"查看原文";
        _checkLb.textColor = [UIColor colorWithHexString:@"#5184BC"];
        _checkLb.font = [UIFont systemFontOfSize:16];
        _checkLb.textAlignment = NSTextAlignmentLeft;
        _checkLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkBtnClick:)];
        [_checkLb addGestureRecognizer:tap];
        [self.contentView addSubview:self.checkLb];
        
        [self layOutUI];
    }
    return self;
}

-(void)layOutUI{
    
    __weak typeof(self)weakSelf = self;
    //头像
    [self.imgvAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.width.height.mas_equalTo(45);
    }];
    
    //名字
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(20);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        make.right.equalTo(weakSelf.imgSex.mas_left).offset(-10);//对象本身对右边（right）的约束为负，对（bottom）下面的约束为负
    }];
    
    //性别的图标
    [self.imgSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.labelName.mas_bottom);
        make.left.equalTo(weakSelf.labelName.mas_right).offset(10);
        make.width.height.mas_equalTo(15);
    }];

    //时间
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelName.mas_bottom).offset(3);
        make.left.equalTo(weakSelf.labelName.mas_left);
    }];

    //评论
//    [self.comemntBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(weakSelf.contentView).offset(-10);
//        make.top.equalTo(weakSelf.labelName.mas_top);
//        make.width.height.mas_equalTo(40);
//    }];

//    //点赞
//    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(weakSelf.comemntBtn.mas_left).offset(-10);
//        make.top.equalTo(weakSelf.labelName.mas_top);
//        make.width.height.mas_equalTo(40);
//    }];

    //文本内容
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLable.mas_bottom).offset(11);
        make.left.equalTo(weakSelf.timeLable.mas_left);
        make.right.equalTo(weakSelf.contentView).offset(-15);
    }];

    //不然在6/6plus上就不准确了
    self.labelContent.preferredMaxLayoutWidth = SCREEN_WIDTH - 100;

    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelContent.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.labelContent.mas_left);
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.height.mas_equalTo(0);
    }];
    [self.picContainerView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.picContainerView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];

    //查看微博
    [self.checkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.picContainerView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.labelContent.mas_left);
        make.width.mas_equalTo(100);
        
    }];
}

-(void)setModel:(parentdiscussModel *)model{
    
    _model = model;
    self.timeLable.text = model.createDate;
    [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    self.labelName.text = model.from_nickName;
    self.labelContent.text = model.content;
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[NSString stringWithFormat:@"%@",self.labelContent.text] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    if ([NSString stringContainsEmoji:decodedString]) {
        
        self.labelContent.text = decodedString;
    }
    
    NSString *str = model.commentImg;
    NSArray *picViews =[str componentsSeparatedByString:@"|"];
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picViews) {
        
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.picContainerView.picUrlArray = picViews;
}

#pragma mark - Gesture
- (void)onAvatar:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onImageInCell:)]) {
            [_delegate onImageInCell:self];
        }
    }
}

//- (void)commentBtnClick:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (_delegate && [_delegate respondsToSelector:@selector(onCommentInCell:)]) {
//        [_delegate onCommentInCell:self];
//    }
//}

- (void)checkBtnClick:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onCheckInCell:)]) {
            [_delegate onCheckInCell:self];
        }
    }
}

@end
