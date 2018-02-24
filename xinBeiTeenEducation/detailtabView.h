//
//  detailtabView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/30.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class detailtabView;
@protocol detailtabViewDelegate <NSObject>

- (void)textFieldDelegate:(detailtabView *)field;
- (void)liekTabbarDelegate:(detailtabView *)field;
- (void)collectTabbarDelegate:(detailtabView *)field;

@end

@interface detailtabView : UIView

@property (nonatomic,strong) UITextField *textFiled;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,weak) id<detailtabViewDelegate> delegate;
@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,assign) BOOL isLike;

@end
