//
//  ZYBrowerConfiger.h
//  ZYPictureBrowerKit
//
//  Created by 周智勇 on 2017/4/7.
//  Copyright © 2017年 ZhouZhiYong. All rights reserved.
//

#ifndef ZYBrowerConfiger_h
#define ZYBrowerConfiger_h

typedef enum {
    SDWaitingViewModeLoopDiagram, // 环形
    SDWaitingViewModePieDiagram // 饼型
} SDWaitingViewMode;

#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
#define kUIScreenHeight kUIScreenSize.height
#define RGBColor(r,g,b) RGBAColor(r,g,b,1.0)
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// browser背景颜色
#define SDPhotoBrowserBackgrounColor RGBAColor(0,0,0,0.95)

// browser中图片间的margin
#define SDPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define SDPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define SDPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（SDWaitingViewModeLoopDiagram 环形，SDWaitingViewModePieDiagram 饼型）
#define SDWaitingViewProgressMode SDWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define SDWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define SDWaitingViewItemMargin 10



#endif /* ZYBrowerConfiger_h */
