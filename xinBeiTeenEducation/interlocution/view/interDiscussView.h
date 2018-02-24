//
//  interDiscussView.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class interDiscussView;
@protocol discussViewDelegate <NSObject>

- (void)discussInCell:(interDiscussView *)View;
- (void)collectInView:(interDiscussView *)view;

@end

@interface interDiscussView : UIView

@property (nonatomic,strong) UIButton *discussCountBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *discussBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,weak) id<discussViewDelegate> delegate;

@end
