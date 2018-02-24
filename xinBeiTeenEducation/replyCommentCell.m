//
//  replyCommentCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "replyCommentCell.h"
#import "NSString+emojiy.h"

@implementation replyCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
    }
    return self;
}

-(void)createView{
    
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
    _imgSex.image = [UIImage imageNamed:@"boy"];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatar:)];
    [_imgSex addGestureRecognizer:tapImage];
    [self.contentView addSubview:self.imgSex];
    
    _timeLable = [UILabel new];
    _timeLable.text = @"11-21 07:01";
    self.timeLable.textColor = [UIColor lightGrayColor];
    _timeLable.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.timeLable];
    
    _likeBtn = [UIButton new];
    [_likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(onLikeInCell:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.likeBtn];
    
    _labelContent = [copyLable new];
    _labelContent.font = [UIFont systemFontOfSize:16];
    _labelContent.text = @"语文是语言和文学、文化的简称，包括口头语言和书面语言；口头语言较随意，直接易懂，而书面语言讲究准确和语法；文学包括中外古今文学等。此解释概念较狭窄，因为语文中的文章";
    _labelContent.numberOfLines = 0;
    _labelContent.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.labelContent];
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
    
    //点赞
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.top.equalTo(weakSelf.labelName.mas_top);
        make.width.height.mas_equalTo(40);
    }];
    
    //文本内容
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.timeLable.mas_left);
        make.right.equalTo(weakSelf.contentView).offset(-15);
    }];
}

-(void)setReplyModel:(replyCommentModel *)replyModel{
    
    _replyModel = replyModel;
    [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:replyModel.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    if ([ETRegularUtil isEmptyString:replyModel.from_remarkName]) {
        
        self.labelName.text = replyModel.from_nickName;
    }else{
     
        self.labelName.text = replyModel.from_remarkName;
    }
    
    NSString * likeStatus = [NSString stringWithFormat:@"%@",replyModel.likeCommentStatus];
    if ([likeStatus isEqualToString:@"1"]) {
        
        [_likeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        _likeBtn.selected = NO;
    }else{
        
        [_likeBtn setImage:[UIImage imageNamed:@"push2"] forState:UIControlStateNormal];
        _likeBtn.selected = YES;
    }
    
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@",replyModel.commentLike] forState:UIControlStateNormal];
    [_likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 5, 0)];
    
    self.timeLable.text = replyModel.createDate;
    self.labelContent.text = replyModel.content;
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[NSString stringWithFormat:@"%@",self.labelContent.text] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    if ([NSString stringContainsEmoji:decodedString]) {
        
        self.labelContent.text = decodedString;
    }
    
    NSString *sexStr1 = [NSString stringWithFormat:@"%@",replyModel.sex];
    if ([sexStr1 isEqualToString: @"1"]) {
        
        self.imgSex.image = [UIImage imageNamed:@"girl"];
    }else {
        
        self.imgSex.image = [UIImage imageNamed:@"boy"];
    }
}

-(CGFloat)cellHeight{

    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
    CGSize maxSize = CGSizeMake(ScreenWidth - 85, CGFLOAT_MAX);
    
    //  计算内容label的高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    CGRect contenRect = [self.labelContent.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    _cellHeight = contenRect.size.height + 80;
    return _cellHeight;
}

#pragma mark - Gesture
- (void)onAvatar:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onAvatarInCell:)]) {
            [_delegate onAvatarInCell:self];
        }
    }
}

- (void)onLikeInCell:(UIButton *)sender{

    if (_delegate && [_delegate respondsToSelector:@selector(onLikeInCell:)]) {
        [_delegate onLikeInCell:self];
    }
}

@end
