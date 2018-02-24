//
//  AlbumEditController.h
//  Bike
//
//  Created by yizheming on 16/5/18.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@class AlbumEditController;
@protocol AlbumEditControllerDelegate <NSObject>
- (void)editedImagesFinished:(NSMutableArray *)images;
@end

@interface AlbumEditController : UIViewController
@property (nonatomic, weak) id<AlbumEditControllerDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
