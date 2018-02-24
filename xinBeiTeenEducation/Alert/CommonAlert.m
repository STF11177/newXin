//
//  CommonAlert.m
//  Carcool
//
//  Created by yizheming on 15/11/23.
//  Copyright © 2015年 EnjoyTouch. All rights reserved.
//

#import "CommonAlert.h"
#define AlertH  CGRectGetHeight(CGRectMake(0, 0, 250, 45))
#define AlertW  CGRectGetWidth(CGRectMake(0, 0, 250, 45))
#define Color05 [UIColor colorWithHex:0xea852a alpha:1]
#define Color18 [UIColor colorWithHex:0x1C1C1C alpha:0.8]

typedef enum : NSUInteger {
    ModifyPassword = 11
} CommonAlertType;

@interface CommonAlert ()

//@property (nonatomic,strong) PersonData *anchorData;

@end

@implementation CommonAlert{
    NSArray *_titleArr;
    UIView *panel;
    UILabel *mess;
    UIImageView *lineImgV;
    CommonAlertType _type;
}

//修改昵称
- (id)initWithBtnTitles:(NSArray *)titles{
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:MarkBackColor];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:MainColor];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        //3.标题及内容
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, AlertW-30, 10)];
        name.text = @"请输入验证码";
        name.left = (panel.width - name.width)*0.5;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        name.textColor = [UIColor blackColor];
        [panel addSubview:name];
        
        self.textField = [ETUIUtil drawTextFieldInView:panel Frame:CGRectMake(15, 45, AlertW *0.9, AlertH-15)  Font:[UIFont systemFontOfSize:15] Pholder:nil Color:BlackColor];
        
        [self.textField.layer setMasksToBounds:YES];
        self.textField.layer.borderWidth = 1;
        [self.textField.layer setCornerRadius:5];
        self.textField.layer.borderColor = GrayColor.CGColor;
        [self setup:nil];
        
        self.line = [ETUIUtil drawViewWithFrame:CGRectMake(self.textField.left, self.textField.bottom, AlertW-30, 1) BackgroundColor:[UIColor colorWithHexString:@"#45b7ff"]];
        self.line.hidden = YES;
        [panel addSubview:self.line];
    }
    
    return self;
}




//修改信息
- (id)initWithModifiedInforWithBtnTitles:(NSArray *)titles andWithmessage:(NSString *)message{
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:MarkBackColor];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:MainColor];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        //3.标题及内容
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, AlertW-30, 10)];
        name.text = message;
        name.left = (panel.width - name.width)*0.5;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        name.textColor = COLOR_7a8fc1;
        [panel addSubview:name];
        
        
        self.textField = [ETUIUtil drawTextFieldInView:panel Frame:CGRectMake(15, 45, AlertW *0.9, AlertH-15)  Font:[UIFont systemFontOfSize:15] Pholder:nil Color:BlackColor];
        [self.textField.layer setMasksToBounds:YES];
        self.textField.layer.borderWidth = 1;
        [self.textField.layer setCornerRadius:5];
        self.textField.layer.borderColor = GrayColor.CGColor;
        [self setup:nil];
    }
    
    return self;
}

//填写体重
- (id)initWithWriteWeightWithBtnTitles:(NSArray *)titles{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:MarkBackColor];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:MainColor];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        //3.标题及内容
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, AlertW *0.9, 10)];
        name.text = @"体重值影响到消耗卡路里的准确值,请真实填写";
        name.left = (panel.width - name.width)*0.5;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        name.textColor = COLOR_7a8fc1;
        [panel addSubview:name];
        
        
        self.textField = [ETUIUtil drawTextFieldInView:panel Frame:CGRectMake(0, 45, AlertW *0.25, AlertH-20)  Font:[UIFont systemFontOfSize:15] Pholder:nil Color:BlackColor];
        self.textField.left = (panel.width - self.textField.width)*0.5;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.font = kFontSize(15);
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        UIView *line = [ETUIUtil drawViewWithFrame:CGRectMake(self.textField.left, self.textField.bottom, self.textField.width, 1) BackgroundColor:COLOR_2FDBD7];
        [panel addSubview:line];
        UILabel *kg = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(self.textField.right, self.textField.top, AlertW *0.2, self.textField.height* 0.6) Font:kFontSize(12) Text:@"kg"];
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        kg.bottom = line.top;
        kg.textColor = COLOR_2FDBD7;
        [self setup:nil];
    }
    
    return self;
}

- (id)initWithMessage:(NSString *)message withBtnTitles:(NSArray *)titles{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if(sataus==UIInterfaceOrientationPortrait){
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }else{
        self = [super initWithFrame:CGRectMake(0, 0,kScreenHeight, kScreenWidth)];
    }
    if (self) {
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:MarkBackColor];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:MainColor];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        
        //3.标题及内容
        mess = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(15, 0, AlertW *0.9, AlertH) Font:[UIFont systemFontOfSize:16] Text:message Color:[UIColor blackColor]];
        mess.numberOfLines = 0;
        
        [self setup:@"22"];
    }
    return self;
}

- (id)initWithSendMessage:(NSString *)message Titles:(NSArray *)titles{
    
    if (self) {
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:MarkBackColor];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:MainColor];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        //3.标题及内容
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(kFitWidth(15), kFitHeight(25), AlertW-kFitWidth(30), kFitHeight(40))];
        name.text = message;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = kFont30Size;
        name.textColor = Color18;
        [panel addSubview:name];
        
        self.textField = [ETUIUtil drawTextFieldInView:panel Frame:CGRectMake(kFitWidth(15), name.bottom+kFitHeight(10),name.width, AlertH-kFitHeight(10))  Font:[UIFont systemFontOfSize:15] Pholder:nil Color:BlackColor];
        [self.textField.layer setMasksToBounds:YES];
        self.textField.layer.borderWidth = 1;
        [self.textField.layer setCornerRadius:5];
        self.textField.layer.borderColor = GrayColor.CGColor;
        [self setup:nil];
    }
    
    return self;
}
//设置---修改密码
- (id)initWithTitle:(NSString *)title Message:(NSString *)message withBtnTitles:(NSArray *)titles {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:MarkBackColor];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:MainColor];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        //3.标题及内容
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(kFitWidth(15), kFitHeight(25), AlertW-kFitWidth(30), kFitHeight(40))];
        name.text = title;
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        name.textColor = COLOR_7a8fc1;
        name.numberOfLines = 0;
        [panel addSubview:name];
        
        mess = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(15, 0, AlertW *0.9, AlertH) Font:[UIFont fontWithName:@"Helvetica-Bold" size:15] Text:message Color:COLOR_7a8fc1];
        mess.numberOfLines = 0;
        
        self.textField = [ETUIUtil drawTextFieldInView:panel Frame:CGRectMake(kFitWidth(30), mess.bottom+kFitHeight(10),AlertW-kFitWidth(30*2), AlertH-kFitHeight(10))  Font:[UIFont systemFontOfSize:15] Pholder:nil Color:BlackColor];
        
        lineImgV = [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(self.textField.left, self.textField.bottom-5, self.textField.width, 1) ImgName:@"settings_modify_line.png"];
        
        [self setup:@"settings_modify"];
        
        _type = ModifyPassword;
    }
    
    return self;
}

//- (void)setupSubView:(PersonData *)data{
//    
//    _anchorData = data;
//    //线
//    [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(0, panel.height-3, panel.width, 3) ImgName:@"play_line_bottom.png"];
//    //头像边框
//    UIImageView *snapFrame = [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(kScreenHeight*40/2209,kScreenWidth*20/1242,kScreenWidth*235/1242,kScreenWidth*235/1242) ImgName:@"login_snap_out.png"];
//    snapFrame.userInteractionEnabled = YES;
//    //头像
//    UIImageView *snap = [ETUIUtil drawCustomImgViewInView:snapFrame Frame:CGRectMake(0, 0,snapFrame.width*0.7, snapFrame.width*0.7) ImgName:data.snap];
//    snap.top = snapFrame.height*0.5-snap.height*0.5;
//    snap.left = snapFrame.width*0.5-snap.width*0.5;
//    if (![ETRegularUtil isEmptyString:data.snap]) {
//        [snap setImageWithURL:[NSURL URLWithString:data.snap] placeholder:[UIImage imageBundleNamed:@"ride_snap_default.png"]];
//    }else{
//        snap.image = [UIImage imageBundleNamed:@"ride_snap_default.png"];
//    }
//    snap.clipsToBounds = YES;
//    snap.layer.cornerRadius = snap.height*0.5;
//    snap.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [self hiddenView];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSnapImageAnchorId:)]) {
//            [self.delegate selectedSnapImageAnchorId:_anchorData.Id];
//        }
//    }];
//    [snap addGestureRecognizer:tap];
//    
//    //名字
//    UILabel *name = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(snapFrame.right+(kScreenHeight*30/2209), kScreenWidth*50/1242,panel.width*0.25,kScreenHeight*70/2209) Font:kBoldFitSize(13) Text:data.nickName Color:COLOR_HEX(0x798fc0)];
//    if (![ETRegularUtil isEmptyString:data.nickName]) {
//        name.text = data.nickName;
//    }else{
//        name.text = @"";
//    }
//    
//    //财富等级
//    UIImageView *wealth = [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(name.left, name.bottom+kScreenWidth*40/1242, 0, kScreenWidth*55/1242) ImgName:data.wealthLevel];
//    wealth.width = wealth.height*100/51;
//    if (![ETRegularUtil isEmptyString:data.wealthLevel]) {
//        [wealth setImageWithURL:[NSURL URLWithString:data.wealthLevel] placeholder:[UIImage imageBundleNamed:@"my_gray1.png"]];
//    }else{
//        wealth.image = [UIImage imageBundleNamed:@"my_gray1.png"];
//    }
//    //运动等级
//    UIImageView *sport = [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(0, 0, 0, wealth.height) ImgName:@"play_line_bottom.png"];
//    sport.width = sport.height*150/61;
//    sport.left = wealth.right+5;
//    sport.centerY = wealth.centerY;
//    if (![ETRegularUtil isEmptyString:data.sportLevel]) {
//        [sport setImageWithURL:[NSURL URLWithString:data.sportLevel] placeholder:[UIImage imageBundleNamed:@"my_gray2.png"]];
//    }else{
//        sport.image = [UIImage imageBundleNamed:@"my_gray2.png"];
//    }
//    //主播等级
//    UIImageView *anchor = [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(0, panel.height-3, panel.width, sport.height) ImgName:data.anchorLevel];
//    anchor.width = anchor.height*134/60;
//    anchor.left = sport.right+5;
//    anchor.centerY = wealth.centerY;
//    if (![ETRegularUtil isEmptyString:data.anchorLevel]) {
//        [anchor setImageWithURL:[NSURL URLWithString:data.anchorLevel] placeholder:[UIImage imageBundleNamed:@"my_gray3.png"]];
//    }else{
//        anchor.image = [UIImage imageBundleNamed:@"my_gray3.png"];
//    }
//    
//    //主播标识
//    UIImageView *anchorIcon = [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(name.right+(kScreenHeight*40/2209), 0,0, kScreenHeight*70/2209) ImgName:@"chat_shenfen2.png"];
//    anchorIcon.width = anchorIcon.height*43/38;
//    anchorIcon.centerY = name.centerY;
//    //认证主播
//    UILabel *anchorName = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(anchorIcon.right+5, 0,0, kScreenHeight*70/2209) Font:kBoldFitSize(13) Text:@"认证主播" Color:COLOR_HEX(0xf553ff)];
//    anchorName.centerY = name.centerY;
//    anchorName.width = [anchorName.text safelySizeWithFont:anchorName.font constrainedToSize:CGSizeMake(panel.width, anchorName.height)].width;
//    
//    //用户类型
//    if ([data.type isEqualToString:@"1"]) {
//        anchorName.text = @"普通用户";
//        anchorName.textColor = COLOR_HEX(0x12ACC4);
//        anchorIcon.image = [UIImage imageBundleNamed:@"chat_shenfen.png"];
//        anchor.hidden = YES;
//    }else if ([data.type isEqualToString:@"2"]) {
//        anchorName.text = @"认证主播";
//        anchorName.textColor = COLOR_HEX(0xf554ff);
//        anchorIcon.image = [UIImage imageBundleNamed:@"chat_shenfen2.png"];
//        anchor.hidden = NO;
//    }
//    
//    UIView *back = [ETUIUtil drawViewWithFrame:CGRectMake(0, snapFrame.bottom+kScreenWidth*20/1242,panel.width,kScreenWidth*182/1242) BackgroundColor:COLOR_HEX(0xe5f8ff)];
//    [panel addSubview:back];
//    
//    NSArray *item = @[@"收到悦票",@"消费星钻",@"关注",@"粉丝"];
//    //数据
//    NSMutableArray *itemData = [NSMutableArray arrayWithObjects:data.anchorPoints,data.consumption,data.followNumber,data.fansNumber, nil];
//    
//    CGFloat x = kScreenHeight*40/2209;
//    //去除左右边距4分之一
//    CGFloat width = (panel.width-(kScreenHeight*40/2209)*2)/4;
//    NSInteger i = 0;
//    
//    for (NSString *title in item) {
//        
//        UILabel *item = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(x, back.top+kScreenWidth*20/1242,width,kScreenWidth*65/1242) Font:kBoldFitSize(12) Text:title Color:COLOR_HEX(0x798fc0)];
//        item.textAlignment = NSTextAlignmentCenter;
//        
//        NSString *str = [itemData safelyObjectAtIndex:i];
//        if ([ETRegularUtil isEmptyString:str]) {
//            str = @"0";
//        }
//        
//        UILabel *num = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(x, item.bottom+kScreenWidth*10/1242,width,kScreenWidth*50/1242) Font:kBoldFitSize(12) Text:str Color:COLOR_HEX(0x798fc0)];
//        num.textAlignment = NSTextAlignmentCenter;
//        
//        i++;
//        if (i == 1) {
//            x += width+(kScreenHeight*20/2209);
//        }else {
//            x += width;
//        }
//    }
//    
//    //关注按钮
//    UIButton *status = [ETUIUtil drawButtonInView:panel Frame:CGRectMake(0, back.bottom+kScreenWidth*30/1242, panel.width*0.75, panel.height*0.17) title:@"+关注" titleColor:[UIColor whiteColor] Target:self Action:@selector(selectedFollowStatus:)];
//    status.left = panel.width*0.5-status.width*0.5;
//    status.titleLabel.font = kBoldFitSize(15);
//    status.backgroundColor = COLOR_HEX(0x53def5);
//    status.clipsToBounds = YES;
//    status.layer.cornerRadius = 10.0;
//    if ([data.followStatus isEqualToString:@"0"]) {
//        status.enabled  = YES;
//        [status setTitle:@"+关注" forState:UIControlStateNormal];
//        
//    }else{
//        [status setTitle:@"已关注" forState:UIControlStateNormal];
//        status.enabled = NO;
//    }
//}


- (void)showInWindow{
    
    for (UIView *item in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([item isKindOfClass:[self class]]) {
            CommonAlert *sub = (CommonAlert *)item;
            sub.delegate = nil;
            [sub removeFromSuperview];
        }
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}
- (void)hiddenView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [panel removeFromSuperview];
        for (id sub in panel.subviews) {
            [sub removeFromSuperview];
        }
        panel = nil;
        [self removeFromSuperview];
    }];
}

- (void)setup:(NSString*)tag{
    
    NSInteger count = 0;
    if (_titleArr) {
        count = _titleArr.count;
        mess.height = [mess.text safelySizeWithFont:mess.font constrainedToSize:CGSizeMake(mess.width, MAXFLOAT)].height;
        mess.textAlignment = NSTextAlignmentCenter;
        panel.height = mess.height+AlertH*2;
        if ([tag isEqualToString:@"22"]) {
            panel.height = mess.height+AlertH*1.2;
        }
        
        mess.center = CGPointMake(panel.width*.5, panel.height*.5);
        
        if ([tag isEqualToString:@"settings_modify"]) {
            self.textField.top = mess.bottom + kFitHeight(10);
            lineImgV.top = self.textField.bottom;
            panel.height += kFitHeight(20);
        }
        
    }else{
        mess.height = [mess.text safelySizeWithFont:mess.font constrainedToSize:CGSizeMake(mess.width, MAXFLOAT)].height;
        mess.textAlignment = NSTextAlignmentCenter;
        panel.height = mess.height+AlertH;
        mess.center = CGPointMake(panel.width*.5, panel.height*.5);
        panel.center = CGPointMake(self.width*.5, self.height*.5);
    }
    
    switch (count) {
        case 1:
            [self oneButton];
            break;
        case 2:
            [self twoButton];
            break;
        default:{
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(chooseAction) userInfo:nil repeats:NO];
        }
            break;
    }
    [panel.layer setCornerRadius:panel.height*.1];
}

-(void)chooseAction{
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [mess removeFromSuperview];
        [panel removeFromSuperview];
        [self removeFromSuperview];
        mess = nil;
        panel = nil;
    }];
}

- (void)oneButton{
    
    UIButton *certainBtn =  [ETUIUtil drawButtonInView:panel Frame:CGRectMake(AlertW *0.1, panel.bottom, AlertW *0.8, AlertH *0.7) title:nil titleColor:MainColor Target:self Action:@selector(itemCertainAction1)];
    certainBtn.layer.cornerRadius = 8;
    certainBtn.backgroundColor = [UIColor colorWithHexString:@"#45b7ff"];
    
    UILabel *btnLabel = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(AlertW *0.1, certainBtn.top, AlertW *0.8, certainBtn.height) Font:[UIFont systemFontOfSize:18] Text:_titleArr[0] Color:MainColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    panel.height = panel.height+AlertH;
    panel.center = CGPointMake(self.width*.5, self.height*.5);
    [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(0, panel.height - 2, panel.width, 2) BundleImgName:@"login_bot.png"];
    
}

- (void)twoButton{
    //第一个按钮
    UIButton *cannelBtn =  [ETUIUtil drawButtonInView:panel Frame:CGRectMake(AlertW *0.05, panel.bottom, AlertW*.4, AlertH *0.7)  title:nil titleColor:MainColor Target:self Action:@selector(itemCancelAction)];
    cannelBtn.layer.cornerRadius = 8;
    cannelBtn.backgroundColor = [UIColor colorWithHexString:@"#45b7ff"];
    
    UILabel *cannelLabel = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(AlertW *0.05, cannelBtn.top, AlertW*.4, AlertH*0.7) Font:[UIFont systemFontOfSize:16] Text:_titleArr[0] Color:MainColor];
    cannelLabel.textAlignment = NSTextAlignmentCenter;
    
    //第二个按钮
    UIButton *certainBtn =  [ETUIUtil drawButtonInView:panel Frame:CGRectMake(AlertW*.55, cannelBtn.top, AlertW*.4, AlertH *0.7) title:nil titleColor:MainColor Target:self Action:@selector(itemCertainAction)];
    certainBtn.layer.cornerRadius = 8;
    certainBtn.backgroundColor = [UIColor colorWithHexString:@"#45b7ff"];
    
    UILabel *btnLabel = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(AlertW*.55, cannelBtn.top, AlertW*.4, AlertH *0.7) Font:[UIFont systemFontOfSize:16] Text:_titleArr[1] Color:MainColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    
    panel.height = panel.height+AlertH;
    if (self.textField) {
        panel.center = CGPointMake(self.width*.5, self.height*.3);
    }else{
        
        panel.center = CGPointMake(self.width*.5, self.height*.5);
    }
    
    [ETUIUtil drawCustomImgViewInView:panel Frame:CGRectMake(0, panel.height - 2, panel.width, 2) BundleImgName:@"login_bot.png"];
    
}

- (void)itemCancelAction{
    
    [self removeFromSuperview];
    [self performSelector:@selector(itemCancel:) onTarget:self.delegate withObject:self];
    
}

- (void)itemCertainAction{
    if (_type != ModifyPassword) {
        [self removeFromSuperview];
    }
    [self performSelector:@selector(itemCertain:) onTarget:self.delegate withObject:self];
}

- (void)itemCertainAction1{
    if (_type != ModifyPassword) {
        [self removeFromSuperview];
    }
    [self performSelector:@selector(oneButtonitemCertain:) onTarget:self.delegate withObject:self];
}

@end
