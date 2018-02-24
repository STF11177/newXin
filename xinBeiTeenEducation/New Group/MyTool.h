//
//  MyTool.h
//  Chats
//
//  Created by zhangbinbin on 15/11/17.
//  Copyright © 2015年 engo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DefaultPath @"eengoo/media/"
@interface MyTool : NSObject
//建button
+(UIButton*)createButtonWithFrame:(CGRect)frame WithIsRound:(BOOL)isRound;
+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithIsRound:(BOOL)isRound;
+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithTitleColor:(UIColor*)color WithIsRound:(BOOL)isRound;
+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithTitleColor:(UIColor*)color WithFontSize:(CGFloat)fontSize WithIsRound:(BOOL)isRound;
+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithTitleColor:(UIColor*)color WithFont:(NSString*)fontName WithFontSize:(CGFloat)fontSize WithIsRound:(BOOL)isRound;
+(UIButton*)createButtonWithFrame:(CGRect)frame WithImage:(UIImage*)image WithIsRound:(BOOL)isRound;
+(UIButton*)createButtonWithFrame:(CGRect)frame WithImage:(UIImage*)image WithSelectedImage:(UIImage*)selectedImage WithIsRound:(BOOL)isRound;

//取得多媒体文件保存路径
+(NSString*)getMediaPathToSave;
+(NSString *)ret32bitString;

@end
