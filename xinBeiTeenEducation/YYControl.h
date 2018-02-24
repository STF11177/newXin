//
//  YYControl.h
//  YYKitExample
//
//  Created by yizheming on 16/4/7.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

@interface YYControl : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) float inCenterY;
@property (nonatomic, copy) void (^touchBlock)(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(YYControl *view, CGPoint point);
@end
