
#import "UIImage+FixOrientation.h"

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    img = [UIImage decodedImageWithImage:img];

    return img;
}


- (UIImage *)overTurnLeftOrRight{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(bounds.size);
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    transform = CGAffineTransformTranslate(transform, width, height);
    transform = CGAffineTransformRotate(transform, M_PI);
 
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    imageCopy =  [UIImage decodedImageWithImage:imageCopy];

    
    return imageCopy;
}


- (UIImage *)overTurnUpOrDown{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    imageCopy = [UIImage decodedImageWithImage:imageCopy];
    
    return imageCopy;
}



- (UIImage *)rotationWithAngle:(CGFloat)angle{
    
    CGSize imgSize = self.size;
    
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(angle));
    CGSize outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [self drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [UIImage decodedImageWithImage:image];

    
    return image;
    
}

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (image.images) {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.

    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    
    return decompressedImage;
}

+ (NSArray *)getHeadMetaFromAlasset:(ALAsset *)alasset{
    //获取到相片、视频的缩略图
    ALAssetRepresentation* representation = [alasset defaultRepresentation];
    NSString *type = [representation.UTI pathExtension];
    id meta;
    //获取到相片、视频的缩略图
    meta = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
    
    return @[meta,type];
}

+ (NSArray *)getMetaFromAlasset:(ALAsset *)alasset{
    //获取到相片、视频的缩略图
    ALAssetRepresentation* representation = [alasset defaultRepresentation];
    NSString *type = [representation.UTI pathExtension];
    id meta;
    if ([@"png" isEqualToString:type]||[@"jpeg" isEqualToString:type]) {
        
        meta = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
    }else{
        meta = [[self class] getGifDataFromAlasset:representation];
    }
    return @[meta,type];
}

+ (NSData *)getGifDataFromAlasset:(ALAssetRepresentation *)representation{

    long long size = representation.size;
    uint8_t *buffer = malloc(size);
    NSError *error;
    NSUInteger bytes = [representation getBytes:buffer fromOffset:0 length:size error:&error];
    NSData *data = [NSData dataWithBytes:buffer length:bytes];
    free(buffer);
    return data;
}


//+ (UIImage *)getVideoCoverImage:(NSURL *)fileUrl{
//    
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
//    
//    NSParameterAssert(asset);
//    
//    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    
//    assetImageGenerator.appliesPreferredTrackTransform = YES;
//    
//    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
//    
//    
//    CGImageRef thumbnailImageRef = NULL;
//    
//    CFTimeInterval thumbnailImageTime = 0;
//    
//    NSError *thumbnailImageGenerationError = nil;
//    
//    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 15) actualTime:NULL error:&thumbnailImageGenerationError];
//    
//    
//    if (!thumbnailImageRef)
//        
//        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
//    
//
//    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
//    
//    //NSData *imageData = UIImagePNGRepresentation(thumbnailImage);
//    
//    CGImageRelease(thumbnailImageRef);
//    return  thumbnailImage;
//}

@end
