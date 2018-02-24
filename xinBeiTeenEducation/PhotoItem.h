//
//  PhotoItem.h
//  Carcool
//
//  Created by Enjoytouch on 15/8/3.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoItem;
@protocol PhotoItemDelegate <NSObject>
@optional
- (void)selectedPhotoItem:(UIButton *)button;
- (void)cannotSelectedAnyMore;
- (void)cellDidClickedWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface PhotoItem : UICollectionViewCell

@property (nonatomic,weak)   id<PhotoItemDelegate> delegate;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) BOOL        isSelected;
@property (nonatomic,strong) UIImageView *statusImgV;
@property (nonatomic,strong) NSIndexPath *indexPath;


@end
