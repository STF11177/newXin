//
//  payFootView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  payFootViewDelete <NSObject>

-(void)payFootView;

@end
@interface payFootView : UIView

@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,weak) id<payFootViewDelete> delegate;

@end
