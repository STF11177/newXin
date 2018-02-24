//
//  UtilUI.h
//  Anjuke
//
//  Created by zhengpeng on 11-7-18.
//  Copyright 2011年 anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 通用UI处理类
*/
@interface ETUIUtil : NSObject {
    
}
//button
+ (UIButton *)drawButtonInView:(UIView *)mainView Frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color Target:(id)target Action:(SEL)action;

+ (UIButton *)drawButtonInView:(UIView *)mainView Frame:(CGRect)frame IconName:(NSString *)name Target:(id)target Action:(SEL)action;
+ (UIButton *)drawButtonInView:(UIView *)mainView Frame:(CGRect)frame IconName:(NSString *)name Target:(id)target Action:(SEL)action Tag:(NSInteger)tag;
//image
+ (UIImageView *)drawCustomImgViewInView:(UIView *)mainView Frame:(CGRect)frame BundleImgName:(NSString *)name;
+ (UIImageView *)drawCustomImgViewInView:(UIView *)mainView Frame:(CGRect)frame ImgName:(NSString *)name;
+ (UIImageView *)drawCustomImgViewInView:(UIView *)mainView Frame:(CGRect)frame ImgName:(NSString *)name Tag:(NSInteger)tag;
//label
+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text;
+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text Tag:(NSInteger)tag;
+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text Color:(UIColor *)color;
+ (UILabel *)drawLabelInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text IsMutiLine:(BOOL)isMutiLine;

//UIView
+ (UIView *)drawViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)color;


+ (UIButton *)createButtonWithText:(NSString *)text
                     bgImageNormal:(UIImage *)bgImageNormal
                     bgImageSelect:(UIImage *)bgImageSelect
                         textColor:(UIColor *)textColor
                            target:(id)target
                          selector:(SEL)selector
                             frame:(CGRect)frame;

+ (UIButton *)createDefaultButtonWithText:(NSString *)text
                                   target:(id)target
                                 selector:(SEL)selector
                                    frame:(CGRect)frame;

+ (UIButton *)createDefaultButtonWithText:(NSString *)text
                                   target:(id)target
                                 selector:(SEL)selector;

+ (UIBarButtonItem *)createCustomBarButtonItemWithText:(NSString *)text
                                             withImage:(UIImage *)image
                                                target:(id)target
                                              selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonItemWithText:(NSString *)text
                                          target:(id)target
                                        selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonItemWithText:(NSString *)text
                                          target:(id)target
                                        selector:(SEL)selector
                                           bgImg:(UIImage *)bgImg
                                highlightedBgImg:(UIImage *)highlightedBgImg;

+ (UIBarButtonItem *)createArrowBarButtonItemWithText:(NSString *)text
                                               target:(id)target
                                             selector:(SEL)selector;

+ (UIBarButtonItem *)createArrowBarButtonItemWithText:(NSString *)text
                                               target:(id)target
                                             selector:(SEL)selector
                                                bgImg:(UIImage *)bgImg
                                     highlightedBgImg:(UIImage *)highlightedBgImg;

+ (UIButton *)createDefaultButtonWithImage:(UIImage *)image
                          highLightedImage:(UIImage *)highlightedImage
                                    target:(id)target
                                  selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonWithImage:(UIImage *)image
                             highLightedImage:(UIImage *)highlightedImage
                                       target:(id)target
                                     selector:(SEL)selector;


+ (CGSize)text:(NSString *)text size:(CGSize)size font:(UIFont *)font;



+ (UITextField *)drawTextFieldInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Pholder:(NSString *)placeholder Color:(UIColor *)color SecureTextEntry:(BOOL)secTE;



+ (UITextField *)drawTextFieldInView:(UIView *)mainView Frame:(CGRect)frame Font:(UIFont *)font Pholder:(NSString *)placeholder Color:(UIColor *)color;



+ (UITextField *)setLeftMargin:(UITextField *)textField;


+ (UITextField *)setRightMargin:(UITextField *)textField;


@end

@interface CommonTextField : UITextField
{
	NSInteger section;
	NSInteger row;
}
@property NSInteger section;
@property NSInteger row;
@end

