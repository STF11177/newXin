//
//  UtilUI.m
//  Anjuke
//
//  Created by zhengpeng on 11-7-18.
//  Copyright 2011年 anjuke. All rights reserved.
//

#import "ETUIUtil.h"


@implementation ETUIUtil
+ (UIButton *)drawButtonInView:(UIView *)mainView Frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color Target:(id)target Action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btn];
    return btn;
}

+ (UIButton *)drawButtonInView:(UIView *)mainView Frame:(CGRect)frame IconName:(NSString *)name Target:(id)target Action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageBundleNamed:name] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btn];
    return btn;
}

+ (UIButton *)drawButtonInView:(UIView *)mainView Frame:(CGRect)frame IconName:(NSString *)name Target:(id)target Action:(SEL)action Tag:(NSInteger)tag{
    UIButton *btn = [ETUIUtil drawButtonInView:mainView Frame:frame IconName:name Target:target Action:action];
    btn.tag = tag;
    return btn;
}
+ (UIImageView *)drawCustomImgViewInView:(UIView *)mainView Frame:(CGRect)frame BundleImgName:(NSString *)name {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageBundleNamed:name]];
    iv.frame = frame;
    [mainView addSubview:iv];
    return iv;
}

+ (UIImageView *)drawCustomImgViewInView:(UIView *)mainView Frame:(CGRect)frame ImgName:(NSString *)name {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    iv.frame = frame;
    [mainView addSubview:iv];
    return iv;
}

+ (UIImageView *)drawCustomImgViewInView:(UIView *)mainView Frame:(CGRect)frame ImgName:(NSString *)name Tag:(NSInteger)tag{
    UIImageView *iv = [ETUIUtil drawCustomImgViewInView:mainView Frame:frame ImgName:name];
    iv.tag = tag;
    return iv;
}

+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text {
    UILabel *lb = [[UILabel alloc] initWithFrame:frame] ;
    lb.backgroundColor = [UIColor clearColor];
    lb.font = font;
    lb.text = text;
    [mainView addSubview:lb];
    return lb;
}

+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text Tag:(NSInteger)tag{
    UILabel *lb = [ETUIUtil drawLabelInView:mainView Frame:frame Font:font Text:text];
    lb.tag = tag;
    return lb;
}

+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text Color:(UIColor *)color {
    UILabel *lb = [ETUIUtil drawLabelInView:mainView Frame:frame Font:font Text:text];
    lb.textColor = color;
    return lb;
}

+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text IsMutiLine:(BOOL)isMutiLine {
    CGSize lblSize = [text safelySizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 10000)];
    UILabel *lb = [ETUIUtil drawLabelInView:mainView Frame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, lblSize.height) Font:font Text:text];
    if (isMutiLine) {
        lb.numberOfLines = 0;
    }
    return lb;
}

+ (UIView *)drawViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

#pragma mark - BarItem
+ (UIButton *)createButtonWithText:(NSString *)text bgImageNormal:(UIImage *)bgImageNormal bgImageSelect:(UIImage *)bgImageSelect textColor:(UIColor *)textColor target:(id)target selector:(SEL)selector frame:(CGRect)frame {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = frame;
    [backBtn setBackgroundImage:bgImageNormal forState:UIControlStateNormal];
    [backBtn setBackgroundImage:bgImageSelect forState:UIControlStateHighlighted];
    if (target && [target respondsToSelector:selector]) {
        [backBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    [backBtn setTitle:text forState:UIControlStateNormal];
    [backBtn setTitleColor:textColor forState:UIControlStateNormal];
    
    return backBtn;
}

+ (UIButton *)createDefaultButtonWithText:(NSString *)text
                                   target:(id)target
                                 selector:(SEL)selector
                                    frame:(CGRect)frame
{
    UIImage *normalImage = [[UIImage imageNamed:@"navi_item_bg.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    UIImage *selectImage = [[UIImage imageNamed:@"navi_item_select.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    UIColor *textColor = [UIColor whiteColor];
    return [self createButtonWithText:text
                        bgImageNormal:normalImage
                        bgImageSelect:selectImage
                            textColor:textColor
                               target:target
                             selector:selector
                                frame:frame];
}

+ (UIButton *)createDefaultButtonWithText:(NSString *)text
                                   target:(id)target
                                 selector:(SEL)selector
{
    CGSize textSize = [text safelySizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(70, 15)];
    CGRect frame = CGRectMake(0, 0, textSize.width+20, 30);
    return [self createDefaultButtonWithText:text target:target selector:selector frame:frame];
}

+ (UIBarButtonItem *)createCustomBarButtonItemWithText:(NSString *)text withImage:(UIImage *)image target:(id)target selector:(SEL)selector{
    
    UIView *homeButtonView = [[UIView alloc]init];
    UIButton *homeButton = [self createDefaultButtonWithText:text target:target selector:selector];
    [homeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIImageView *homeButtonImageView = [[UIImageView alloc]init];
    CGFloat scale = image.size.height/homeButton.height;
    homeButtonImageView.frame = CGRectMake(homeButton.right, 0, image.size.width/scale, homeButton.height);
    [homeButtonImageView setImage:image];
    [homeButtonView setFrame:CGRectMake(0, 0, homeButtonImageView.right, homeButton.height)];
    [homeButtonView addSubview:homeButtonImageView];
    [homeButtonView addSubview:homeButton];
    //创建home按钮
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:homeButtonView];
    return homeButtonItem;
}

+ (UIBarButtonItem *)createBarButtonItemWithText:(NSString *)text
                                          target:(id)target
                                        selector:(SEL)selector
{
    UIButton *backBtn = [self createDefaultButtonWithText:text target:target selector:selector];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    return btnItem;
}

+ (UIBarButtonItem *)createBarButtonItemWithText:(NSString *)text
                                          target:(id)target
                                        selector:(SEL)selector
                                           bgImg:(UIImage *)bgImg
                                highlightedBgImg:(UIImage *)highlightedBgImg {
    UIButton *backBtn = [self createDefaultButtonWithText:text target:target selector:selector];
    [backBtn setBackgroundImage:[bgImg stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[highlightedBgImg stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted];
    UILabel *textLabel = (UILabel *)[backBtn viewWithTag:101];
    if (textLabel) {
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    return btnItem;
}

+ (UIBarButtonItem *)createArrowBarButtonItemWithText:(NSString *)text
                                               target:(id)target
                                             selector:(SEL)selector
{
    UIButton *backBtn = [self createDefaultButtonWithText:text target:target selector:selector];
    backBtn.frame = CGRectMake(0, 0, backBtn.frame.size.width + 5, 30);
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"navi_back.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"navi_back.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateHighlighted];
    UILabel *textLabel = (UILabel *)[backBtn viewWithTag:101];
    if (textLabel) {
        textLabel.frame = CGRectMake(5, 0, backBtn.frame.size.width - 5, 30);
    }
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    return btnItem;
}

+ (UIBarButtonItem *)createArrowBarButtonItemWithText:(NSString *)text
                                               target:(id)target
                                             selector:(SEL)selector
                                                bgImg:(UIImage *)bgImg
                                     highlightedBgImg:(UIImage *)highlightedBgImg {
    UIButton *backBtn = [self createDefaultButtonWithText:text target:target selector:selector];
    backBtn.frame = CGRectMake(0, 0, backBtn.frame.size.width + 5, 30);
    [backBtn setBackgroundImage:[bgImg stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[highlightedBgImg stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateHighlighted];
    UILabel *textLabel = (UILabel *)[backBtn viewWithTag:101];
    if (textLabel) {
        textLabel.frame = CGRectMake(5, 0, backBtn.frame.size.width - 5, 30);
        textLabel.textColor = [UIColor blackColor];
    }
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    return btnItem;
}

+ (UIButton *)createDefaultButtonWithImage:(UIImage *)image
                          highLightedImage:(UIImage *)highlightedImage
                                    target:(id)target
                                  selector:(SEL)selector {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(0, 0, image.size.width*.3, image.size.height*.3);
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    if (target && [target respondsToSelector:selector]) {
        [backBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return backBtn;
}

+ (UIBarButtonItem *)createBarButtonWithImage:(UIImage *)image
                             highLightedImage:(UIImage *)highlightedImage
                                       target:(id)target
                                     selector:(SEL)selector
{
    
    UIButton *backBtn = [self createDefaultButtonWithImage:image highLightedImage:highlightedImage target:target selector:selector];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    return btnItem;
}


+ (CGSize)text:(NSString *)text size:(CGSize)size font:(UIFont *)font{
    return [text boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes: @{NSFontAttributeName:font}
                              context:nil].size;
}
#pragma mark - UITextField

+ (UITextField *)drawTextFieldInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Pholder:(NSString *)placeholder Color:(UIColor *)color SecureTextEntry:(BOOL)secTE{
    UITextField *TF = [ETUIUtil drawTextFieldInView:mainView Frame:frame Font:font Pholder:placeholder Color:color];
    TF.secureTextEntry = secTE;
    return TF;
}
+ (UITextField *)drawTextFieldInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Pholder:(NSString *)placeholder Color:(UIColor *)color{
    UITextField *TF = [[UITextField alloc] initWithFrame:frame];
    TF.placeholder = placeholder;
    [TF setTextColor:color];
    [TF setFont:font];
    TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [mainView addSubview:TF];
    return TF;
}

+ (UITextField *)setLeftMargin:(UITextField *)textField{
    
    CGRect frame = textField.frame;  //为你定义的UITextField
    frame.size.width = 5;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    textField.leftView = leftview;
    return textField;
}
+ (UITextField *)setRightMargin:(UITextField *)textField{
    
    CGRect frame = textField.frame;  //为你定义的UITextField
    frame.size.width = 5;
    UIView *rightview = [[UIView alloc] initWithFrame:frame];
    textField.rightViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    textField.rightView = rightview;
    return textField;
}


@end

@implementation CommonTextField
@synthesize section,row;

@end

