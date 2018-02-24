//
//  PreviewItem.m
//  Bike
//
//  Created by yizheming on 16/5/10.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "PreviewItem.h"
#import "YYKit.h"

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.delegate = self;
    
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];

    return self;
}

- (void)setCellImage:(UIImage *)image{
    _imageView.image = image;
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end


@implementation PreviewItem
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
   
        _imageCell  = [[ImageCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
        [self.contentView addSubview:_imageCell];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail: tap2];
        [self addGestureRecognizer:tap2];

    }
    return self;
}

- (void)setItemImage:(UIImage *)image{
    [_imageCell setCellImage:image];
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (_imageCell.zoomScale > 1) {
        [_imageCell setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [g locationInView:_imageCell.imageView];
        CGFloat newZoomScale = _imageCell.maximumZoomScale;
        CGFloat xsize = self.width / newZoomScale;
        CGFloat ysize = self.height / newZoomScale;
        [_imageCell zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)dismiss{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tapGestureAction)]) {
        [self.delegate tapGestureAction];
    }
}

- (void)resizeAction{
    [_imageCell setZoomScale:1 animated:YES];

}

- (void)dealloc{
    _imageCell.imageView.image = nil;
    [_imageCell.imageView removeFromSuperview];
    _imageCell.imageView = nil;
    [_imageCell removeFromSuperview];
    _imageCell = nil;
}
@end
