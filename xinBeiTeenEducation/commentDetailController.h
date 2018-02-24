//
//  commentDetailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contentImageController.h"
#import "appListController.h"

@protocol commentDetailDelegate <NSObject>

-(void)selectStr:(NSString *)str;

@end

@interface commentDetailController : UIViewController

@property (nonatomic,strong) NSString *commentTaskId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *biaojiStr;//从详情进入
@property (nonatomic,strong) NSString *userComStatus;//是自己，还是回复

@property (nonatomic,strong) NSString *nickStr;
@property (nonatomic,strong) NSString *remarkStr;
@property (nonatomic,strong) NSString *commentStr;
@property (nonatomic,strong) NSString *fromUser;
@property (nonatomic,strong) NSString *taskStr;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *from_uid;

@property (nonatomic,strong) NSString *fromParent;//从家长圈进入
@property (nonatomic,weak) id<commentDetailDelegate>delegate;
@property (nonatomic,strong) NSString *signStr;//标记

@end
