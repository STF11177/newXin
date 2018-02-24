//
//  UIImage+ExtraMethod.h
//  Anjuke
//
//  Created by luochenhao on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UIImage (ETImage)

/*
 * 按照Rect截取Image里一块生成新的image
 */
- (UIImage *)getSubImage:(CGRect)rect;

/*
 * 获取图片内存大小
 */
- (size_t)imageBytesSize;


- (UIImage *)imageCropToSize:(CGSize)targetSize;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

+ (UIImage *)imageBundleNamed:(NSString *)filename;

//切图
- (UIImage*)crop:(CGRect)rect;

- (UIImage *)imageThemeChangeWithColor:(UIColor *)color;

//合并图层
+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withRect:(CGRect)rect;

//截屏 并 保存到照片库
+ (UIImage *) screenCaptureInView:(UIView *)view;

//test
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect ;

@end
