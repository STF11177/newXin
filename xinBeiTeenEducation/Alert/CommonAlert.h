//
//  CommonAlert.h
//  Carcool
//
//  Created by yizheming on 15/11/23.
//  Copyright © 2015年 EnjoyTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAlert : UIView

@property (nonatomic,strong) id data;
@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) UIView *line;//发送好友请求框下的横线，默认隐藏

- (id)initWithBtnTitles:(NSArray *)titles;//添加好友输入框
- (id)initWithWriteWeightWithBtnTitles:(NSArray *)titles;//体重
- (id)initWithModifiedInforWithBtnTitles:(NSArray *)titles andWithmessage:(NSString *)message;//昵称等
- (id)initWithMessage:(NSString *)message withBtnTitles:(NSArray *)titles;//通用
- (id)initWithSendMessage:(NSString *)message Titles:(NSArray *)titles;
- (id)initWithTitle:(NSString *)title Message:(NSString *)message withBtnTitles:(NSArray *)titles;//修改密码
- (void)hiddenView;
- (void)showInWindow;

@end
@protocol CommonAlertDelegate <NSObject>
@optional
-(void)itemCancel:(CommonAlert *)alert;
-(void)itemCertain:(CommonAlert *)alert;
-(void)oneButtonitemCertain:(CommonAlert *)alert;
//主播关注事件
- (void)selectedFollowStatusAnchorId:(NSString *)anchorId;
//点击头像事件
- (void)selectedSnapImageAnchorId:(NSString *)anchorId;

@end
