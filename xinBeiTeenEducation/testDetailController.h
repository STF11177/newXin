//
//  testDetailController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/6/30.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testDetailController : UIViewController

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *taskId;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *pictureImg;//图片
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *contentStr;

@end
