//
//  UIImage+ExtraMethod.m
//  Anjuke
//
//  Created by luochenhao on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ETImage.h"

@implementation UIImage (ETImage)

+ (UIImage *)imageBundleNamed:(NSString *)filename {
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    return  [UIImage imageWithContentsOfFile:path];
}



- (UIImage *)getSubImage:(CGRect)rect  
{  
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);  
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
    
    UIGraphicsBeginImageContext(smallBounds.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];  
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return smallImage;  
}

- (size_t)imageBytesSize
{
    CGImageRef cgImage = self.CGImage;
    
    size_t bytesRow = CGImageGetBytesPerRow(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    return height * bytesRow;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (UIImage *)imageCropToSize:(CGSize)targetSize
{
    CGSize resize = CGSizeZero;
    CGFloat targetFactor = targetSize.width/targetSize.height;
    CGFloat imageFactor = self.size.width/self.size.height;
    
    if (targetFactor>imageFactor) {
        resize.width = self.size.width;
        resize.height = targetSize.height * self.size.width/targetSize.width;
    }
    else {
        resize.width = targetSize.width * self.size.height/targetSize.height;
        resize.height = self.size.height;
    }
    
    CGPoint center = CGPointZero;
    center.x = (self.size.width - resize.width) * 0.5;
    center.y = (self.size.height - resize.height) *0.5;

    return [self getSubImage:CGRectMake(center.x, center.y, resize.width, resize.height)];
}

//截图
- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(rect.origin.x, rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    
    CGFloat scal = 1;
    if (rect.size.width <= 375) {
        scal = 2;
    }else if (rect.size.width == 414) {
        scal = 3;
    }
    rect = CGRectMake(rect.origin.x*scal, rect.origin.y*scal, rect.size.width*scal, rect.size.height*scal);
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


//改变图片颜色
- (UIImage *)imageThemeChangeWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//合并图层
+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(image2.size);
    
    //Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    //Draw image1
    [image1 drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

//截屏并保存到照片库
+ (UIImage *) screenCaptureInView:(UIView *)view{
    CGSize size = view.frame.size;
    CGFloat scal = 1;
    if (size.width <= 375) {
        scal = 2;
    }else if (size.width == 414) {
        scal = 3;
    }
    CGRect imgRect = CGRectMake(0, 64*scal, size.width*scal, size.height*scal);//这里可以设置想要截图的区域()
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, imgRect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    return sendImage;
}

@end
