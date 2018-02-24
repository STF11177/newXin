//
//  HMpickViewController.h
//  CustomDatePickView
//
//  Created by WXYT-iOS2 on 16/8/13.
//  Copyright © 2016年 WXYT-iOS2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlockType)(NSString *selectDate,NSString *fromWhere);

@interface HMDatePickView : UIView

/** 距离当前日期最大年份差（>0小于当前日期，<0 当前日期） */
@property(assign, nonatomic) NSInteger maxYear;

/** 距离当前日期最小年份差 */
@property(assign, nonatomic) NSInteger minYear;

/** 默认显示日期 */
@property (strong, nonatomic) NSDate *date;

/** 日期回调 */
@property(copy, nonatomic) MyBlockType completeBlock;

/** 设置确认/取消字体颜色(默认为黑色) */ 

@property (strong, nonatomic) UIColor *fontColor;
@property (nonatomic,strong) NSString *fromWhere;//从哪里到这个界面

//配置
- (void)configuration;
- (void)hidePicker;




typedef NS_ENUM(NSInteger,TimeShowMode){
    /**
     * 只显示今天之前的时间
     */
    ShowTimeBeforeToday = 1,
    /**
     * 显示今天之后的时间
     */
    ShowTimeAfterToday,
    /**
     * 不限制时间
     */
    ShowAllTime,
    
};










@end
