////
////  ImgUpLoadModel.m
////  SportStar
////
////  Created by Enjoytouch on 15/6/16.
////  Copyright (c) 2015年 谢建亮. All rights reserved.
////
//
//#import "ImgUpLoadModel.h"
//#import <AssetsLibrary/AssetsLibrary.h>
//
//@implementation ImgUpLoadModel
//
////上传图片
////- (void)postImage:(NSMutableArray *)images{
////  
////    NSArray *uploads = [self getImageDatasWithImages:images];
////    [self createPostRequest:@"image/upload"
////                  withParam:nil
////                  withImageDatas:uploads
////                  finishSel:@selector(postImageFinished:)
////                    failSel:@selector(postImageFailed:)
////                    dataObj:nil];
////    
////}
//
//- (NSMutableArray *)getImageDatasWithImages:(NSArray *)images{
//    NSMutableArray *uploadDatas = [NSMutableArray array];
//    for (NSArray *item in images) {
//        NSData *data;
//        id meta = [item firstObject];
//        NSString *type = [item lastObject];
//
//        if ([meta isKindOfClass:[NSData class]]) {
//            [uploadDatas safelyAddObject:@[meta,type]];
//            continue;
//        }
//        
//        UIImage *image =meta;
//        CGFloat scale = image.size.height/image.size.width;
//        CGSize imgSize = image.size;
//        
//        
//        //1280宽或高的直接压缩到1242（1080P）(长图小于2M，普通300k)
//        if (scale>3) {
//            if (imgSize.width>1080) {
//                imgSize = CGSizeMake(1080,1080*scale);
//            }
//        }else if (scale<(1.0/3)) {
//            if (imgSize.width>1920) {
//                imgSize = CGSizeMake(1920,floorf(imgSize.height*1920/imgSize.width));
//            }
//        }else{
//            if(imgSize.height>1920&&imgSize.width<=1080) {
//                imgSize = CGSizeMake(floorf(imgSize.width*1920/imgSize.height),1920);
//            }else if (imgSize.width>1080&&imgSize.height<=1920) {
//                imgSize = CGSizeMake(1080,1080*scale);
//            }else if(imgSize.height>1920&&imgSize.width>1080) {
//                if (scale>(1920/1080)) {
//                    imgSize = CGSizeMake(floorf(imgSize.width*1920/imgSize.height),1920);
//                }else{
//                    imgSize = CGSizeMake(1080,1080*scale);
//                }
//            }
//        }
//        
//        if ([@"png" isEqualToString:[item lastObject]]) {
//            data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:YES];
//            if (data.length>300000) {
//                data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
//            }
//        }else{
//            data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:NO];
//            if (data.length>300000) {
//                data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
//            }
//        }
//        [uploadDatas safelyAddObject:@[data,type]];
//    }
//    return uploadDatas;
//}
//
//
//
////JPEG及其它类型的图片压缩
//- (NSData *)getJpegTypeScaleImageWithImage:(NSData *)imageData toMaxFileSize:(NSInteger)maxFileSize{
//    CGFloat compression = 0.9f;
//    CGFloat maxCompression = 0.1f;
//    
//    if ([imageData length] > maxFileSize){
//        UIImage *imageTemp = [UIImage imageWithData:imageData];
//        while ([imageData length] > maxFileSize && compression > maxCompression) {
//            imageData = UIImageJPEGRepresentation(imageTemp, compression);
//            compression -= 0.1;
//        }
//    }
//    return imageData;
//}
//
//
////图片大小压缩
//- (NSData *)imageWithImage:(UIImage*)image
//              scaledToSize:(CGSize)newSize toCompression:(CGFloat)compression isPngType:(BOOL)type;
//{
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    if (type)
//        return UIImagePNGRepresentation(newImage);
//    return UIImageJPEGRepresentation(newImage, compression);
//}
//
////- (void)postImageFinished:(id)request {
////    DLog(@"图片数据%@",request);
////    if([self isRequestSuccess:request]) {
////        ImageResultData *imageResult = [ETDataTransUtil getData:request class:@"ImageResultData"];
////        [self performSelector:@selector(postImageSucc:) onTarget:self.delegate withObject:imageResult];
////    }
////    else {
////        [self performSelector:@selector(postImageFail:) onTarget:self.delegate withObject:[self getErrorWithResponseObject:request]];
////    }
////}
//
////- (void)postImageFailed:(ErrorData *)request {
////    [self performSelector:@selector(postImageFail:) onTarget:self.delegate withObject:nil];
////}
//
//@end
