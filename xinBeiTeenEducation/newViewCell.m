//
//  newViewCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/8.
//  Copyright © 2017年 user. All rights reserved.
//

#import "newViewCell.h"
#import "YHWorkGroupPhotoContainer.h"
#import "ETRegularUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

const CGFloat contentLabelFontSize = 13.0;
CGFloat maxContentLabelHeight = 0;  //根据具体font而定
CGFloat kMarginContentLeft    = 10; //动态内容左边边距
CGFloat kMarginContentRight   = 10; //动态内容右边边边距
const CGFloat deleteBtnHeight = 30;
const CGFloat deleteBtnWidth  = 60;
const CGFloat moreBtnHeight   = 30;
const CGFloat moreBtnWidth    = 60;

@interface newViewCell()<footViewDelegate>

@end

@implementation newViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
    
    self.imgvAvatar = [UIImageView new];
    self.imgvAvatar.layer.cornerRadius = 22.5;
    self.imgvAvatar.layer.masksToBounds = YES;
    self.imgvAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatar:)];
    [self.imgvAvatar addGestureRecognizer:tapGuesture];
    [self.contentView addSubview:self.imgvAvatar];
    
    self.labelName  = [UILabel new];
    self.labelName.font = [UIFont systemFontOfSize:15.0f];
    self.labelName.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatar:)];
    [self.labelName addGestureRecognizer:tapLable];
    [self.contentView addSubview:self.labelName];
    
    self.imgSex = [UIImageView new];
    self.imgSex.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAvatar:)];
    [self.imgSex addGestureRecognizer:tapImage];
    [self.contentView addSubview:self.imgSex];
    
    self.imgArrow = [UIImageView new];
    self.imgArrow.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapArrow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIMageArrow:)];
    [self.imgArrow addGestureRecognizer:tapArrow];
    [self.contentView addSubview:self.imgArrow];
    
    self.timeLable = [UILabel new];
    self.timeLable.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.timeLable];
    
    self.labelJob = [UILabel new];
    self.labelJob.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.labelJob];
    
    self.labelContent = [copyLable new];
    self.labelContent.font = [UIFont systemFontOfSize:contentLabelFontSize];
    self.labelContent.numberOfLines = 5;
    [self.contentView addSubview:self.labelContent];
    
    self.labelDelete = [UILabel new];
    self.labelDelete.hidden = YES;
    self.labelDelete.font = [UIFont systemFontOfSize:14.0f];
    self.labelDelete.textColor = RGBCOLOR(61, 95, 155);
    self.labelDelete.userInteractionEnabled = YES;
    UITapGestureRecognizer *deleteTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTap)];
    [self.labelDelete addGestureRecognizer:deleteTap];
    [self.contentView addSubview:self.labelDelete];
    
    self.labelMore = [UILabel new];
    self.labelMore.hidden = YES;
    self.labelMore.font = [UIFont systemFontOfSize:14.0f];
    self.labelMore.textColor = RGBCOLOR(0, 191, 143);
    self.labelMore.userInteractionEnabled = YES;
    UITapGestureRecognizer *moreTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreTap)];
    [self.labelMore addGestureRecognizer:moreTap];
    [self.contentView addSubview:self.labelMore];

    self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:SCREEN_WIDTH-30];

    [self.contentView addSubview:self.picContainerView];
    
    self.viewBottom = [fooView new];
    self.viewBottom.delegate = self;
    [self.contentView addSubview:self.viewBottom];
    
    self.viewSeparator = [UIView new];
    self.viewSeparator.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.viewSeparator];

    self.backImageView = [[UIImageView alloc]init];
    // 设置imageView的tag，在PlayerView中取（建议设置100以上）
    self.backImageView.tag = 101;
    [self.contentView addSubview:self.backImageView];
    
    self.playBtn = [[UIButton alloc]init];
    [self.playBtn setImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
    self.backImageView.userInteractionEnabled = YES;
//    self.player.backgroundColor = [UIColor lightGrayColor];
    [self.playBtn addTarget:self action:@selector(playBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:self.playBtn];
    
    [self layoutUI];
}

- (void)layoutUI{
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
    //右边向下的jian头
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(7);
        make.right.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(43);
        make.height.mas_equalTo(37);
    }];
    
    //时间
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelName.mas_bottom).offset(3);
        make.left.equalTo(weakSelf.labelName.mas_left);
        make.right.equalTo(weakSelf.labelJob.mas_left).offset(-10);
    }];
    
    //小升初
    [self.labelJob mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.timeLable.mas_bottom);
        make.left.equalTo(weakSelf.timeLable.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    //文本内容
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(11);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.bottom.equalTo(weakSelf.labelMore.mas_top).offset(-11);
    }];
    
    // 不然在6/6plus上就不准确了
    self.labelContent.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
    
    [self.labelMore mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.labelContent.mas_bottom).offset(11);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    
    [self.labelDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.labelMore.mas_centerY);
        make.left.equalTo(weakSelf.labelMore.mas_right).offset(10);
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
      make.top.equalTo(weakSelf.labelMore.mas_bottom).offset(0);
      make.left.equalTo(weakSelf.contentView).offset(15);
      make.right.equalTo(weakSelf.contentView).offset(-15);
      make.height.mas_equalTo(0);
    }];

    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakSelf.backImageView);
        make.width.height.mas_equalTo(0);
    }];
    
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelMore.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.height.mas_equalTo(0);
        make.right.mas_greaterThanOrEqualTo(weakSelf.contentView).offset(-15);
    }];
    [self.picContainerView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.picContainerView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
    
    [self.viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.picContainerView.mas_bottom).offset(15).priorityLow();
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    
    [self.viewSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.viewBottom.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(weakSelf.contentView);
    }];    
}

-(void)setMenuListModel:(menuListModel *)menuListModel{

    _menuListModel = menuListModel;
    [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:_menuListModel.faceImg] placeholderImage:[UIImage imageNamed:@"ride_snap_default"]];
    self.labelName.textColor = [UIColor colorWithHexString:@"#e0592b"];
    self.labelName.font = [UIFont systemFontOfSize:15];
    NSString *remarkStr = [NSString stringWithFormat:@"%@",_menuListModel.remarkName];
    
    if ([ETRegularUtil isEmptyString:remarkStr]) {
        
        self.labelName.text = _menuListModel.nickName;
    }else {
        
        self.labelName.text = _menuListModel.remarkName;
    }
    
    self.imgArrow.image =[UIImage imageNamed:@"pull_down"];
    self.timeLable.text = _menuListModel.createDate;
    self.timeLable.textColor = [UIColor lightGrayColor];
    self.timeLable.font = [UIFont systemFontOfSize:12];
    
    NSString *sexStr = [NSString stringWithFormat:@"%@",_menuListModel.sex];
        if ([sexStr isEqualToString: @"1"]) {
    
            self.imgSex.image = [UIImage imageNamed:@"girl"];
        }else {
    
            self.imgSex.image = [UIImage imageNamed:@"boy"];
        }
    self.labelJob.text = _menuListModel.typeName;
    self.labelJob.textColor = [UIColor lightGrayColor];
    self.labelJob.font = [UIFont systemFontOfSize:12];
    
    self.titleLb =[[UILabel alloc]init];
    self.titleLb.text = _menuListModel.title;
    
    self.contLb =[[UILabel alloc]init];
    self.contLb.text = _menuListModel.content;
    

    NSString *conStr;
    NSMutableAttributedString *centStr;
    if ([self isBlankString:self.titleLb.text]||[self isBlankString:self.contLb.text]) {
        
        conStr =[self.titleLb.text stringByAppendingString:self.contLb.text];
    }else{
        
        conStr = [@"//" stringByAppendingString:self.contLb.text];
    }
    
    if ([self isBlankString:self.contLb.text]) {
        conStr = @"";
    }
    
    NSString *str =[self.titleLb.text stringByAppendingString:conStr];
    if ([ETRegularUtil isEmptyString:str]) {
        
        str = @"";
    }
    
    centStr = [[NSMutableAttributedString alloc]initWithString:str];
    [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(0, self.titleLb.text.length)];
    
    if ([self isBlankString:self.titleLb.text]||[self isBlankString:self.contLb.text]) {
        
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3e3e3e"] range:NSMakeRange(self.titleLb.text.length, self.contLb.text.length)];
    }else{
        
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3e3e3e"] range:NSMakeRange(self.titleLb.text.length, conStr.length)];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [centStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, centStr.length)];
    
    self.labelContent.attributedText = centStr;
    self.labelContent.lineBreakMode = NSLineBreakByTruncatingTail;
    self.labelContent.font = [UIFont systemFontOfSize:17];
    
    WeakSelf
//   查看详情按钮
//   self.labelMore.text  = @"查看全部";
    CGFloat moreBtnH = 0;
    if (_menuListModel.shouldShowMoreButton) { // 如果文字高度超过60
        moreBtnH = moreBtnHeight;
        
        if (_menuListModel.isOpening) { // 如果需要展开
            
//          _labelMore.text = @"收起";
            [self.labelContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(11);
                make.left.equalTo(weakSelf.contentView).offset(15);
                make.right.equalTo(weakSelf.contentView).offset(-15);
                make.bottom.equalTo(weakSelf.labelMore.mas_top).offset(-11);
            }];
        } else {
//          _labelMore.text = @"查看全部";
            [_labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(maxContentLabelHeight);
                
            }];
        }
    }
    
//  删除按钮
//  self.labelDelete.text   = @"删除";
    CGFloat delBtnH = 0;
    
    //更新“查看详情”和“删除按钮”的约束
    [_labelMore mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moreBtnH);
    }];
    
    [_labelDelete mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(delBtnH);
        
        if (moreBtnH) {
            make.left.equalTo(weakSelf.labelMore.mas_right).offset(10);
            make.centerY.equalTo(weakSelf.labelMore.mas_centerY);
        }else{
            make.left.equalTo(weakSelf.labelMore.mas_right).offset(-80);
            make.centerY.equalTo(weakSelf.labelMore.mas_centerY).offset(11);
        }
    }];
    
    CGFloat picTop = 0;
    if (moreBtnH) {
        picTop = 10;
    }else if(delBtnH && !moreBtnH){
        picTop = 30;
    }else{
        picTop = 0;
    }
    
    if ([_menuListModel.sort isEqualToString:@"2"]) {
        
        self.picContainerView.hidden = YES;
        self.backImageView.hidden = NO;
        self.playBtn.hidden = NO;
        
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.menuListModel.voideImg] placeholderImage:[UIImage imageNamed:@"vidioBackImage"]];
        
        [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.labelMore.mas_bottom).offset(0);
            make.height.mas_equalTo(200);
        }];
        
        [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(weakSelf.backImageView);
            make.width.height.mas_equalTo(64);
        }];
        
        [_viewBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backImageView.mas_bottom).offset(15).priorityLow();
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(34);
        }];
    }else{
        
        self.backImageView.hidden = YES;
        self.picContainerView.hidden = NO;
        self.playBtn.hidden = YES;
        [self.picContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.labelMore.mas_bottom).offset(picTop);
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.height.mas_equalTo(0);
            make.right.mas_greaterThanOrEqualTo(weakSelf.contentView).offset(-15);
        }];
        [self.picContainerView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
        [self.picContainerView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];

        NSArray *picViews =[_menuListModel.imgs componentsSeparatedByString:@"|"];
        NSMutableArray *oriPArr = [NSMutableArray new];
        for (NSString *pName in picViews) {
        
            [oriPArr addObject:[NSURL URLWithString:pName]];
        }
        
        CGFloat viewBottomTop = 0;
        if(picViews.count){
            viewBottomTop = 15;
        }
        
        [_viewBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.picContainerView.mas_bottom).offset(viewBottomTop).priorityLow();
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(34);
        }];
        
        self.picContainerView.picUrlArray = picViews;
    }
    
    _viewBottom.btnLike.selected = _menuListModel.isLike? YES: NO;
    [_viewBottom.btnComment setTitle:[NSString stringWithFormat:@"%d",_menuListModel.comment_count] forState:UIControlStateNormal];//评论数
    [_viewBottom.btnLike setTitle:[NSString stringWithFormat:@"%d",_menuListModel.collect_count] forState:UIControlStateNormal];//收藏数
    [_viewBottom.btnShare setTitle:[NSString stringWithFormat:@"%d",_menuListModel.transmit_count]  forState:UIControlStateNormal];//分享数
}

- (void)playBtnClick1:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

#pragma mark - Action
-(void)onMoreTap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onMoreInCell:)]) {
        [_delegate onMoreInCell:self];
    }
}

- (void)deleteTap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onDeleteInCell:)]) {
        [_delegate onDeleteInCell:self];
    }
}

#pragma mark - Gesture
- (void)onAvatar:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onAvatarInCell:)]) {
            [_delegate onAvatarInCell:self];
        }
    }
}

-(void)onIMageArrow:(UITapGestureRecognizer *)recognizer{

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(onPulldownInCell:)]) {
            [_delegate onPulldownInCell:self];
        }
    }
}

#pragma mark - HKPBotViewDelegate
- (void)onAvatar{
    
}

- (void)onMore{
    
}

- (void)onComment{
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentInCell:)]) {
        [_delegate onCommentInCell:self];
    }
}

- (void)onLike{
    if (_delegate && [_delegate respondsToSelector:@selector(onLikeInCell:)]) {
        [_delegate onLikeInCell:self];
    }
}

- (void)onShare{
    if (_delegate && [_delegate respondsToSelector:@selector(onShareInCell:)]) {
        [_delegate onShareInCell:self];
    }
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
