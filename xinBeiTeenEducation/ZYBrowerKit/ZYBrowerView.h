//
//  ZYBrowerView.h
//  ZYPictureBrowerKit
//
//  Created by 周智勇 on 2017/4/7.
//  Copyright © 2017年 ZhouZhiYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYBrowerView : UIView

- (instancetype)initWithFrame:(CGRect)frame imagesUrlAry:(NSArray *)imagesUrlAry currentIndex:(NSInteger)currentIndex;

- (void)show;

@end
