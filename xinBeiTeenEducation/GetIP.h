//
//  GetIP.h
//  TalkShow
//
//  Created by Acadsoc on 16/2/26.
//  Copyright (c) 2016年 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@interface GetIP : NSObject

+(NSString *)getIPAddress;
+ (NSString *)getCurrentDeviceModel;
@end
