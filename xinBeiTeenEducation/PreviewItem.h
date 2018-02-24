//
//  PreviewItem.h
//  Bike
//
//  Created by yizheming on 16/5/10.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

- (void)setCellImage:(UIImage *)image;
@end


@class PreviewItem;
@protocol PreviewItemDelegate <NSObject>
- (void)tapGestureAction;
@end

@interface PreviewItem : UICollectionViewCell
@property (nonatomic, strong)ImageCell *imageCell;
@property (nonatomic, weak) id<PreviewItemDelegate> delegate;

- (void)resizeAction;
- (void)setItemImage:(UIImage *)image;

@end
