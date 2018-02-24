//
//  interKeyBoardView.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/10.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class interKeyBoardView;
@protocol interKeyBoardViewDelegate <NSObject>

- (void)backInView:(interKeyBoardView *)View;
- (void)showPictureInView;

@end

@interface interKeyBoardView : UIView

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *pictureBtn;

@property (nonatomic,weak) id<interKeyBoardViewDelegate> delegate;

@end
