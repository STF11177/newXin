//
//  keyBoardView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class keyBoardView;
@protocol keyBoardViewDelegate <NSObject>

- (void)onCommentInKeyBoard:(keyBoardView *)view;

@end

@interface keyBoardView : UIView

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,weak) id<keyBoardViewDelegate> delegate;

@end
