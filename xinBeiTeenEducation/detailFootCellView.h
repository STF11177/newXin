//
//  detailFootCellView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class detailFootCellView;
@protocol  detailFootViewDelete <NSObject>

-(void)payFootView;
-(void)commentFootView:(detailFootCellView*)footView;
-(void)collectFootView:(detailFootCellView*)footView;
-(void)likeFootView:(detailFootCellView*)footView;

@end

@interface detailFootCellView : UIView

@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIView *sepeView;

@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic, weak) id<detailFootViewDelete> delegate;

@end


