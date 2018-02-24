//
//  orderFootView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/7/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "footButton.h"

@class orderFootView;

@protocol orderFootViewDelegate <NSObject>

- (void)onHelp;
- (void)onTestCard;
- (void)onScore;

@end

@interface orderFootView : UIView

@property (nonatomic,strong) UIButton *btnHelp;//考前辅导
@property (nonatomic,strong) UIButton *btnTestCard;//准考证下载
@property (nonatomic,strong) UIButton *btnScore;//成绩查询
@property (nonatomic,strong) UIImageView *testCardImg;
@property (nonatomic,strong) UIImageView *scoreImg;
@property (nonatomic,weak) id<orderFootViewDelegate>delegate;

@end
