//
//  ETPhotoUtil.h
//  Bike
//
//  Created by yizheming on 16/5/8.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ETPhotoUtil : NSObject
@property (nonatomic, strong)ALAssetsLibrary *library;
@property (nonatomic,strong) NSMutableArray *allPhotos;
@property (nonatomic,strong) NSMutableString *cameraRoll;

+ (id)sharedInstance;
+ (void)springAnimation:(UIView *)animateView;
+ (void)getImagesFromALAssetsLibraryCompletion:(void(^)(void))completion;
+ (void)getAllImagesFromALAssetsLibrary;
@end
