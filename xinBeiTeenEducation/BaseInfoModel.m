////
////  BaseInfoModel.m
////  Carcool
////
////  Created by yizheming on 15/8/23.
////  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
////
//
//#import "BaseInfoModel.h"
//@implementation BaseInfoModel
//
//#pragma  mark - 从服务器获取环信信息
//
//- (void)getEaseMobInfoWitParmas:(NSDictionary *)params{
////    
////    [self createRequest:@"/chat/get_hx"
////              withParam:params
////              finishSel:@selector(getEaseMobInfoSucc:)
////                failSel:@selector(getEaseMobInfoFail:)
////                dataObj:@"EaseMobResultData"];
//}
//
//#pragma  mark - 更新用户信息数据
//
//-(void)checkUpdateUserInfoWithParams:(NSDictionary *)params{
//    
////    [self createRequest:@"user/update"
////              withParam:params
////              finishSel:@selector(updateUserInfoSucc)
////                failSel:@selector(updateUserInfoFail:)
////     ];
//    
//}
//
//
//#pragma  mark - 更新用户位置
////用户持续性更新当前位置
//- (void)keepUpdateUserLocationWithParams:(NSDictionary *)params{
//
////    [self createRequest:@"user/user_locate"
////              withParam:params
////              finishSel:@selector(keepUpdateLocationSucc)
////                failSel:@selector(keepUpdateLocationFail:)
////     ];
//
//}
//
//
//#pragma  mark - 获取城市列表数据
////获取城市基础数据
//-(void)getCityListFromServer{
//    
////    [self createRequest:@"common/get_city"
////              withParam:nil
////              finishSel:@selector(getCityListSucc:)
////                failSel:@selector(getCityListFail:)
////                dataObj:@"CityResultData"];
//    
//}
//
//////本地获取城市列表
////- (NSMutableArray *)getCityListFromLocal{
////    NSString *filePath = [FilePathUtil getPathFromAnyWhere:@"citylist.txt"];
////    NSString *dataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
////    NSDictionary *jsonObject = [dataStr JSONValue];
////    
////    if ([jsonObject isKindOfClass:[NSDictionary class]]){
////        
////        CityResultData *result = [ETDataTransUtil getData:jsonObject class:@"CityResultData"];
////        NSMutableArray *pickerData = [NSMutableArray array];
////        
////        ETPickerData *province = nil;
////        ETPickerData *city = nil;
////        ETPickerData *area = nil;
////        for (CityData *provinceData in result.data) {
////            province = [[ETPickerData alloc] initWithKey:provinceData.cityId value:provinceData.cityName];
////            for(CityData *cityData in provinceData.childrenArray){
////                city = [[ETPickerData alloc] initWithKey:cityData.cityId value:cityData.cityName];
////                [province.subData safelyAddObject:city];
////                for(CityData *areaData in cityData.childrenArray){
////                    area = [[ETPickerData alloc] initWithKey:areaData.cityId value:areaData.cityName];
////                    [city.subData safelyAddObject:area];
////                }
////            }
////            
////            [pickerData addObject:province];
////        }
////        
////        return pickerData;
////    }
////    return nil;
////}
//
////
//////获取城市名称
////- (NSArray *)getCityNameByRegionId:(NSString *)regionId withCityId:(NSString *)cityId{
////
////    NSMutableArray *province = [self getCityListFromLocal];
////    ETPickerData *pickProv = nil;
////    ETPickerData *pickCity = nil;
////    for (ETPickerData* prov in province) {
////        if ([regionId isEqualToString:prov.key]) {
////            pickProv = prov;
////            for (ETPickerData *city in prov.subData) {
////                if ([cityId isEqualToString:city.key]) {
////                    pickCity= city;
////                }
////            }
////        }
////    }
////
////    if (![ETRegularUtil isEmptyString:pickProv.value]&&![ETRegularUtil isEmptyString:pickCity.value]) {
////        return @[pickProv.value,pickCity.value];
////    }
//
////    return nil;
////}
//
//
////版本检查
////-(void)checkVersion{
////    NSMutableDictionary *params = [NSMutableDictionary dictionary];
////    [params setValue:@"1" forKey:@"platform"];
////    
////    [self createRequest:@"common/version"
////              withParam:params
////              finishSel:@selector(checkVersionSucc:)
////                failSel:@selector(checkVersionFail:)
////                dataObj:@"VersionData"];
////    
////}
////
//////用户离开应用
////-(void)applicationChangeStatusOffLine{
////    [self createRequest:@"user/user_goes_offline"
////              withParam:nil
////              finishSel:@selector(changeOffLineSucc:)
////                failSel:@selector(changeOffLineFail:)
////                dataObj:@"ResultData"];
////}
//
//@end
