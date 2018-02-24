//
//  hotSearchBar.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "hotSearchBar.h"

@implementation hotSearchBar

//设置光标的颜色
-(void)setCursorColor:(UIColor *)cursorColor{

    if (cursorColor) {
        
        _cursorColor = cursorColor;
        //获取输入框
        UITextField *searchTextFirld = self.searchBarField;
        if (searchTextFirld) {
            //光标颜色
            [searchTextFirld setTintColor:cursorColor];
        }
    }
}

//获取输入框
-(UITextField *)searchBarField{

    _searchBarField = [self valueForKey:@"searchField"];
    [_searchBarField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchBarField setBackgroundColor:[UIColor clearColor]];//透明效果
    _searchBarField.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色

    return _searchBarField;
}

//设置清除按钮
-(void)setClearButtonImage:(UIImage *)clearButtonImage{

    if (clearButtonImage) {
        _clearButtonImage = clearButtonImage;
        
        UITextField *searchtextField = self.searchBarField;
        if (searchtextField) {
            
            //设置清楚按钮图片
            UIButton *button = [searchtextField valueForKey:@"_clearButton"];
            [button setImage:clearButtonImage forState:UIControlStateNormal];
            searchtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
}

-(void)setSearchButtonImage:(UIImage *)searchButtonImage{
    
    if (searchButtonImage) {
        _searchButtonImage = searchButtonImage;
        //获取输入框
        UITextField *searchField = self.searchBarField;
        if (searchField) {
            //设置清除按钮图片
            
            UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 13, 13)];
            imageViewPwd.image= searchButtonImage;
            searchField.leftView=imageViewPwd;
            searchField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
            searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
    }
}

//背景
-(void)setHideSearchBarBackgroundImage:(BOOL)hideSearchBarBackgroundImage{

    if (hideSearchBarBackgroundImage) {
        
        _hideSearchBarBackgroundImage = hideSearchBarBackgroundImage;
        self.backgroundImage =[[UIImage alloc]init];
    }
}

//获取取消按钮
-(UIButton *)cancleButton{

    self.showsCancelButton = YES;
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            _cancleButton = (UIButton *)view;
        }
    }
    return _cancleButton;

}

@end
