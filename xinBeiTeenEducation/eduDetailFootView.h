//
//  eduDetailFootView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eduDetailFootView;
@protocol  eduDetailFootViewDelete <NSObject>

-(void)payFootView;
-(void)collectFootView:(eduDetailFootView*)footView;
-(void)likeFootView:(eduDetailFootView*)footView;

@end

@interface eduDetailFootView : UIView


@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIView *sepeView;

@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic, weak) id<eduDetailFootViewDelete> delegate;

@end
