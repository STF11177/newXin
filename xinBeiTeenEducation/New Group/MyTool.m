//
//  MyTool.m
//  Chats
//
//  Created by zhangbinbin on 15/11/17.
//  Copyright © 2015年 engo. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool

//建button
+(UIButton*)createButtonWithFrame:(CGRect)frame WithIsRound:(BOOL)isRound
{
    return [MyTool createButtonWithFrame:frame WithTitle:nil WithIsRound:isRound];
}

+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithIsRound:(BOOL)isRound
{
    return [MyTool createButtonWithFrame:frame WithTitle:title WithTitleColor:[UIColor whiteColor] WithIsRound:isRound];
}

+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithTitleColor:(UIColor*)color WithIsRound:(BOOL)isRound
{
  return [MyTool createButtonWithFrame:frame WithTitle:title WithTitleColor:color WithFontSize:14.0f WithIsRound:isRound];
}

+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithTitleColor:(UIColor*)color WithFontSize:(CGFloat)fontSize WithIsRound:(BOOL)isRound
{
  return [MyTool createButtonWithFrame:frame WithTitle:title WithTitleColor:color WithFont:@"PingFangSC-Regular" WithFontSize:fontSize WithIsRound:isRound];
}

+(UIButton*)createButtonWithFrame:(CGRect)frame WithTitle:(NSString*)title WithTitleColor:(UIColor*)color WithFont:(NSString*)fontName WithFontSize:(CGFloat)fontSize WithIsRound:(BOOL)isRound
{
  UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame = frame;
  [btn setTitle:title forState:UIControlStateNormal];
  [btn setTitleColor:color forState:UIControlStateNormal];
  btn.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
  
  if (isRound)
  {
    btn.layer.cornerRadius = btn.frame.size.width / 2.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;
  }
  
  return btn;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame WithImage:(UIImage*)image WithIsRound:(BOOL)isRound;
{
    return [MyTool createButtonWithFrame:frame WithImage:image WithSelectedImage:nil WithIsRound:isRound];
}

+(UIButton*)createButtonWithFrame:(CGRect)frame WithImage:(UIImage*)image WithSelectedImage:(UIImage*)selectedImage WithIsRound:(BOOL)isRound
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
  
  if (isRound)
  {
    btn.layer.cornerRadius = btn.frame.size.width / 2.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;
  }
    
    return btn;
}

+(NSString*)getMediaPathToSave
{
  NSFileManager* fm = [NSFileManager defaultManager];
  
  NSString *temp = NSHomeDirectory();
  temp = [temp stringByAppendingString:@"/Documents"];
  temp = [temp stringByAppendingPathComponent:DefaultPath];
  //判断以扩展名为名称的目录是否存在
  if (![fm fileExistsAtPath:temp])
  {
      [fm createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
  }
  
  return temp;
}

+(NSString *)ret32bitString
{
  char data[32];
  for (int x=0;x< 32;data[x++] = (char)('A' + (arc4random_uniform(26))));
  return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
@end
