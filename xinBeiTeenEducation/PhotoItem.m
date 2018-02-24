//
//  PhotoItem.m
//  Carcool
//
//  Created by Enjoytouch on 15/8/3.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//

#import "PhotoItem.h"
#import "ETPhotoUtil.h"
#import "AlbumController.h"
@implementation PhotoItem
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        
        
        CGFloat ItemW = roundf(self.width*0.5);
        CGFloat ImgW = roundf(self.width*0.4);
        CGFloat ImgMargin = roundf(self.width*0.063);
        
        _statusImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-ImgW+ImgMargin, -ImgMargin, ImgW, ImgW)];
        _statusImgV.image = [UIImage imageBundleNamed:@"find_image_off.png"];
        [self addSubview:_statusImgV];
        
        
        UIButton *statusBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - ItemW, 0, ItemW, ItemW)];
        [statusBtn addTarget:self action:@selector(selectedPhotoItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:statusBtn];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)selectedPhotoItem:(UIButton *)button{
    if (!button.selected&&self.delegate&&[self.delegate isKindOfClass:[AlbumController class]]) {
        AlbumController *albumVC = (AlbumController*)self.delegate;
        if (albumVC.remainNum==0) {
            
            if (self.delegate&&[self.delegate respondsToSelector:@selector(cannotSelectedAnyMore)]) {
                [self.delegate cannotSelectedAnyMore];
            }
            return;
        }
    }
    
    button.selected= !_isSelected;
    self.isSelected = button.selected;
    if (self.isSelected) {
        [ETPhotoUtil springAnimation:_statusImgV];
    }
    button.tag = _indexPath.row;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedPhotoItem:)]) {
        [self.delegate selectedPhotoItem:button];
    }
}

- (void)tapAction{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cellDidClickedWithIndexPath:)]) {
        [self.delegate cellDidClickedWithIndexPath:_indexPath];
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        [_statusImgV setImage:[UIImage imageBundleNamed:@"find_image_on.png"]];
    }else{
        [_statusImgV setImage:[UIImage imageBundleNamed:@"find_image_off.png"]];
    }
}
- (void)dealloc{
    self.delegate = nil;
    _imageView.image = nil;
    [_imageView removeFromSuperview];
    _imageView = nil;
    [self removeFromSuperview];
}
@end
