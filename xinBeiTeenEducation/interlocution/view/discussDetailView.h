//
//  discussDetailView.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Badge.h"

@class discussDetailView;
@protocol discussDetailViewDelegate <NSObject>

- (void)textFieldDelegate:(discussDetailView *)field;
- (void)commentBtnInView:(discussDetailView *)view;
- (void)likeBtnInView:(discussDetailView *)view;
- (void)nextBtnInView:(discussDetailView *)view;

@end

@interface discussDetailView : UIView

@property (nonatomic,strong) UITextField *commentField;
@property (nonatomic,strong) UIButton *commenBtn;

@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,weak) id<discussDetailViewDelegate> delegate;

@end
