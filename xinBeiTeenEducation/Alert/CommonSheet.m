//
//  ActionSheet.m
//  XingPin
//
//  Created by Enjoytouch on 14-11-28.
//  Copyright (c) 2014年 EnjoyTouch. All rights reserved.
//

#import "CommonSheet.h"
#import "YYKit.h"

#define ItemTop self.messageView.height*0.5-ItemWidth*0.5
#define ItemWidth kScreenWidth*0.2
#define ItemNumber 4

@implementation CommonSheet

static NSString *subject_id;
static NSString *typeName;
static NSString *countStr;

- (id)initWithDelegate:(id)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}
/**
 自定义界面
 */
- (void)setupSubView{
    
    /****************Mark层******************/
    self.markView = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) BackgroundColor:MarkBackColor];
    self.markView.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureAction)];
    [self.markView addGestureRecognizer:tapGesture];
    [self addSubview:self.markView];
    
    /***********提示view中的控件**********/
    [self setMessageView:[BlurView new]];
    [[self messageView] setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.45)];
    self.messageView.blurTintColor = [UIColor whiteColor];
    [self addSubview:[self messageView]];
    
    //    CGFloat titleTop = (self.messageView.height - ItemWidth)/2;
    
    //    UILabel *title = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0, 0, kScreenWidth, titleTop-25) Font:[UIFont systemFontOfSize:15] Text:@"选择科目"];
    //    title.textColor = TextColor;
    //    title.textAlignment = NSTextAlignmentLeft;
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 25)];
    titleLb.text = @"选择科目";
    titleLb.textColor = TextColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    [self.messageView addSubview:titleLb];
    
    self.priceLb = [[UILabel alloc]initWithFrame:CGRectMake( 100 +10, 15, 70, 25)];
    self.priceLb.textColor = [UIColor colorWithHexString:@"#ff6600"];
    self.priceLb.textAlignment = NSTextAlignmentLeft;
    [self.messageView addSubview:self.priceLb];
    
    CGFloat olderWith = 0;//保存前一个button的宽及前一个button距离屏幕边缘的距离
    CGFloat height = 64;//用来控制button的距离父视图的高
    
    
    for (int i = 0; i< self.dataArray.count; i++) {
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.categoryBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self.categoryBtn addTarget:self action:@selector(categoryClick1:) forControlEvents:UIControlEventTouchUpInside];
        self.categoryBtn.tag = 101 + i;
        
        self.categoryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.categoryBtn setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [self.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.categoryBtn.layer.cornerRadius = 5;
        
        //计算文字的大小
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [self.dataArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size.width;
        self.categoryBtn.frame = CGRectMake(10 + olderWith, height, length + 30, 30);
        
        //当button的位置超出屏幕边缘时换行，SCREEN_WIDTH只是button所在父视图的宽度
        if ( 10 + olderWith +length +30 >SCREEN_WIDTH) {
            olderWith = 0;//换行时将olderWith置为0
            height = height +self.categoryBtn.frame.size.height +10;
            self.categoryBtn.frame = CGRectMake( 10 +olderWith, height, length +20, 30);//重设button的frame
            
            self.Messageheight = height + 64;
        }
        
        olderWith = self.categoryBtn.frame.size.width + self.categoryBtn.frame.origin.x;
        [self.messageView addSubview:self.categoryBtn];
    }
    
    
    //确定
    UIButton *cancel = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, self.messageView.height - 45, kScreenWidth, 45) title:@"确定" titleColor:[UIColor whiteColor] Target:self Action:@selector(selelctBtn:)];
    cancel.backgroundColor = [UIColor orangeColor];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    cancel.tag = 100;
    
    UIView *line =[ETUIUtil drawViewWithFrame:CGRectMake(0, cancel.top, kScreenWidth, 1) BackgroundColor:GrayColor];
    [self.messageView addSubview:line];
}

- (void)setupWithShare{
    /****************Mark层******************/
    self.markView = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) BackgroundColor:MarkBackColor];
    self.markView.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self.markView addGestureRecognizer:tapGesture];
    [self addSubview:self.markView];
    
    /***********提示view中的控件**********/
    [self setMessageView:[BlurView new]];
    [[self messageView] setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.35)];
    [self addSubview:[self messageView]];
    
    CGFloat titleTop = (self.messageView.height - 50)/2;
    CGFloat itemSpace =  (kScreenWidth-200)/5;
    
    UILabel *title = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0, 0, kScreenWidth, titleTop-25) Font:[UIFont systemFontOfSize:15] Text:@"分享一下"];
    title.textColor = TextColor;
    title.textAlignment = NSTextAlignmentCenter;
    
    //微博
    [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(itemSpace, titleTop-25, 50, 50) IconName:@"login_weibo.png" Target:self Action:@selector(shareAction:) Tag:1];
    UILabel *xinlang =[ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(itemSpace, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"新浪"];
    xinlang.textColor = TextColor;
    xinlang.textAlignment = NSTextAlignmentCenter;
    
    //微信
    [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(itemSpace*2+50, titleTop-25, 50, 50) IconName:@"login_wechat.png" Target:self Action:@selector(shareAction:) Tag:2];
    UILabel *weixin = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(itemSpace*2+50, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"微信"];
    weixin.textColor = TextColor;
    weixin.textAlignment = NSTextAlignmentCenter;
    
    
    //微信朋友圈
    [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(itemSpace*3+100, titleTop-25, 50, 50) IconName:@"login_line.png" Target:self Action:@selector(shareAction:) Tag:3];
    UILabel *weixinTime = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(itemSpace*3+100, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"朋友圈"];
    weixinTime.textColor = TextColor;
    weixinTime.textAlignment = NSTextAlignmentCenter;
    
    
    //QQ
    [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(itemSpace*4+150, titleTop-25, 50, 50) IconName:@"login_qq.png" Target:self Action:@selector(shareAction:) Tag:4];
    UILabel *qq = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(itemSpace*4+150, titleTop+25, 50, 30) Font:[UIFont systemFontOfSize:12] Text:@"QQ"];
    qq.textColor = TextColor;
    qq.textAlignment = NSTextAlignmentCenter;
    

    //取消
    UIButton *cancel = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, self.messageView.height - 45, kScreenWidth, 45) title:@"取消" titleColor:TextColor Target:self Action:@selector(shareAction:)];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    cancel.tag = 5;
    
     UIView *line =[ETUIUtil drawViewWithFrame:CGRectMake(0, cancel.top, kScreenWidth, 1) BackgroundColor:GrayColor];
    [self.messageView addSubview:line];
}

-(void)categoryClick1:(UIButton *)btn{
    
    DDLog(@"%@",self.subjectCount);
    
    if (btn != self.categoryBtn) {
        
        self.categoryBtn.selected = NO;
        self.categoryBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        self.categoryBtn = btn;
    }
    self.categoryBtn.selected = YES;
    self.categoryBtn.backgroundColor = [UIColor orangeColor];
    
    for (int i = 0 ; i< self.dataArray.count; i++) {
        
        
        typeName = self.dataArray[i];
        if ([btn.titleLabel.text isEqualToString:typeName]) {
            
            subject_id = self.categoryId[i];            
            self.priceLb.text = [NSString stringWithFormat:@"¥%@",self.subject_money[i]];
            countStr = self.subjectCount[i];
        }
    }
}

-(void)showTestInView:(UIView *)view{
    [view addSubview:self];
    
    self.markView.alpha = 1.0;
    self.markView.height = kScreenHeight - self.messageView.height;
    self.messageView.top = kScreenHeight - self.messageView.height;
}

-(void)selelctBtn:(NSString *)button{
    
    [self removeFromSuperview];
    if (self.delegate) {
        
        [self.delegate selectSubjectCount:countStr];
        [self.delegate selectChaining:subject_id];
        
        subject_id = nil;
        countStr = nil;
    }
}


-(void)shareAction:(UIButton *)button{
    
    if (button.tag == 5) {
        [self cancelAction];
    }else{
        
        [self removeFromSuperview];
        [self performSelector:@selector(ShareChaining:) onTarget:self.delegate withObject:button];
    }
}


- (void)setupWithTitles:(NSArray *)titles{
    /******************判断无标题***************/
    CGFloat MainH =0;
    self.sheets = [NSMutableArray arrayWithArray:titles];
    if ([ETRegularUtil isEmptyString:titles[0]]) {
        [self.sheets removeObjectAtIndex:0];
        MainH= ([self.sheets count]+1)*kFitHeight(95)+8;

    }else{
        MainH= [self.sheets count]*kFitHeight(95)+kFitHeight(100)+8;
    }
    /****************Mark层******************/
    self.markView = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) BackgroundColor:MarkBackColor];
    self.markView.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self.markView addGestureRecognizer:tapGesture];
    [self addSubview:self.markView];
    
    /***********提示view中的控件**********/
    [self setMessageView:[BlurView new]];
    [[self messageView] setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, MainH)];
    [self addSubview:[self messageView]];
    
    CGFloat messH = 0;
    for (int i = 0; i<[self.sheets count]; i++) {
        
        if (i==0&&![ETRegularUtil isEmptyString:titles[0]]) {
            UILabel *title = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0, 0, self.messageView.width, kFitHeight(100)) Font:kFont22Size Text:self.sheets[0] Color:[UIColor blackColor]];
            [title setNumberOfLines:0];
            [title setTextAlignment:NSTextAlignmentCenter];
            [ETUIUtil drawCustomImgViewInView:self.messageView Frame:CGRectMake(0, 0, self.messageView.width, kFitHeight(100)) BundleImgName:@"common_sheet_normal.png"];
            messH = kFitHeight(100);
        }else{
            
            CGFloat margin = i*kFitHeight(95);
            if (messH>0) {
                margin = (i-1)*kFitHeight(95)+ messH;
            }
            
            //分割线
            UIView *line = [ETUIUtil drawViewWithFrame:CGRectMake(0, margin, self.messageView.width, .5) BackgroundColor:[UIColor lightGrayColor]];
            [self.messageView addSubview:line];
            //sheetBt
            UIButton *sheetBt = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, margin+0.5, self.messageView.width, kFitHeight(95)) title:self.sheets[i] titleColor:[UIColor blackColor] Target:self Action:@selector(sheetBtClickedAction:)];
            
            //有提示信息则tag退1
            if (messH>0) {
                sheetBt.tag = i-1;
            }else{
                sheetBt.tag = i;
            }
            [sheetBt setBackgroundImage:[UIImage imageBundleNamed:@"common_sheet_normal.png"] forState:UIControlStateNormal];
            [sheetBt setBackgroundImage:[UIImage imageBundleNamed:@"common_sheet_highlight.png"] forState:UIControlStateHighlighted];
            [sheetBt.titleLabel setFont:[UIFont systemFontOfSize:17]];
            if (_itemColor) {
                [sheetBt setTitleColor:_itemColor forState:UIControlStateNormal];
            }
        }
    }
    UIView *lastLine = [ETUIUtil drawViewWithFrame:CGRectMake(0, MainH-kFitHeight(95)-8, self.messageView.width, 8) BackgroundColor:[UIColor colorWithHex:0x000000 alpha:.1]];
    [self.messageView addSubview:lastLine];
    
    /********************取消控件*********************/
    self.cancelBtn = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, MainH-kFitHeight(95), kScreenWidth, kFitHeight(95)) title:@"取消" titleColor:BlackColor Target:self Action:@selector(cancelAction)];
    [self.cancelBtn setBackgroundImage:[UIImage imageBundleNamed:@"common_sheet_normal.png"] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageBundleNamed:@"common_sheet_highlight.png"] forState:UIControlStateHighlighted];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    /***********************************************/
}

#pragma mark - Private
- (UIWindow *)statusBarWindow {
    return [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
}
- (UIInterfaceOrientation)appInterface {
    return [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - Public
- (void)show{
    UIWindow *statusBarWindow = [self statusBarWindow];
    [statusBarWindow addSubview:self];
    [self addSubview:self.maskView];
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 1.0;
        self.markView.height = kScreenHeight - self.messageView.height;
        self.messageView.top = kScreenHeight - self.messageView.height;
    }];
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 1.0;
        self.markView.height = kScreenHeight - self.messageView.height;
        self.messageView.top = kScreenHeight - self.messageView.height;
    }];
}

- (void)cancelAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commonSheetClickedIndex:SheetTag:)]) {
        [self.delegate commonSheetClickedIndex:[NSNumber numberWithInteger:1000]  SheetTag:[NSNumber numberWithInteger:self.sheetTag]];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0.0;
        self.markView.height = kScreenHeight;
        self.messageView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)sureAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commonSheetClickedIndex:SheetTag:)]) {
        [self.delegate commonSheetClickedIndex:[NSNumber numberWithInteger:1000]  SheetTag:[NSNumber numberWithInteger:self.sheetTag]];
    }
    [UIView animateWithDuration:0.0 animations:^{
        self.markView.alpha = 0.0;
        self.markView.height = kScreenHeight;
        self.messageView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sheetBtClickedAction:(UIButton *)sender{
    
    [self removeFromSuperview];
    self.markView.alpha = 0.0;
    self.markView.height = kScreenHeight;
    self.messageView.top = kScreenHeight;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commonSheetClickedIndex:SheetTag:)]) {
        [self.delegate commonSheetClickedIndex:[NSNumber numberWithInteger:sender.tag]  SheetTag:[NSNumber numberWithInteger:self.sheetTag]];
    }
}

- (void)dealloc{
    [_messageView removeAllSubviews];
    _messageView = nil;
    [_messageView removeFromSuperview];
}

@end
