//
//  PhotoItem.h
//  Carcool
//
//  Created by Enjoytouch on 15/8/3.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSampleItem : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath  *indexPath;
@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UIButton *selectedPhoto;

@end
