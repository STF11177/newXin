//
//  AppDelegate.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ETTabBarController *tabBarController;

+ (AppDelegate *)sharedInstance;

@end

