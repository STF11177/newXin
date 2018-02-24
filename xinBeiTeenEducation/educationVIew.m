//
//  educationVIew.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import "educationVIew.h"
#import "SDPhotoBrowser.h"

@interface educationVIew()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, assign) CGFloat width;

@end

@implementation educationVIew

- (instancetype)initWithWidth:(CGFloat)width{
    if (self = [super init]) {
        NSAssert(width>0, @"请设置图片容器的宽度");
        self.width = width;
    }
    return self;
}

-(void)setPicArray:(NSArray *)picArray{

    _picArray = picArray;

    __weak typeof(self) weakSelf = self;
    for (int i = 0; i< self.picArray.count; i++) {
        NSURL *obj     =  self.picArray[i];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        
        [imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"edubook"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setFrame:CGRectMake(0, weakSelf.imageHeight, ScreenWidth, image.size.height*0.5)];
            weakSelf.imageHeight  = weakSelf.imageHeight + image.size.height*0.5;
        }];
        
         [self addSubview:imageView];
    }
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
   UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picArray.count;
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

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    DDLog(@"%@",self.subviews[index]);
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
