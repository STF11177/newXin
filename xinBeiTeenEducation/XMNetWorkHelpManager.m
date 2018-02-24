//
//  XMNetWorkHelpManager.m
//  DingdingTravel_IOS
//
//  Created by chming on 2017/3/14.
//  Copyright © 2017年 RanQingwen. All rights reserved.
//

#import "XMNetWorkHelpManager.h"
#import "JDStatusBarNotification.h"
#import "AFNetworking.h"

#define XMNSNotification [NSNotificationCenter defaultCenter]
@implementation XMNetWorkHelpManager
+(instancetype)sharedManager
{
    static XMNetWorkHelpManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance netWorkStatus];
    });
    return sharedInstance;
}

-(void)netWorkStatus
{
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [self dismissJDStatus];
                if (self.isFirstStart == YES ) {
                    self.isFirstStart = NO;
                [XMNSNotification postNotificationName:@"notificationNetWorkbreup" object:nil];
                    if (self.BlockNetWorkType) {
                        self.BlockNetWorkType(@"网络未知");
                    }
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
//             [self showStatusBarErrorStr:@"网络连接似乎断开了，请检查"];
               [XMNSNotification postNotificationName:@"notificationNetWorkbreup" object:nil];
                if (self.isFirstStart == YES) {
                    self.isFirstStart = NO;
                    if (self.BlockNetWorkType) {
                        self.BlockNetWorkType(@"网络断开");
                    }
                    [self dismissJDStatus];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                [self dismissJDStatus];
                [XMNSNotification postNotificationName:@"notificationNetWork" object:nil];
               
                if (self.isFirstStart == YES) {
                    self.isFirstStart = NO;
                    if (self.BlockNetWorkType) {
                        self.BlockNetWorkType(@"3G或者4G");
                    }
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                 [self showStatusBarErrorStr:@"网络连接"];
                if (self.isFirstStart == YES) {
                    self.isFirstStart = NO;
                    if (self.BlockNetWorkType) {
                        self.BlockNetWorkType(@"WiFi");
                    }
                }
                self.netWorkTypeStr = @"WiFi" ;
//                [self dismissJDStatus];
                [XMNSNotification postNotificationName:@"notificationNetWorkWifi" object:nil];
                
                break;
            default:
                break;
        }
    }];
    
    [manger startMonitoring];
}

- (void)showStatusBarErrorStr:(NSString *)errorStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:errorStr dismissAfter:3 styleName:JDStatusBarStyleError];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:errorStr dismissAfter:CGFLOAT_MAX styleName:JDStatusBarStyleError];
    }
}

-(void)dismissJDStatus
{
    if ([JDStatusBarNotification isVisible]) {
        
        [JDStatusBarNotification dismiss];
        
    }
}



@end
