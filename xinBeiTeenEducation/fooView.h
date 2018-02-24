//
//  fooView.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "footButton.h"

@class fooView;

@protocol footViewDelegate <NSObject>

//-(void)onCollect;//收藏
//-(void)onComment;//评论
//-(void)onShare;//分享

- (void)onComment;
- (void)onLike;
- (void)onShare;

@end

@interface fooView : UIView

@property (nonatomic,strong)footButton *btnComment;//评论
@property (nonatomic,strong)footButton *btnLike;//点赞
@property (nonatomic,strong)footButton *btnShare;//分享
@property (nonatomic, weak) id<footViewDelegate>delegate;

@end
