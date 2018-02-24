//
//  PreviewController.h
//  Bike
//
//  Created by yizheming on 16/5/10.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PreviewController;
@protocol PreviewControllerDelegate <NSObject>
- (void)completedPreviewFinished:(NSMutableArray *)images;
- (void)selectedPhotoFinished:(NSMutableArray *)images;
@end

@interface PreviewController : UIViewController
@property (nonatomic, weak) id<PreviewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger remainNum;
@end
