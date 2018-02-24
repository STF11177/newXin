//
//  DateUtil.m
//  HaoZu
//
//  Created by omiyang on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ETDateUtil.h"
#import "ETRegularUtil.h"

@implementation ETDateUtil

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *)stringToString:(NSString *)str from:(NSString *)from to:(NSString *)to {
    if ([ETRegularUtil isEmptyString:str]) {
        return @"";
    }
    NSDate *date = [self stringToDate:str format:from];
    return [self dateToString:date format:to];
}

+ (NSDateFormatter *)dateFormat {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return format;
}
+ (NSString *)numOfWeek:(NSDate *)date {
    return [self dateToString:date format:@"E"];
}

+ (NSString *)current {
    return [self dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)currentSec {
    return [self dateToString:[NSDate date] format:@"ss"];
}

+ (NSString *)currentYear {
    return [self dateToString:[NSDate date] format:@"yyyy"];
}
+ (NSString *)yearBefore:(int)before {
    int current = [[self currentYear] intValue];
    return  [NSString stringWithFormat:@"%d", current-before];
}
+ (NSString *)currentMonth {
    return [self dateToString:[NSDate date] format:@"MM"];
}
+ (NSString *)currentDay {
    return [self dateToString:[NSDate date] format:@"dd"];
}
+ (NSString *)currentHour {
    return [self dateToString:[NSDate date] format:@"HH"];
}
+ (NSString *)currentMins {
    return [self dateToString:[NSDate date] format:@"mm"];
}
+ (NSString *)todayWithFormat:(NSString *)format {
    return [self dateToString:[NSDate date] format:format];
}

+ (NSString *)timeIntervalToString {
    int time = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d",time];
}

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format {
    
	NSDateFormatter *dateFormat = [self dateFormat];
	[dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

+ (NSDate *)stringToDate:(NSString *)string format:(NSString *)format {
    
	NSDateFormatter *dateFormat = [self dateFormat];
	[dateFormat setDateFormat:format];
    return [dateFormat dateFromString:string];
}

+ (NSDate *)numberToDate:(NSNumber *)number {
    return [NSDate dateWithTimeIntervalSince1970:[number intValue]];
}

+ (NSDate *)timeToDate:(NSString *)time {
    return [NSDate dateWithTimeIntervalSince1970:[time intValue]];
}

+ (NSString *)timeToDataString:(NSString *)time format:(NSString *)format {
    return [ETDateUtil dateToString:[ETDateUtil timeToDate:time] format:format];
}

+ (NSInteger)componentsFrom:(NSDate *)fromData toData:(NSDate *)toData type:(NSUInteger)calendarUnit {
    NSUInteger unitFlags = calendarUnit;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:fromData  toDate:toData  options:0];
    
    NSUInteger result = 0;
    switch (calendarUnit) {
        case NSCalendarUnitDay:
            result = [comps day];
            break;
        case NSCalendarUnitMonth:
            result = [comps month];
            break;
        case NSCalendarUnitMinute:
            result = [comps minute];
            break;
        case NSCalendarUnitSecond:
            result = [comps second];
            break;
        default:
            break;
    }
    return  result;
}

+ (NSString *)intervalSinceNow:(NSString *)strDate{
    NSDate *startDate = [self stringToDate:strDate format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate date];
    NSString *strDay=@"";
    NSInteger days = [self componentsFrom:startDate toData:endDate type:NSCalendarUnitDay];
    if (days==3) {
        strDay = @"三天前";
    }else if (days==2) {
        strDay = @"前天";
    }else if (days==1) {
        strDay = @"昨天";
    }else if (days==0) {
        strDay = @"今天";
    }
    else {
        strDay = [self dateToString:startDate format:@"yy-MM-dd"];
    }
    return strDay;
}



+ (NSInteger)birthdayToAge:(NSString *)birthday {
    if (birthday == nil || [birthday isEqual:[NSNull null]]) {
        return 0;
    }
    NSDate *now = [NSDate date];
    NSDate *birth = [self stringToDate:birthday format:@"yyyy-MM-dd HH:mm:ss"];

    NSTimeInterval time=[now timeIntervalSinceDate:birth];
    
    int age=((int)time)/(3600*24)/365;
    return age;
}

+ (NSInteger)birthdayToAge:(NSString *)birthday format:(NSString *)format
{
    if (birthday == nil || [birthday isEqual:[NSNull null]]) {
        return 0;
    }
    NSDate *now = [NSDate date];
    NSDate *birth = [self stringToDate:birthday format:format];
    
    NSTimeInterval time=[now timeIntervalSinceDate:birth];
    
    int age=((int)time)/(3600*24)/365;
    return age;
}


+ (NSString *)onlyShowMonthAndDayIntervalSinceNow:(NSString *)strDate{
    NSDate *startDate = [self stringToDate:strDate format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate date];
    
    NSTimeInterval secondsPerDay = 8 * 60 * 60;
    startDate = [startDate dateByAddingTimeInterval: -secondsPerDay];
    
    NSString *strDay=@"";
    NSInteger days = [self componentsFrom:startDate toData:endDate type:NSCalendarUnitDay];
    NSLog(@"days = %ld",(long)days);
    if (days >= 100) {
        strDay = @"三个月前";
    }else {
        strDay = [NSString stringWithFormat:@"%ld天前",(long)(days==0 ? 1:days)];
    }
    return strDay;
}

+ (NSString *)getDateAfterToday:(NSInteger)day {
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    time = time+day*86400;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: time];

    return [self dateToString:date format:@"MM/dd"];
}

+ (NSString *)getWeekAfterToday:(NSInteger)day{
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    time = time+day*86400;
    return [ETDateUtil getWeekByTime:time];
}

+ (NSString *)getWeekByTime:(NSInteger)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: time];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSCalendarUnitWeekOfYear| NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return nil;
            break;
    }
    return nil;
}
@end
