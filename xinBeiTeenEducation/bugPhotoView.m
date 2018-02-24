//
//  bugPhotoView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bugPhotoView.h"
#import "SDPhotoBrowser.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface bugPhotoView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, assign) CGFloat width;

@end

@implementation bugPhotoView

- (instancetype)initWithWidth:(CGFloat)width{
    if (self = [super init]) {
        NSAssert(width>0, @"请设置图片容器的宽度");
        self.width = width;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicUrlArray:(NSArray *)picUrlArray{
    _picUrlArray = picUrlArray;
    
    for (long i = _picUrlArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
//    if (_picUrlArray.count == 0) {
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//        return;
//    }
    
    CGFloat itemW = 40;
    CGFloat itemH = 30;
    
    CGFloat margin = 5;
    
    for (int i = 0; i< _picUrlArray.count; i++) {
        NSURL *obj     =  _picUrlArray[i];
        long columnIndex = 0;
        long rowIndex    = 0;
        
        UIImageView *imageView = self.imageViewsArray[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"edubook"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image.size.width < itemW || image.size.height < itemW) {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }
    
    int columnCount = 1;
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picUrlArray.count;
    browser.delegate = self;
    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    return 40;
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{

    return 1;
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSURL *url = [NSURL new];
    if (index < self.picOriArray.count) {
        url = self.picOriArray[index];
    }
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
