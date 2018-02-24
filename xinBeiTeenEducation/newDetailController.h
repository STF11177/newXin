//
//  newDetailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newDetailController : UIViewController

@property (nonatomic,strong) NSString *taskId;
@property (nonatomic,strong) NSString *from_uid;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *faceImage;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *likeStatus;
@property (nonatomic,strong) NSString *collectStatus;

@property (nonatomic,strong) NSString *fromStr;

@end
