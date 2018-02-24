//
//  backGroundView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class backGroundView;
@protocol backViewdelegate <NSObject>

-(void)netClickDelegate:(backGroundView*)view;

@end

@interface backGroundView : UIView

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIButton *netBtn;
@property (nonatomic,weak) id<backViewdelegate> delegate;

- (void)hiddenView;

@end
