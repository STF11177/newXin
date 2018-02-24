//
//  LSYMenuView.h
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
#import "LSYTopMenuView.h"
#import "sliderView.h"
@class LSYMenuView;
@class LSYBottomMenuView;
@protocol LSYMenuViewDelegate <NSObject>
@optional
-(void)menuViewDidHidden:(LSYMenuView *)menu;
-(void)menuViewDidAppear:(LSYMenuView *)menu;
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu;//底部目录
-(void)menuViewInvokeTopCatalog:(LSYTopMenuView *)topMenu;//顶部目录
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page;
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu;
-(void)menuViewMark:(LSYTopMenuView *)topMenu;
-(void)menuViewSetting:(LSYTopMenuView *)topMenu;//设置按钮

@end
@interface LSYMenuView : UIView
@property (nonatomic,weak) id<LSYMenuViewDelegate> delegate;
@property (nonatomic,strong) LSYRecordModel *recordModel;
@property (nonatomic,strong) LSYTopMenuView *topView;
@property (nonatomic,strong) LSYBottomMenuView *bottomView;
@property (nonatomic,strong) sliderView *prograssView;

-(void)showAnimation:(BOOL)animation;
-(void)hiddenAnimation:(BOOL)animation;
@end
