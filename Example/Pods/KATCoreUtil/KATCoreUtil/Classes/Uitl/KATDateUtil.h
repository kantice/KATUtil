//
//  KATDateUtil.h
//  KATFramework
//
//  Created by Kantice on 14-6-1.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//  日期时间工具
//  年格式 2014(int 4)
//  月格式 201405(int 6)
//  周格式 201425(int 6) (最后一周如果非完整周，则属于下一年的第一周)
//  日格式 20140528(int 8)
//  日期时间格式 201405282202010000(long long int 18)(yyyymmddHHMMSSssss)


#import <Foundation/Foundation.h>
#import "KATMacros.h"



typedef unsigned long long int KATDateTime;

#define DATE_BEGIN_YEAR 1970
#define DATE_BEGIN_MONTH 197001
#define DATE_BEGIN_DAY 19700101
#define DATE_BEGIN_TIME 197001010000000000
#define DATE_BEGIN_WEEKDAY 4
#define DATE_END_YEAR 9999
#define DATE_END_MONTH 999912
#define DATE_END_DAY 99991231
#define DATE_END_TIME 999912312359599999
#define DATE_ERROR -1
#define DATE_SAME 0


#define DATE_WEEKDAY_SUNDAY 0
#define DATE_WEEKDAY_MONDAY 1
#define DATE_WEEKDAY_TUESDAY 2
#define DATE_WEEKDAY_WEDNESDAY 3
#define DATE_WEEKDAY_THURSDAY 4
#define DATE_WEEKDAY_FRIDAY 5
#define DATE_WEEKDAY_SATURDAY 6

#define DATE_MONTH_JANUARY 1
#define DATE_MONTH_FEBRUARY 2
#define DATE_MONTH_MARCH 3
#define DATE_MONTH_APRIL 4
#define DATE_MONTH_MAY 5
#define DATE_MONTH_JUNE 6
#define DATE_MONTH_JULY 7
#define DATE_MONTH_AUGUST 8
#define DATE_MONTH_SEPTEMBER 9
#define DATE_MONTH_OCTOBER 10
#define DATE_MONTH_NOVEMBER 11
#define DATE_MONTH_DECEMBER 12

#define DATE_TIME_YEAR 100000000000000LL
#define DATE_TIME_MONTH 1000000000000LL
#define DATE_TIME_DAY 10000000000LL
#define DATE_TIME_HOUR 100000000LL
#define DATE_TIME_MINUTE 1000000LL
#define DATE_TIME_SECOND 10000LL




//时间间隔
typedef struct
{
    double days;
    double hours;
    double minutes;
    double seconds;
}KATTimeInterval;



@interface KATDateUtil : NSObject

#pragma mark - 类方法

///该年的天数
+ (int)daysInYear:(int)year;

///该月的天数
+ (int)daysInMonth:(int)month;

///该日在当年中的第几日
+ (int)daysPastInYear:(int)day;

///该日是星期几
+ (int)weekdayOnDay:(int)day;

///该年有几个星期，是否包含最后一个不完整的星期
+ (int)weeksInYear:(int)year includeLast:(BOOL)last;

///该日属于当年的第几个星期
+ (int)weeksPastInYear:(int)day;

///过去了几天
+ (int)daysPastFrom:(int)past to:(int)now;

///过去了几个星期
+ (int)weeksPastFrom:(int)past to:(int)now;

///当天属于哪个星期
+ (int)weekOnDay:(int)day;

///从NSDate中获取KATDateTime
+ (KATDateTime)dateTimeFromDate:(NSDate *)date;

///从KATDateTime中获取NSDate
+ (NSDate *)dateFromDateTime:(KATDateTime)dt;

///获取年
+ (int)yearFromDateTime:(KATDateTime)dt;

///获取月
+ (int)monthFromDateTime:(KATDateTime)dt;

///获取日
+ (int)dayFromDateTime:(KATDateTime)dt;

///获取时
+ (int)hourFromDateTime:(KATDateTime)dt;

///获取分
+ (int)minuteFromDateTime:(KATDateTime)dt;

///获取秒
+ (int)secondFromDateTime:(KATDateTime)dt;

///获取经过的时间(精确到0.0001秒)（从1970年开始）（以GMT为准，会有时区偏差）
+ (long long int)intervalSince1970FromDateTime:(KATDateTime)dt;

///获取格式化日期时间(yyyyMMddHHmmssSSSS)
+ (NSString *)stringWithDateTime:(KATDateTime)dt andFormatter:(NSString *)formatter;

///获取格式化日期时间(yyyyMMddHHmmssSSSS)
+ (NSString *)stringWithDate:(NSDate *)date andFormatter:(NSString *)formatter;

///判断是否为同一天
+ (BOOL)isSameWithDay1:(KATDateTime)dt1 andDay2:(KATDateTime)dt2;

///两个日期时间的毫秒差
+ (long long int)difMillisecondsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的秒差
+ (long long int)difSecondsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的分钟差
+ (long long int)difMinutesFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的小时差
+ (long long int)difHoursFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的日差
+ (long long int)difDaysFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的月差（以30天计算）
+ (long long int)difMonthsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的年差（以365天计算）
+ (long long int)difYearsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///两个日期时间的时间间隔
+ (KATTimeInterval)intervalFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime;

///某个日期时间到现在的时间间隔
+ (KATTimeInterval)intervalFromDateTime:(KATDateTime)dt;

///判断格式是否正确
+ (BOOL)isCorrectDateTime:(KATDateTime)dt;

///判断日期是否正确
+ (BOOL)isCorrectDay:(int)day;

///判断月份是否正确
+ (BOOL)isCorrectMonth:(int)month;

///判断年份是否正确
+ (BOOL)isCorrectYear:(int)year;

///判断星期是否正确
+ (BOOL)isCorrectWeek:(int)week;

///获取该月的最后一天
+ (int)lastDayInMonth:(int)month;

///获取下一个月的该天(如通过3月5日获取4月5日)
+ (int)nextMonthOnDay:(int)day;

///获取上一个月的该天(如通过3月5日获取2月5日)
+ (int)lastMonthOnDay:(int)day;

///获取该年的下一年(明年)
+ (int)nextYear:(int)year;

///获取该年的上一年(去年)
+ (int)lastYear:(int)year;

///获取该月的下一月(下月)
+ (int)nextMonth:(int)month;

///获取该月的上一月(上月)
+ (int)lastMonth:(int)month;

///获取该周的下一周(下周)
+ (int)nextWeek:(int)week;

///获取该周的上一周(上周)
+ (int)lastWeek:(int)week;

///获取该天的下一天(明天)
+ (int)tomorrow:(int)day;

///获取该天的上一天(昨天)
+ (int)yesterday:(int)day;

///获取下一周的该天(下一个7天)
+ (int)nextWeekOnDay:(int)day;

///获取上一周的该天(上一个7天)
+ (int)lastWeekOnDay:(int)day;

///获取该天几天后的日期
+ (int)theDayAfter:(int)days onDay:(int)day;

///获取该天几天前的日期
+ (int)theDayBefore:(int)days onDay:(int)day;

///获取该周的周日
+ (int)sundayOnWeek:(int)week;

///获取该周的周一
+ (int)mondayOnWeek:(int)week;

///获取该周的周二
+ (int)tuesdayOnWeek:(int)week;

///获取该周的周三
+ (int)wednesdayOnWeek:(int)week;

///获取该周的周四
+ (int)thursdayOnWeek:(int)week;

///获取该周的周五
+ (int)fridayOnWeek:(int)week;

///获取该周的周六
+ (int)saturdayOnWeek:(int)week;

///获取该周的周几
+ (int)weekday:(int)weekday onWeek:(int)week;

///获取该周所属的月份(按周日所在的月份算)
+ (int)monthOnWeek:(int)week;

///现在
+ (KATDateTime)now;

///今天
+ (int)today;

///本周
+ (int)thisWeek;

///本月
+ (int)thisMonth;

///今年
+ (int)thisYear;

///当前时间
+ (int)thisTime;

///是否为当月的最后一天
+ (BOOL)isLastDayInMonth:(int)day;

///简要日期时间
+ (NSString *)briefDateTime:(KATDateTime)dt;


@end
