//
//  chanelController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置返回刷新代理
@protocol BackRefreshDelegate <NSObject>

//返回刷新方法
-(void)backToRefresh;

@end

@interface chanelController : UIViewController

@property (nonatomic,weak) id<BackRefreshDelegate> delegate;


@end
