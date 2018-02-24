//
//  ActionSheet.h
//  XingPin
//
//  Created by Enjoytouch on 14-11-28.
//  Copyright (c) 2014年 EnjoyTouch. All rights reserved.
//

/**********XPActionSheet教程************
##### 实例化方法 ####
-(id)initWithDelegate:(id)delegate itemTitles:(NSArray *)titles;
 
 delegate:委托对象
 titles:所有messageView中的sheetBt名称(包含标题title,而且title.text = titles[0];如果titles[0]=@""的话，则无标题)
 
##### 协议委托方法 ####
- (void)xpActionSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag;
 
 sheetTag:不必须设置的参数，但是当一个Controller中需要实例化多个XPActionSheet时，需要actionsheet.sheetTag = 2来在委托方法中
 区分是那个对象执行了该协议方法
 index:区分是该actionsheet对象中的点击事件的sheet的标签；
 
**************************************/


#import <UIKit/UIKit.h>
#import "BlurView.h"
@protocol CommonSheetDelegate <NSObject>

@optional

- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag;
- (void)ShareChaining:(UIButton *)btn;

- (void)selectChaining:(NSString *)tag;
- (void)selectSubjectCount:(NSString *)subjectCount;

@end

@interface CommonSheet : UIView
@property (nonatomic,strong) BlurView *messageView;
@property (nonatomic,strong) UIView *markView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSMutableArray *sheets;
@property (nonatomic,strong) UIColor *itemColor;


@property (nonatomic,strong) NSString *subjectId;//考证相关的参数
@property (nonatomic,strong) NSMutableArray *subjectCount;//考证相关的参数
@property (nonatomic,strong) UIButton *categoryBtn;//考证等级按钮
@property (nonatomic,strong) NSMutableArray *dataArray;//等级考试的数组
@property (nonatomic,strong) NSMutableArray *categoryId;
@property (nonatomic,strong) NSMutableArray *subject_money;//价格

@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,assign) CGFloat Messageheight;


@property (nonatomic,weak) id<CommonSheetDelegate> delegate;
@property (nonatomic,assign) NSInteger sheetTag;

//考证
-(void)showTestInView:(UIView *)view;

- (void)showInView:(UIView *)view;
- (id)initWithDelegate:(id)delegate;
- (void)setupWithTitles:(NSArray *)titles;
- (void)setupWithShare;
- (void)setupSubView;
- (void)show;

@end

