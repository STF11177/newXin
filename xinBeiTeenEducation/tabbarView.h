//
//  tabbarView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/15.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tabbarView;
@protocol tabbarViewDelegate <NSObject>

- (void)textFieldDelegate:(tabbarView *)field;
- (void)liekTabbarDelegate:(tabbarView *)field;
- (void)collectTabbarDelegate:(tabbarView *)field;
- (void)shareTabbarDelegate:(tabbarView *)field;

@end

@interface tabbarView : UIView

@property (nonatomic,strong) UITextField *textFiled;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,weak) id<tabbarViewDelegate> delegate;
@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,assign) BOOL isLike;

@end
