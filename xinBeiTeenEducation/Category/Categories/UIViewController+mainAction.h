//
//  UIViewController+mainAction.h
//  Bike
//
//  Created by Enjoytouch on 16/4/21.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAlert.h"
@interface UIViewController (mainAction)<UIAlertViewDelegate>

- (void)showAlertWithBtnTitles:(NSArray *)titles;
- (void)showAlertSendMessage:(NSString *)message Titles:(NSArray *)titles;
- (void)showAlert:(NSString *)message withBtnTitles:(NSArray *)titles;
- (void)showAlert:(NSString *)message withBtnTitles:(NSArray *)titles tag:(NSInteger)tag;


//提示框
- (void)showAlertWithMessage:(NSString *)message;

//有确定和取消按钮
- (void)showAlertWithMessage:(NSString *)message tag:(NSInteger)tag;
//有确定和取消按钮------有输入框
- (void)showInputAlertWithMessage:(NSString *)message tag:(NSInteger)tag;
//带标题有确定和取消按钮------有输入框
- (void)showInputAlertWithMessage:(NSString *)message title:(NSString *)title tag:(NSInteger)tag;

//确定&&取消回调方法
- (void)performCancelActionWithTag:(NSInteger )tag;
- (void)performSureActionWithTag:(NSInteger )tag;
- (void)performInputAlertViewWitnSureAction:(NSString *)text tag:(NSInteger)tag;

@end


