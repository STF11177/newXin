////
////  BaseManager.m
////  Anjuke
////
////  Created by lh liu on 11-10-24.
////  Copyright (c) 2011年 anjuke. All rights reserved.
////
//
//#import "BaseModel.h"
//#import "AppDelegate.h"
//#import "CommonAlert.h"
//#import "AFNetworking.h"
//#import "AFHTTPSessionManager.h"
////#import "LocalCityData.h"
//
//@implementation BaseModel{
//    AFHTTPSessionManager *manager;
//    
//}
//
//@synthesize delegate = _delegate;
//
//- (id)initWithDelegate:(id)delegate {
//    self = [self init];
//    if (self) {
//        self.delegate = delegate;
//        manager = [AFHTTPSessionManager manager];
//        
//    }
//    return self;
//}
//
//
//
//- (NSString *)getPrefix {
//    NSString *prefix;
//#ifdef DEBUG
//    prefix = URL_PREFIX;
//#else
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePathUtil getPathFromDocument:@"apiPrefix.txt"]]) {
//        prefix = [NSString stringWithContentsOfFile:[FilePathUtil getPathFromDocument:@"apiPrefix.txt"] encoding:NSUTF8StringEncoding error:nil];
//    }
//    else {
//        prefix = URL_PREFIX;
//    }
//#endif
//    return prefix;
//}
//
//#pragma mark - Create Get Request
//
//- (NSString *)createRequsetApi:(NSString *)api withParam:(NSDictionary *)param{
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[self getPrefix],api];
//    
//    if (param != nil) {
//        NSString *paramStr = [self createParam:param];
//        urlStr = [urlStr stringByAppendingString:paramStr];
//    }
//    
//    return urlStr;
//}
//
//
//- (void)createRequest:(NSString *)api withParam:(NSDictionary *)param success:(void (^)(id responseObject))success
//              failure:(void (^)(NSError *error))failure{
//    
//    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:param];
////    if ([AppDataCenter didMemberLogin]) {
//////        MemberData *member = [AppDataCenter getLoginMember];
////        [defaultParam setValue:member.token forKey:@"token"];
////    }
//    
//    param = defaultParam;
//    NSString *url = [self createRequsetApi:api withParam:param];
//    NSLog(@"request:%@", url);
//
////    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        success(responseObject);
////        
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        failure(error);
////    }];
//    
//}
//
//- (void)createRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel {
//    //添加了两个默认传的参数
//    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:param];
////    if ([AppDataCenter didMemberLogin]) {
////        MemberData *member = [AppDataCenter getLoginMember];
////        [defaultParam setValue:member.token forKey:@"token"];
////    }
//    param = defaultParam;
//    
//    
//    NSString *url = [self createRequsetApi:api withParam:param];
//    DLog(@"request:%@",url);
//    
////    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        if ([self respondsToSelector:finishSel]) {
////            SuppressPerformSelectorLeakWarning(
////                                               [self performSelector:finishSel withObject:responseObject];
////                                               );
////        }
////        if ([self isRequestSuccess:responseObject]) {
////            [self performSelector:finishSel onTarget:self.delegate];
////        }
////        else {
////            [self sendFailedToSelector:failSel withError:[self getErrorWithResponseObject:responseObject]];
////        }
////        
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        if ([self respondsToSelector:failSel]) {
////            SuppressPerformSelectorLeakWarning(
////                                               [self performSelector:failSel withObject:[self getError:error]];
////                                               );
////        }
////        [self sendFailedToSelector:failSel withError:[self getError:error]];
////    }];
//    
//}
//
//- (void)createRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel dataObj:(NSString *)dataObj{
//    //添加了两个默认传的参数
//    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:param];
////    if ([AppDataCenter didMemberLogin]) {
////        MemberData *member = [AppDataCenter getLoginMember];
////        [defaultParam setValue:member.token forKey:@"token"];
////    }
//    param = defaultParam;
//    
//    NSString *url = [self createRequsetApi:api withParam:param];
//    DLog(@"request:%@",url);
//    
////    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        if ([self respondsToSelector:finishSel]) {
////            SuppressPerformSelectorLeakWarning([self performSelector:finishSel withObject:responseObject];);
////        }
////        if ([self isRequestSuccess:responseObject]) {
////            id data =  [responseObject objectForKey:@"data"];
////            if ([data isKindOfClass:[NSArray class]]) {
////                [self performSelector:finishSel onTarget:self.delegate withObject:[self getData:responseObject class:dataObj]];
////            }else{
////                [self performSelector:finishSel onTarget:self.delegate withObject:[self getData:data class:dataObj]];
////            }
////        }
////        else {
////            [self sendFailedToSelector:failSel withError:[self getErrorWithResponseObject:responseObject]];
////        }
////        
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        if ([self respondsToSelector:failSel]) {
////            SuppressPerformSelectorLeakWarning([self performSelector:failSel withObject:[self getError:error]];);
////        }
////        [self sendFailedToSelector:failSel withError:[self getError:error]];
////        
////    }];
//    
//}
//
//
//
//- (NSString *)signForRequestParams:(NSDictionary *)params {
//    if (params && ![params isKindOfClass:[NSDictionary class]]) {
//        return @"";
//    }
//    
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:params];
//    
//    NSArray *keys = [paramsDict allKeys];
//    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
//    
//    NSMutableString *beforeEncode = [NSMutableString string];
//    for (NSString *key in keys) {
//        if (![[NSNull null] isEqual:[params objectForKey:key]] &&
//            ![@"" isEqualToString:[params objectForKey:key]] &&
//            ![@"debug" isEqualToString:key] &&
//            ![@"ver" isEqualToString:key])
//            [beforeEncode appendFormat:@"%@%@",key,[paramsDict objectForKey:key]];
//    }
//    NSString *result = [[NSString stringWithFormat:@"baba%@yuyue", beforeEncode ] md5];
//    
//    return result;
//}
//
//- (NSString *)createParam:(NSDictionary *)param {
//    NSMutableArray *conditions = [NSMutableArray array];
//    if (param != nil) {
//        NSArray *key = [param allKeys];
//        for (NSString *k in key) {
//            NSObject *value = [param objectForKey:k];
//            NSString *condition;
//            if ([value isKindOfClass:[NSString class]]) {
//                condition = [NSString stringWithFormat:@"%@=%@",k,[(NSString *)value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            }
//            else {
//                condition = [NSString stringWithFormat:@"%@=%@",k,value];
//            }
//            [conditions addObject:condition];
//        }
//    }
//    
//    //    [conditions addObject:[NSString stringWithFormat:@"sign=%@",[self signForRequestParams:param]]];
//#ifdef DEBUG
//    [conditions addObject:@"debug=1"];
//#endif
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *appVersion;
//    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
//    if (marketingVersionNumber && developmentVersionNumber) {
//        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
//            appVersion = marketingVersionNumber;
//        } else {
//            appVersion = [NSString stringWithFormat:@"%@,%@",marketingVersionNumber,developmentVersionNumber];
//        }
//    } else {
//        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
//    }
//    [conditions addObject:[NSString stringWithFormat:@"ver=%@",appVersion]];
//    
//    if (conditions.count>0) {
//        return [NSString stringWithFormat:@"?%@",[conditions componentsJoinedByString:@"&"]];
//    }
//    else {
//        return @"";
//    }
//}
//
//
//
//- (BOOL)isRequestSuccess:(NSDictionary *)result {
//    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (NSString *)getRequestFailReason:(NSDictionary *)result {
//    if ([[result objectForKey:@"result"] isEqualToString:@"error"]) {
//        return [result objectForKey:@"data"];
//    }
//    return @"";
//}
//
//#pragma mark - Create Post Request
//
//- (NSString *)createPostRequsetApi:(NSString *)api withParam:(NSDictionary *)param{
//    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *appVersion;
//    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
//    if (marketingVersionNumber && developmentVersionNumber) {
//        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
//            appVersion = marketingVersionNumber;
//        } else {
//            appVersion = [NSString stringWithFormat:@"%@,%@",marketingVersionNumber,developmentVersionNumber];
//        }
//    } else {
//        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
//    }
//    
//    NSString *appIdentify = [bundle bundleIdentifier];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@?sign=%@&ver=%@&app=%@",[self getPrefix],api, [self signForRequestParams:param],appVersion,appIdentify];
//    
//    return urlStr;
//}
//
//
//- (void)createPostRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel {
//    //添加了两个默认传的参数
////    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:param];
////    if ([AppDataCenter didMemberLogin]) {
////        MemberData *member = [AppDataCenter getLoginMember];
////        [defaultParam setValue:member.token forKey:@"token"];
////    }
////    param = defaultParam;
////    
////    NSString *url = [self createPostRequsetApi:api withParam:param];
////    DLog(@"request:%@ param:%@", url, param);
////    
////    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        if ([self respondsToSelector:finishSel]) {
////            SuppressPerformSelectorLeakWarning(
////                                               [self performSelector:finishSel withObject:responseObject];
////                                               );
////        }
////        if ([self isRequestSuccess:responseObject]) {
////            [self performSelector:finishSel onTarget:self.delegate];
////        }
////        else {
////            [self sendFailedToSelector:failSel withError:[self getErrorWithResponseObject:responseObject]];
////        }
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        if ([self respondsToSelector:failSel]) {
////            SuppressPerformSelectorLeakWarning(
////                                               [self performSelector:failSel withObject:[self getError:error]];
////                                               );
////        }
////        [self sendFailedToSelector:failSel withError:[self getError:error]];
////        
////    }];
//}
//
////- (void)createPostRequest:(NSString *)api withParam:(NSDictionary *)param finishSel:(SEL)finishSel failSel:(SEL)failSel dataObj:(NSString *)dataObj{
////    
////    //添加了两个默认传的参数
////    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:param];
//////    if ([AppDataCenter didMemberLogin]) {
//////        MemberData *member = [AppDataCenter getLoginMember];
//////        [defaultParam setValue:member.token forKey:@"token"];
//////    }
////    param = defaultParam;
////    NSString *url = [self createPostRequsetApi:api withParam:param];
////    
////    
////    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
////        
////        DLog(@"request:%@ param:%@", url, param);
////        if ([self respondsToSelector:finishSel]) {
////            SuppressPerformSelectorLeakWarning(
////                                               [self performSelector:finishSel withObject:responseObject];
////                                               );
////        }
////        
////        if ([self isRequestSuccess:responseObject]) {
////            id data =  [responseObject objectForKey:@"data"];
////            if ([data isKindOfClass:[NSArray class]]) {
////                [self performSelector:finishSel onTarget:self.delegate withObject:[self getData:responseObject class:dataObj]];
////            }else{
////                [self performSelector:finishSel onTarget:self.delegate withObject:[self getData:data class:dataObj]];
////            }
////        }
////        else {
////            [self sendFailedToSelector:failSel withError:[self getErrorWithResponseObject:responseObject]];
////        }
////        
////    } failure:^(NSURLSessionDataTask *task, NSError *error) {
////        
////        if ([self respondsToSelector:failSel]) {
////            SuppressPerformSelectorLeakWarning(
////                                               [self performSelector:failSel withObject:[self getError:error]];
////                                               );
////        }
////        [self sendFailedToSelector:failSel withError:[self getError:error]];
////    }];
////    
////}
//
//
//- (void)createPostRequest:(NSString *)api withParam:(NSDictionary *)param withImageDatas:(NSArray *)images finishSel:(SEL)finishSel failSel:(SEL)failSel dataObj:(NSString *)dataObj{
//    
//    //添加了两个默认传的参数
////    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:param];
////    if ([AppDataCenter didMemberLogin]) {
////        MemberData *member = [AppDataCenter getLoginMember];
////        [defaultParam setValue:member.token forKey:@"token"];
////    }
////    param = defaultParam;
////    NSString *url = [self createPostRequsetApi:api withParam:param];
//    
////    [manager POST:url parameters:param
////constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
////    
////    for (NSArray *proptys in images){
////        
////        NSString *fileName;
////        NSString *contentType;
////        NSString *type = [proptys lastObject];
////        NSData *data = [proptys firstObject];
////        
////        fileName = [NSString stringWithFormat:@"upload.%@",type];
////        contentType = [NSString stringWithFormat:@"image/%@",type];
////        [formData appendPartWithFileData:data name:@"file[]" fileName:fileName mimeType:contentType];
////    }
////}
////         progress:^(NSProgress * _Nonnull uploadProgress) {
////             
////         }
////          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////              DLog(@"request:%@ param:%@", url, param);
////              if ([self respondsToSelector:finishSel]) {
////                  SuppressPerformSelectorLeakWarning(
////                                                     [self performSelector:finishSel withObject:responseObject];
////                                                     );
////              }
////          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////              if ([self respondsToSelector:failSel]) {
////                  SuppressPerformSelectorLeakWarning(
////                                                     [self performSelector:failSel withObject:[self getError:error]];
////                                                     );
////              }
////              [self sendFailedToSelector:failSel withError:[self getError:error]];
////              
////          }];
//
//}
//
//
//
//
//- (id)getData:(id)data class:(NSString *)className{
//    return [ETDataTransUtil getData:data class:className];
//}
//
////- (ErrorData *)getError:(NSError *)error {
////    ErrorData *errorData = nil;
////    if (error&&error!=NULL) {
////        errorData= [[ErrorData alloc] init];
////        errorData.code = [NSString stringWithFormat:@"%ld",(long)error.code];
////        errorData.error = error.domain;
////        errorData.message = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
////    }else{
////        errorData= [[ErrorData alloc] init];
////        errorData.code = @"100";
////        errorData.error = @"REQUEST FAILED";
////        errorData.message = @"目前网络不给力";
////    }
////    return  errorData;
////}
//
////- (ErrorData *)getErrorWithResponseObject:(id)responseObject {
////    ErrorData *error = nil;
////    if (responseObject&&responseObject!=NULL) {
////        error = [self getData:[responseObject objectForKey:@"error"] class:@"ErrorData"];
////        if([@"1017" isEqualToString:error.code]){
////            
////            CommonAlert *alert = [[CommonAlert alloc]initWithMessage:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") withBtnTitles:@[@"马上登录"]];
////            alert.delegate = self;
////            [[UIApplication sharedApplication].keyWindow addSubview:alert];
////        }
////    }
////    if (error == nil) {
////        error = [[ErrorData alloc] init];
////        error.code = @"100";
////        error.error = @"REQUEST FAILED";
////        error.message = @"目前网络不给力";
////    }
////    return  error;
////}
//
//-(void)itemCertain:(CommonAlert *)alert{
//    [alert removeFromSuperview];
////    [AppDataCenter memberLogout];
////    [[AppDelegate sharedInstance] showLogin];
//}
//
//
//- (void)sendData:(id)data toSel:(SEL)selector withClass:(NSString *)className{
//    id d = [self getData:data class:className];
//    [self performSelector:selector onTarget:self.delegate withObject:d];
//}
//
////- (void)sendFailedToSelector:(SEL)selector withError:(ErrorData *)error{
////    
////    [self performSelector:selector onTarget:self.delegate  withObject:error];
////}
//
//- (void)saveDataToLocal:(ETBaseData *)data forKey:(NSString *)key {
//    NSString *string = [data toJson];
//    [string writeToFile:[FilePathUtil getPathFromDocument:key] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//}
//
////- (id)getDataFromLocalWithClass:(NSString *)className forKey:(NSString *)key {
////    NSString *string = [NSString stringWithContentsOfFile:[FilePathUtil getPathFromDocument:key] encoding:NSUTF8StringEncoding error:nil];
////    return [self getData:[string JSONValue] class:className];
////}
//
//- (void)cancelAllOperations {
//    self.delegate = nil;
////    [manager.operationQueue cancelAllOperations];
//}
//
//- (void)dealloc {
////    [manager.operationQueue cancelAllOperations];
////    manager = nil;
//    self.delegate = nil;
//}
//
//@end
