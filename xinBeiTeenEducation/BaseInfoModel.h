////
////  BaseInfoModel.h
////  Carcool
////
////  Created by yizheming on 15/8/23.
////  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
////
//
//#import "BaseModel.h"
////#import "ETPickerData.h"
////#import "CityResultData.h"
////#import "VersionData.h"
////#import "EaseMobResultData.h"
//
//@interface BaseInfoModel : BaseModel
//
////从服务器获取环信信息
//- (void)getEaseMobInfoWitParmas:(NSDictionary *)params;
//
////从服务器获取城市数据
//- (void)getCityListFromServer;
//
////从本地获取城市数据
//- (NSMutableArray *)getCityListFromLocal;
//
//////根据id查询城市数据
////- (NSArray *)getCityNameByRegionId:(NSString *)regionId withCityId:(NSString *)cityId;
//
////获取用户的更新信息
//- (void)checkUpdateUserInfoWithParams:(NSDictionary *)params;
//
////用户持续性更新当前位置
//- (void)keepUpdateUserLocationWithParams:(NSDictionary *)params;
//
////用户离开应用
//-(void)applicationChangeStatusOffLine;
//
////版本检查
//-(void)checkVersion;
//
//@end
//
//@protocol BaseInfoModelDelegate <NSObject>
//@optional
//
////- (void)getEaseMobInfoSucc:(EaseMobResultData*)result;
////- (void)getEaseMobInfoFail:(ErrorData *)error;
//
////- (void)getCityListSucc:(CityResultData *)result;
////- (void)getCityListFail:(ErrorData *)error;
//
//- (void)updateUserInfoSucc;
////- (void)updateUserInfoFail:(ErrorData *)error;
//
//- (void)keepUpdateLocationSucc;
////- (void)keepUpdateLocationFail:(ErrorData *)error;
//
////- (void)checkVersionSucc:(VersionData *)version;
////- (void)checkVersionFail:(ErrorData *)error;
//
//- (void)changeOffLineSucc:(ResultData *)result;
////- (void)changeOffLineFail:(ErrorData *)error;
//
//@end
