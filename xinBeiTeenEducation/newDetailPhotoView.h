//
//  newDetailPhotoView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface newDetailPhotoView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSString *photoSign;
@property (nonatomic, strong) UIScrollView *scrollView;;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;

@end
