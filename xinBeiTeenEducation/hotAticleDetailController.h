//
//  hotAticleDetailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hotAticleDetailController : UIViewController

@property (nonatomic,strong) NSString *taskId;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *faceImage;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *from_uid;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *likeStatus;
@property (nonatomic,strong) NSString *collectStatus;

@property (nonatomic,strong) NSString *fromHotAticle;//从热文点击进去

@end
