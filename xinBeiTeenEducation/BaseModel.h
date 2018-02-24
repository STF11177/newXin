////
////  BaseManager.h
////  Anjuke
////
////  Created by lh liu on 11-10-24.
////  Copyright (c) 2011年 anjuke. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "ETDataTransUtil.h"
//#import "ETBaseData.h"
//#import "FilePathUtil.h"
//#import "ResultData.h"
//
//#ifdef RELEASE
//    #ifdef DEBUG
//        #define URL_PREFIX_INDEX @"http://api-yueye.uduoo.com"
//    #else
//        #define URL_PREFIX_INDEX @"http://api-yueye.uduoo.com"
//    #endif
//#else
//    #define URL_PREFIX_INDEX @"http://api-yueye.uduoo.com"
//#endif
//#define URL_PREFIX  [NSString stringWithFormat:@"%@/a1/",URL_PREFIX_INDEX]
//
//
//@interface BaseModel : NSObject<UIAlertViewDelegate>
//
//@property (nonatomic, weak) id delegate;
//@property (nonatomic, assign) BOOL noCity;
//
//- (id)initWithDelegate:(id)delegate;
//
//#pragma mark - Create GET Request
//- (void)createRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel;
//- (void)createRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel dataObj:(NSString *)dataObj;
//
//#pragma mark - Create POST Request
//- (void)createRequest:(NSString *)api withParam:(NSDictionary *)param success:(void (^)(id responseObject))success
//              failure:(void (^)(NSError *error))failure;
//
//- (void)createPostRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel;
//- (void)createPostRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel dataObj:(NSString *)dataObj;
//- (void)createPostRequest:(NSString *)api withParam:(NSDictionary *)param withImageDatas:(NSArray *)images finishSel:(SEL)finishSel failSel:(SEL)failSel dataObj:(NSString *)dataObj;
//- (NSString *)getRequestFailReason:(NSDictionary *)result;
//- (BOOL)isRequestSuccess:(NSDictionary *)result;
//
//- (id)getData:(id)data class:(NSString *)className;
////- (ErrorData *)getError:(NSError *)error;
////- (ErrorData *)getErrorWithResponseObject:(id)responseObject;
//
//- (void)sendData:(id)data toSel:(SEL)selector withClass:(NSString *)className;
////- (void)sendFailedToSelector:(SEL)selector withError:(ErrorData *)error;
//
//- (void)saveDataToLocal:(ETBaseData *)data forKey:(NSString *)key;
////- (id)getDataFromLocalWithClass:(NSString *)className forKey:(NSString *)key;
//
//- (void)cancelAllOperations;
//@end
