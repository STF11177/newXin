//
//  hotSearchBar.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hotSearchBar : UISearchBar

@property (nonatomic, strong) UIColor *cursorColor;//光标的颜色
@property (nonatomic, strong) UITextField *searchBarField;//搜索框
@property (nonatomic, strong) UIImage *clearButtonImage;//输入框清除按钮图片
@property (nonatomic,assign) BOOL hideSearchBarBackgroundImage;//隐藏SearchBar背景灰色部分 默认显示
@property (nonatomic,strong) UIButton *cancleButton;//取消按钮 showsCancelButton = YES 才能获取到
@property (nonatomic,strong) UIImage *searchButtonImage;

@end
