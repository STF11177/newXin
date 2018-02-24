//
//  PhotoItem.m
//  Carcool
//
//  Created by Enjoytouch on 15/8/3.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//

#import "PhotoSampleItem.h"

@implementation PhotoSampleItem
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:_imageView];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        
    }
    return self;
}

- (void)dealloc{
    _imageView.image = nil;
    [_imageView removeFromSuperview];
    _imageView =nil;
}
@end
