//
//  XMNetWorkHelpManager.h
//  DingdingTravel_IOS
//
//  Created by chming on 2017/3/14.
//  Copyright © 2017年 RanQingwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMNetWorkHelpManager : NSObject

@property (strong, nonatomic) NSString *netWorkTypeStr; 
/**
 *  启动时候的
 */
@property (assign, nonatomic) BOOL isFirstStart ;

@property (copy, nonatomic) void(^BlockNetWorkType)(NSString *blockNetWorkType);

+(instancetype)sharedManager;




@end
