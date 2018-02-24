//
//  newVideoController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/10/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newVideoController : UIViewController

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *URLString;
@property (nonatomic,strong) NSString *from_uid;
@property (nonatomic,strong) NSString *taskId;

@property (nonatomic,strong) NSString *faceImage;//视频连接
@property (nonatomic,strong) NSString *videoImg;//视频封面图
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *fromStr;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *likeStatus;
@property (nonatomic,strong) NSString *collectStatus;
@property (nonatomic,strong) NSString *is4GOrNot;//刚进入这个界面的状态

@end
