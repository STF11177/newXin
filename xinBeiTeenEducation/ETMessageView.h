//
//  PopupView.h
//  ZhiYuan
//
//  Created by Omiyang on 13-6-15.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define ET_MESSVIEW_WIDTH 160
#define ET_MESSVIEW_WIDTH_MAX 240
#define ET_MESSVIEW_HEIGHT 44
@interface ETMessageView : UIView

@property (retain, nonatomic) UIView *backView;
@property (retain, nonatomic) UIActivityIndicatorView *spinner;
@property (retain, nonatomic) UILabel *messageLabel;
@property (retain, nonatomic) NSTimer *timer;

+ (id)sharedInstance;

- (void)showTransverseMessage:(NSString *)mess onView:(UIView *)view;
- (void)showTransverseMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration;

- (void)showMessage:(NSString *)mess onView:(UIView *)view;
- (void)showSpinnerMessage:(NSString *)mess onView:(UIView *)view;
- (void)showMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration;
- (void)showSpinnerMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration;
- (void)hideMessage;
@end
