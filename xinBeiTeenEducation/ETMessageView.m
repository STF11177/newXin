//
//  PopupView.m
//  ZhiYuan
//
//  Created by Omiyang on 13-6-15.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import "ETMessageView.h"
#import "YYKit.h"

@implementation ETMessageView
@synthesize backView = _backView;
@synthesize spinner = _spinner;
@synthesize messageLabel = _messageLabel;
@synthesize timer = _timer;


//单例定位模型
+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static ETMessageView *sharedInstance = nil;
    dispatch_once(&pred, ^{
        CGRect rect = CGRectMake((320-ET_MESSVIEW_WIDTH)/2, kScreenHeight*.4, ET_MESSVIEW_WIDTH, ET_MESSVIEW_HEIGHT);
        sharedInstance = [[ETMessageView alloc] initWithFrame:rect];
        [sharedInstance addSubview:sharedInstance.backView];
        sharedInstance.messageLabel.frame = CGRectMake(40, 10, ET_MESSVIEW_WIDTH - 40 -10, 20);
        [sharedInstance addSubview:sharedInstance.messageLabel];
    });
    return sharedInstance;
}


- (UIView *)backView {
    if (_backView == nil) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [UIColor grayColor];
        _backView.layer.masksToBounds = YES;
        _backView.alpha = 0.8;
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}

- (UIActivityIndicatorView *)spinner {
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    }
    return _spinner;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = kFontSize(14);
    }
    return _messageLabel;
}

- (void)cancelHiddenDuration {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)showMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [self showMessage:mess onView:window];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
}

- (void)showMessage:(NSString *)mess onView:(UIView *)view{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    [self cancelHiddenDuration];
    
    CGSize showSize,textSize;
    if (_spinner) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }
    showSize = CGSizeMake(ET_MESSVIEW_WIDTH_MAX-20, 1000);
    
    
    textSize = [mess safelySizeWithFont:self.messageLabel.font constrainedToSize:showSize];
    
    if (textSize.width>ET_MESSVIEW_WIDTH) {
        
        [self setSize:CGSizeMake(textSize.width+20, ET_MESSVIEW_HEIGHT)];
    }
    
    if(sataus==UIInterfaceOrientationPortrait){
        [self setTop:kScreenHeight*0.4];
        [self setCenterX:kScreenWidth*.5];
    }else{
        [self setTop:kScreenWidth*0.4];
        [self setCenterX:kScreenHeight*.5];
    }
    
    self.messageLabel.numberOfLines = textSize.height/self.messageLabel.font.lineHeight;
    [self.messageLabel setSize:textSize];
    self.messageLabel.text = mess;
    
    if (self.messageLabel.width < showSize.width) {
        [self.messageLabel setCenterX:self.width/2];
        [self.backView setSize:self.frame.size];
    }
    
    if (self.messageLabel.height > ET_MESSVIEW_HEIGHT-20) {
        self.height = self.messageLabel.height + 20;
        [self.backView setSize:self.frame.size];
    }
    [self.messageLabel setCenterY:self.height/2];
    
    self.hidden = NO;
    if (self.superview == nil) {
        [view addSubview:self];
    }

}

#pragma mark - **********Spinner************
- (void)showSpinnerMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration{
   
    [self showSpinnerMessage:mess onView:view];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
}

- (void)showSpinnerMessage:(NSString *)mess onView:(UIView *)view{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;

    [self cancelHiddenDuration];
    CGSize showSize,textSize;
    showSize = CGSizeMake(ET_MESSVIEW_WIDTH_MAX-50, 1000);
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
    
    textSize = [mess safelySizeWithFont:self.messageLabel.font constrainedToSize:showSize];
    if (textSize.width>ET_MESSVIEW_WIDTH) {
        [self setSize:CGSizeMake(textSize.width, 100)];
    }
    
    if(sataus==UIInterfaceOrientationPortrait){
        [self setTop:kScreenHeight*0.4];
        [self setCenterX:kScreenWidth*.5];
    }else{
        [self setTop:kScreenWidth*0.4];
        [self setCenterX:kScreenHeight*.5];
    }
    
    self.messageLabel.numberOfLines = textSize.height/self.messageLabel.font.lineHeight;
    [self.messageLabel setSize:textSize];
    self.messageLabel.text = mess;
    
    if (self.messageLabel.width < showSize.width) {
        
        [self.spinner setCenterY:self.height/2 + 10];
        [self.messageLabel setCenterY:self.spinner.centerY + 20];
//      [self.messageLabel setCenterX:self.messageLabel.center.x+10];
//      [self.spinner setCenterX:self.messageLabel.left-20];
        [self.backView setSize:CGSizeMake( self.frame.size.width, 100)];
    }
    
    if (self.messageLabel.height > ET_MESSVIEW_HEIGHT-20) {
        self.height = self.messageLabel.height + 20;
        [self.backView setSize:CGSizeMake( self.frame.size.width, 100)];

    }
    
    [self.messageLabel setCenterX:self.width/2];
    [self.spinner setCenterX:self.width/2];
    
    self.hidden = NO;
    
    if (self.superview == nil) {
        [view addSubview:self];
    }
}

- (void)showTransverseMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration{
    
    [self showTransverseMessage:mess onView:view];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
}

- (void)showTransverseMessage:(NSString *)mess onView:(UIView *)view{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;

    [self cancelHiddenDuration];
    CGSize showSize,textSize;
    showSize = CGSizeMake(ET_MESSVIEW_WIDTH_MAX-50, 1000);
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
    
    textSize = [mess safelySizeWithFont:self.messageLabel.font constrainedToSize:showSize];
    if (textSize.width>ET_MESSVIEW_WIDTH) {
        [self setSize:CGSizeMake(textSize.width+50, ET_MESSVIEW_HEIGHT)];
    }
    
    if(sataus==UIInterfaceOrientationPortrait){
        [self setCenterX:kScreenWidth*.5];
    }else{
        [self setCenterX:kScreenHeight*.5];
    }
    self.messageLabel.numberOfLines = textSize.height/self.messageLabel.font.lineHeight;
    [self.messageLabel setSize:textSize];
    self.messageLabel.text = mess;
    
    if (self.messageLabel.width < showSize.width) {
        [self.messageLabel setCenterX:self.width/2];
        [self.messageLabel setCenterX:self.messageLabel.center.x+10];
        [self.spinner setCenterX:self.messageLabel.left-20];
        [self.backView setSize:self.frame.size];
    }
    
    if (self.messageLabel.height > ET_MESSVIEW_HEIGHT-20) {
        self.height = self.messageLabel.height + 20;
        [self.backView setSize:self.frame.size];
    }
    
    [self.messageLabel setCenterY:self.height/2];
    [self.spinner setCenterY:self.messageLabel.center.y];
    if(sataus==UIInterfaceOrientationPortrait){
        [self setCenterY:kScreenWidth*0.5];
    }else{
        [self setCenterY:kScreenHeight*0.5];
    }
    
    self.hidden = NO;
    
    if (self.superview == nil) {
        [view addSubview:self];
    }
}

- (void)hideMessage {
    [self removeFromSuperview];
    if (_spinner) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }
    self.hidden = YES;
}
@end
