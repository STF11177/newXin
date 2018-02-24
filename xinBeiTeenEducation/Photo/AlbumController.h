//
//  AlbumController.h
//  Bike
//
//  Created by yizheming on 16/4/12.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@class AlbumController;
@protocol AlbumControllerDelegate <NSObject>
- (void)selectedImagesFinished:(NSMutableArray *)images;

@end


@interface AlbumController : UIViewController
@property (nonatomic, weak) id<AlbumControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger remainNum;
@property (nonatomic, strong) NSMutableArray *allGroups;
@property (nonatomic, strong) NSMutableArray *tempSet;
@end
