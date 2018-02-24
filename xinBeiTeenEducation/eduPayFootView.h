//
//  eduPayFootView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eduPayFootView;
@protocol  eduPayFootViewDelete <NSObject>

-(void)payFootView;

@end

@interface eduPayFootView : UIView

@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UILabel *priceLb;

@property (nonatomic, weak) id<eduPayFootViewDelete> delegate;

@end
