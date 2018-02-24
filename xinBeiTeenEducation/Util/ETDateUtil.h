//
//  DateUtil.h
//  HaoZu
//
//  Created by omiyang on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETDateUtil : NSObject

+ (NSString *)current;
+ (NSString *)currentYear;
+ (NSString *)yearBefore:(int)before;
+ (NSString *)currentMonth;
+ (NSString *)currentDay;
+ (NSString *)currentHour;
+ (NSString *)currentMins;
+ (NSString *)currentSec;
+ (NSString *)todayWithFormat:(NSString *)format;

+ (NSString *)stringToString:(NSString *)str from:(NSString *)from to:(NSString *)to;
+ (NSString *)numOfWeek:(NSDate *)date;

+ (NSString *)timeIntervalToString;

+ (NSDate *)numberToDate:(NSNumber *)number;

+ (NSDate *)timeToDate:(NSString *)time;

+ (NSString *)timeToDataString:(NSString *)time format:(NSString *)format;

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format;

+ (NSDate *)stringToDate:(NSString *)string format:(NSString *)format;

+ (NSString *)intervalSinceNow:(NSString *)strDate; //转换时间是今天、昨天、前天、三天前

+ (NSInteger)componentsFrom:(NSDate *)fromData toData:(NSDate *)toData type:(NSUInteger)calendarUnit;

+ (NSInteger)birthdayToAge:(NSString *)birthday;

+ (NSInteger)birthdayToAge:(NSString *)birthday format:(NSString *)format;

+ (NSString *)onlyShowMonthAndDayIntervalSinceNow:(NSString *)strDate;

+ (NSString *)getDateAfterToday:(NSInteger)day;

+ (NSString *)getWeekAfterToday:(NSInteger)day;

+ (NSString *)getWeekByTime:(NSInteger)time;
@end
