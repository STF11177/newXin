//
//  parentDiscusstView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/21.
//  Copyright © 2017年 user. All rights reserved.
//

#import "parentDiscusstView.h"
#import "SDPhotoBrowser.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface parentDiscusstView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation parentDiscusstView

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
        self.imageView = [UIImageView new];
        
        [self addSubview:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [self.imageView addGestureRecognizer:tap];
        [temp addObject:self.imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicUrlArray:(NSArray *)picUrlArray{
    _picUrlArray = picUrlArray;
    
    for (long i = _picUrlArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picUrlArray.count == 0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picUrlArray];
    CGFloat itemH = itemW;
    
//  long perRowItemCount = [self perRowItemCountForPicPathArray:_picUrlArray];
    CGFloat margin = 5;
    
    for (int i = 0; i< _picUrlArray.count; i++) {
        NSURL *obj     =  _picUrlArray[i];
        
        long columnIndex = i % _picUrlArray.count;
        
        self.imageView = self.imageViewsArray[i];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.hidden = NO;
        [self.imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"parent_picker"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image.size.width < itemW || image.size.height < itemW) {
               self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        
        if (columnIndex < 4) {
            
            self.imageView.frame = CGRectMake(columnIndex * (itemW + margin),0 , itemW, itemH);
        }
    }
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
//    if (array.count == 1) {
//        return 60;
//    } else {
        CGFloat itemW = (self.width - 5) /4 ;
        return itemW;
//    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
//    if (array.count < 4) {
        return array.count;
//    } else {
//        return 4;
//    }
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
