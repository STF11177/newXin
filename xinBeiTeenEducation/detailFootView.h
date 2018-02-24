//
//  detailFootView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/29.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  detailFootViewDelete <NSObject>

-(void)payFootView;

@end

@interface detailFootView : UIView

@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIView *sepeView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic, weak) id<detailFootViewDelete> delegate;

@end
