//
//  KATDateUtil.m
//  KATFramework
//
//  Created by Kantice on 14-6-1.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//

#import "KATDateUtil.h"

@implementation KATDateUtil

//该年的天数
+ (int)daysInYear:(int)year
{
	if(year<DATE_BEGIN_YEAR || year>DATE_END_YEAR)
	{
		return DATE_ERROR;
	}
	
	if((year%4==0&&year%100!=0)||year%400==0)//判断是否为闰年
	{
		return 366;
	}
	else
	{
		return 365;
	}
}


//该月的天数
+ (int)daysInMonth:(int)month
{
	if(month<DATE_BEGIN_MONTH || month>DATE_END_MONTH)
	{
		return DATE_ERROR;
	}
	
	int year=month/100;//年
	month=month%100;//月
	
	switch(month)
	{
		case 1:
			
            return 31;
            
        case 2:
			
            if((year%4==0&&year%100!=0)||year%400==0)//判断是否为闰年
            {
                return 29;
            }
            else
            {
                return 28;
            }
            
        case 3:
            
            return 31;
            
        case 4:
            
            return 30;
            
        case 5:
            
            return 31;
            
        case 6:
            
            return 30;
            
        case 7:
            
            return 31;
            
        case 8:
            
            return 31;
            
        case 9:
            
            return 30;
            
        case 10:
            
            return 31;
            
        case 11:
            
            return 30;
            
        case 12:
            
            return 31;
			
        default:
            
            return DATE_ERROR;
	}
}


//该日在当年中的第几日
+ (int)daysPastInYear:(int)day
{
	if(day<DATE_BEGIN_DAY || day>DATE_END_DAY)
	{
		return DATE_ERROR;
	}
	
	int year=day/10000;
	int month=day/100%100;
	day=day%100;
	
	int leap=0;//闰年标记
	
	if((year%4==0&&year%100!=0)||year%400==0)//判断是否为闰年
	{
		leap=1;
	}
	
	switch(month)
	{
		case 1:
			
            if(day>=1&&day<=31)
            {
                return day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 2:
            
            if(day>=1&&day<=28+leap)
            {
                return 31+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 3:
            
            if(day>=1&&day<=31)
            {
                return 31+28+leap+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 4:
            
            if(day>=1&&day<=30)
            {
                return 31+28+leap+31+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 5:
            
            if(day>=1&&day<=31)
            {
                return 31+28+leap+31+30+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 6:
            
            if(day>=1&&day<=30)
            {
                return 31+28+leap+31+30+31+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 7:
            
            if(day>=1&&day<=31)
            {
                return 31+28+leap+31+30+31+30+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 8:
            
            if(day>=1&&day<=31)
            {
                return 31+28+leap+31+30+31+30+31+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 9:
            
            if(day>=1&&day<=30)
            {
                return 31+28+leap+31+30+31+30+31+31+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 10:
            
            if(day>=1&&day<=31)
            {
                return 31+28+leap+31+30+31+30+31+31+30+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 11:
            
            if(day>=1&&day<=30)
            {
                return 31+28+leap+31+30+31+30+31+31+30+31+day;
            }
            else
            {
                return DATE_ERROR;
            }
            
        case 12:
            
            if(day>=1&&day<=31)
            {
                return 31+28+leap+31+30+31+30+31+31+30+31+30+day;
            }
            else
            {
                return DATE_ERROR;
            }
			
        default:
            return DATE_ERROR;
	}
}


//过去了几天
+ (int)daysPastFrom:(int)past to:(int)now
{
	if(past<DATE_BEGIN_DAY || past>DATE_END_DAY || past<DATE_BEGIN_DAY || past>DATE_END_DAY || past>now)
	{
		return DATE_ERROR;
	}
	
	if(past==now)
	{
		return DATE_SAME;
	}
	
	int py=past/10000;//过去年
	int ny=now/10000;//现在年
	
	if([self daysPastInYear:past]>0 && [self daysPastInYear:now]>0)//判断格式
	{
		int days=[self daysPastInYear:now]-[self daysPastInYear:past];
		
		for(int i=py;i<ny;i++)
		{
			days+=[self daysInYear:i];
		}
		
		return days;
	}
	else
	{
		return DATE_ERROR;
	}
}


//该日是星期几
+ (int)weekdayOnDay:(int)day
{
	if(day<DATE_BEGIN_DAY || day>DATE_END_DAY)
	{
		return DATE_ERROR;
	}
	
	int pds=[self daysPastFrom:DATE_BEGIN_DAY to:day];//过去的天数
	
	if(pds>=0)
	{
		return (pds+DATE_BEGIN_WEEKDAY)%7;
	}
	else//格式错误
	{
		return DATE_ERROR;
	}
}


//该年有几个星期
+ (int)weeksInYear:(int)year includeLast:(BOOL)last
{
	if(year<DATE_BEGIN_YEAR || year>DATE_END_YEAR)
	{
		return DATE_ERROR;
	}
	
	if((year%4==0&&year%100!=0)||year%400==0)//判断是否为闰年
	{
		if([self weekdayOnDay:year*10000+101]==6)//闰年且第一天为周六
		{
            if(last)
            {
                return 54;
            }
            else
            {
                return 53;
            }
		}
		else
		{
            if(last)
            {
                return 53;
            }
			else
            {
                if([self weekdayOnDay:year*10000+1231]==6)//该年最后一天为周六
                {
                    return 53;
                }
                else
                {
                    return 52;
                }
            }
		}
	}
	else
	{
		if(last)
        {
            return 53;
        }
        else
        {
            if([self weekdayOnDay:year*10000+1231]==6)//该年最后一天为周六
            {
                return 53;
            }
            else
            {
                return 52;
            }
        }

	}
}


//该日属于当年的第几个星期
+ (int)weeksPastInYear:(int)day
{
	if(day<DATE_BEGIN_DAY || day>DATE_END_DAY)
	{
		return DATE_ERROR;
	}
	
	int pds=[self daysPastInYear:day];//该年的第几天
	
	if(pds>=0)//格式正确
	{
		int firstWeekday=[self weekdayOnDay:day/10000*10000+101];//该年第一天（1月1日）是周几
		
		return (pds+firstWeekday-1)/7+1;
	}
	else
	{
		return DATE_ERROR;
	}
}


//过去了几个星期
+ (int)weeksPastFrom:(int)past to:(int)now
{
	if(past<DATE_BEGIN_DAY || past>DATE_END_DAY || past<DATE_BEGIN_DAY || past>DATE_END_DAY || past>now)
	{
		return DATE_ERROR;
	}
	
	int pds=[self daysPastFrom:past to:now];//相隔的天数
	
	if(pds>=0)//格式正确
	{
		int pastWeekday=[self weekdayOnDay:past];//过去那天是周几
		
		return (pds+pastWeekday)/7;
	}
	else
	{
		return DATE_ERROR;
	}
}


//当天属于哪个星期
+ (int)weekOnDay:(int) day
{
    if(day<DATE_BEGIN_DAY || day>DATE_END_DAY)
	{
		return DATE_ERROR;
	}
    
    if([self weeksPastInYear:day]>[self weeksInYear:day/10000 includeLast:NO])//如果是当年最后一个不完整的星期，则归到下年第一个星期
    {
        return (day/10000+1)*100+1;
    }
    else
    {
        return day/10000*100+[self weeksPastInYear:day];
    }
}


//从NSDate中获取KATTime
+ (KATDateTime)dateTimeFromDate:(NSDate *)date
{
    if(!date)
    {
        return -1;
    }
    
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
    
    return [[dateFormatter stringFromDate:date] longLongValue];
}


//从KATDateTime中获取NSDate
+ (NSDate *)dateFromDateTime:(KATDateTime)dt
{    
    double interval=[self intervalSince1970FromDateTime:dt]/10000+dt%10000*0.0001;

    return [NSDate dateWithTimeIntervalSince1970:interval];
}


//获取经过的时间(精确到0.0001秒)（从1970年开始）
+ (long long int)intervalSince1970FromDateTime:(KATDateTime)dt
{
    //获取年份
    int year=[self yearFromDateTime:dt];
    
    if(year>=1970)//大于1970年的时间
    {
        long long int interval=0;
        
        //计算整年
        for(int i=1970;i<year;i++)
        {
            int days=[self daysInYear:i];
            
            interval+=days*24LL*60*60*DATE_TIME_SECOND;
        }
        
        int month=[self monthFromDateTime:dt];
        
        //计算当年的月数
        for(int i=1;i<month;i++)
        {
            int days=[self daysInMonth:year*100+i];
            
            interval+=days*24LL*60*60*DATE_TIME_SECOND;
        }
        
        //计算当月的天数
        for(int i=1;i<[self dayFromDateTime:dt];i++)
        {
            interval+=24L*60*60*DATE_TIME_SECOND;
        }
        
        //计算当日的小时
        for(int i=0;i<[self hourFromDateTime:dt];i++)
        {
            interval+=60*60*DATE_TIME_SECOND;
        }
        
        //计算小时的分钟数
        for(int i=0;i<[self minuteFromDateTime:dt];i++)
        {
            interval+=60*DATE_TIME_SECOND;
        }
        
        //计算分钟的秒数
        for(int i=0;i<[self secondFromDateTime:dt];i++)
        {
            interval+=DATE_TIME_SECOND;
        }
        
        //时区差
        interval-=[NSTimeZone systemTimeZone].secondsFromGMT*DATE_TIME_SECOND;//时区差
        
        //计算最后的毫秒数
        interval+=dt%10000;
        
        return interval;
    }
    else
    {
        return -1;
    }
}


//获取年
+ (int)yearFromDateTime:(KATDateTime)dt
{
    return dt/100000000000000;
}


//获取月
+ (int)monthFromDateTime:(KATDateTime)dt
{
    return dt/1000000000000%100;
}


//获取日
+ (int)dayFromDateTime:(KATDateTime)dt
{
    return dt/10000000000%100;
}


//获取时
+ (int)hourFromDateTime:(KATDateTime)dt
{
    return dt/100000000%100;
}


//获取分
+ (int)minuteFromDateTime:(KATDateTime)dt
{
    return dt/1000000%100;
}


//获取秒
+ (int)secondFromDateTime:(KATDateTime)dt
{
    return dt/10000%100;
}


//获取格式化日期时间(yyyyMMddHHmmssSSSS)
+ (NSString *)stringWithDateTime:(KATDateTime)dt andFormatter:(NSString *)formatter
{
    if(![self isCorrectDateTime:dt] || !formatter)
    {
        return nil;
    }
    
    NSDate *date=[self dateFromDateTime:dt];

    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:date];
}


//获取格式化日期时间(yyyyMMddHHmmssSSSS)
+ (NSString *)stringWithDate:(NSDate *)date andFormatter:(NSString *)formatter
{
    if(!date || !formatter)
    {
        return nil;
    }
    
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:date];
}


//判断是否为同一天
+ (BOOL)isSameWithDay1:(KATDateTime)dt1 andDay2:(KATDateTime)dt2
{
    if(dt1/10000000000 == dt2/10000000000)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//两个日期时间的毫秒差
+ (long long int)difMillisecondsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10;
}


//两个日期时间的秒差
+ (long long int)difSecondsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10/1000;
}


//两个日期时间的分钟差
+ (long long int)difMinutesFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10/1000/60;
}


//两个日期时间的小时差
+ (long long int)difHoursFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10/1000/60/60;
}


//两个日期时间的日差
+ (long long int)difDaysFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10/1000/60/60/24;
}


//两个日期时间的月差（以30天计算）
+ (long long int)difMonthsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10/1000/60/60/24/30;
}


//两个日期时间的年差（以365天计算）
+ (long long int)difYearsFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    return dif/10/1000/60/60/24/365;
}


//两个日期时间的时间间隔
+ (KATTimeInterval)intervalFromTime:(KATDateTime)fTime toTime:(KATDateTime)tTime
{
    KATTimeInterval interval;
    
    //初始化
    interval.days=0;
    interval.hours=0;
    interval.minutes=0;
    interval.seconds=0;
    
    //获取时间差
    long long int dif=[self intervalSince1970FromDateTime:tTime]-[self intervalSince1970FromDateTime:fTime];
    
    //计算
    interval.seconds=dif*0.0001;
    interval.minutes=interval.seconds/60.0;
    interval.hours=interval.minutes/60.0;
    interval.days=interval.hours/24.0;
    
    return interval;
}


//某个日期时间到现在的时间间隔
+ (KATTimeInterval)intervalFromDateTime:(KATDateTime)dt
{
    return [self intervalFromTime:dt toTime:[self now]];
}



//判断格式是否正确
+ (BOOL)isCorrectDateTime:(KATDateTime)dt
{
    //判断月
    int month=[KATDateUtil monthFromDateTime:dt];
    
    if(month<1 || month>12)
    {
        return NO;
    }
    
    
    //判断日
    int day=[KATDateUtil dayFromDateTime:dt];
    
    //年月
    int ym=dt/1000000000000;
    int days=[self daysInMonth:ym];
    
    if(day<1 || day>days)
    {
        return NO;
    }
    
    
    //判断小时
    int hour=[KATDateUtil hourFromDateTime:dt];
    
    if(hour<0 || hour>23)
    {
        return NO;
    }
    
    
    //判断分钟
    int minute=[KATDateUtil minuteFromDateTime:dt];
    
    if(minute<0 || minute>59)
    {
        return NO;
    }
    
    
    //判断秒
    int second=[KATDateUtil secondFromDateTime:dt];
    
    if(second<0 || second>59)
    {
        return NO;
    }
    
    
    return YES;
}



//判断日期是否正确
+ (BOOL)isCorrectDay:(int)day
{
    if([self isCorrectMonth:day/100])
    {
        int d=day%100;
        
        int days=[self daysInMonth:day/100];
        
        if(d>=1 && d<=days)
        {
            return YES;
        }
    }
    
    return NO;
}


//判断月份是否正确
+ (BOOL)isCorrectMonth:(int)month
{
    if([self isCorrectYear:month/100])
    {
        int m=month%100;
        
        if(m>=1 && m<=12)
        {
            return YES;
        }
    }
    
    return NO;
}


//判断年份是否正确
+ (BOOL)isCorrectYear:(int)year
{
    if(year<DATE_BEGIN_YEAR || year>DATE_END_YEAR)
    {
        return NO;
    }
    
    return YES;
}


//判断星期是否正确
+ (BOOL)isCorrectWeek:(int)week
{
    if([self isCorrectYear:week/100])
    {
        int w=week%100;
        
        if(w>=1 && w<=[self weeksInYear:week/100 includeLast:NO])
        {
            return YES;
        }
    }
    
    return NO;
}


//获取该月的最后一天
+ (int)lastDayInMonth:(int)month
{
    if([self isCorrectMonth:month])
    {
        return month*100+[self daysInMonth:month];
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取下一个月的该天(如通过3月5日获取4月5日)
+ (int)nextMonthOnDay:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        if(m==12)
        {
            m=1;
            y++;
        }
        else
        {
            m++;
        }
        
        if(d>[self daysInMonth:y*100+m])
        {
            d=[self daysInMonth:y*100+m];
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取上一个月的该天(如通过3月5日获取2月5日)
+ (int)lastMonthOnDay:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        if(m==1)
        {
            m=12;
            y--;
        }
        else
        {
            m--;
        }
        
        if(d>[self daysInMonth:y*100+m])
        {
            d=[self daysInMonth:y*100+m];
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}



//获取该年的下一年(明年)
+ (int)nextYear:(int)year
{
    year++;
    
    if([self isCorrectYear:year])
    {
        return year;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该年的上一年(去年)
+ (int)lastYear:(int)year
{
    year--;
    
    if([self isCorrectYear:year])
    {
        return year;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该月的下一月(下月)
+ (int)nextMonth:(int)month
{
    if(![self isCorrectMonth:month])
    {
        return DATE_ERROR;
    }
    
    month++;
    
    if(month%100>12)
    {
        month=(month/100+1)*100+1;
    }
    
    if([self isCorrectMonth:month])
    {
        return month;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该月的上一月(上月)
+ (int)lastMonth:(int)month
{
    if(![self isCorrectMonth:month])
    {
        return DATE_ERROR;
    }
    
    month--;
    
    if(month%100<1)
    {
        month=(month/100-1)*100+12;
    }
    
    if([self isCorrectMonth:month])
    {
        return month;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该周的下一周(下周)
+ (int)nextWeek:(int)week
{
    if(![self isCorrectWeek:week])
    {
        return DATE_ERROR;
    }
    
    week++;
    
    if(week%100>[self weeksInYear:week/100 includeLast:NO])
    {
        week=(week/100+1)*100+1;
    }
    
    if([self isCorrectWeek:week])
    {
        return week;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该周的上一周(上周)
+ (int)lastWeek:(int)week
{
    if(![self isCorrectWeek:week])
    {
        return DATE_ERROR;
    }
    
    week--;
    
    if(week%100<1)
    {
        week=(week/100-1)*100+[self weeksInYear:week/100-1 includeLast:NO];
    }
    
    if([self isCorrectWeek:week])
    {
        return week;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该天的下一天(明天)
+ (int)tomorrow:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        d++;
        
        if(d>[self daysInMonth:y*100+m])
        {
            d=1;
            
            m++;
            
            if(m>12)
            {
                m=1;
                
                y++;
            }
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该天的上一天(昨天)
+ (int)yesterday:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        d--;
        
        if(d<1)
        {
            m--;
            
            if(m<1)
            {
                m=12;
                
                y--;
            }
            
            d=[self daysInMonth:y*100+m];
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取下一周的该天(下一个7天)
+ (int)nextWeekOnDay:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        d+=7;
        
        if(d>[self daysInMonth:y*100+m])
        {
            d-=[self daysInMonth:y*100+m];
            
            m++;
            
            if(m>12)
            {
                m=1;
                
                y++;
            }
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取上一周的该天(上一个7天)
+ (int)lastWeekOnDay:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        d-=7;
        
        if(d<1)
        {
            m--;
            
            if(m<1)
            {
                m=12;
                
                y--;
            }
            
            d+=[self daysInMonth:y*100+m];
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该天几天后的日期
+ (int)theDayAfter:(int)days onDay:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        d+=days;
        
        while(d>[self daysInMonth:y*100+m])
        {
            d-=[self daysInMonth:y*100+m];
            
            m++;
            
            if(m>12)
            {
                m=1;
                
                y++;
            }

        }

        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }
}


//获取该天几天前的日期
+ (int)theDayBefore:(int)days onDay:(int)day
{
    if([self isCorrectDay:day])
    {
        int d=day%100;
        int m=day/100%100;
        int y=day/10000;
        
        d-=days;
        
        while(d<1)
        {
            m--;
            
            if(m<1)
            {
                m=12;
                
                y--;
            }
            
            d+=[self daysInMonth:y*100+m];
        }
        
        return y*10000+m*100+d;
    }
    else
    {
        return DATE_ERROR;
    }

}


//获取该周的周日
+ (int)sundayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_SUNDAY onWeek:week];
}


//获取该周的周一
+ (int)mondayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_MONDAY onWeek:week];
}


//获取该周的周二
+ (int)tuesdayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_TUESDAY onWeek:week];
}


//获取该周的周三
+ (int)wednesdayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_WEDNESDAY onWeek:week];
}


//获取该周的周四
+ (int)thursdayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_THURSDAY onWeek:week];
}


//获取该周的周五
+ (int)fridayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_FRIDAY onWeek:week];
}


//获取该周的周六
+ (int)saturdayOnWeek:(int)week
{
    return [self weekday:DATE_WEEKDAY_SATURDAY onWeek:week];
}


//获取该周的周几
+ (int)weekday:(int)weekday onWeek:(int)week
{
    if(weekday<DATE_WEEKDAY_SUNDAY || weekday>DATE_WEEKDAY_SATURDAY)
    {
        return DATE_ERROR;
    }
    
    if([self isCorrectWeek:week])
    {
        int wd=[self weekdayOnDay:week/100*10000+101];
        
        int dif=weekday+7*(week%100-1)-wd;
        
        if(dif>=0)
        {
            return [self theDayAfter:dif onDay:week/100*10000+101];
        }
        else
        {
            return [self theDayBefore:-dif onDay:week/100*10000+101];
        }
    }
    
    return DATE_ERROR;
}


//获取该周所属的月份(按周日所在的月份算)
+ (int)monthOnWeek:(int)week
{
    if([self isCorrectWeek:week])
    {
        int day=[self sundayOnWeek:week];
        
        return day/100;
    }
    
    return DATE_ERROR;
}


//现在
+ (KATDateTime)now
{
    return [self dateTimeFromDate:[NSDate date]];
}


//今天
+ (int)today
{
    return [self now]/DATE_TIME_DAY;
}


//本周
+ (int)thisWeek
{
    return [self weekOnDay:[self today]];
}


//本月
+ (int)thisMonth
{
    return [self now]/DATE_TIME_MONTH;
}


//今年
+ (int)thisYear
{
    return [self now]/DATE_TIME_YEAR;
}


//当前时间
+ (int)thisTime
{
    return [self now]%DATE_TIME_DAY/DATE_TIME_SECOND;
}


///是否为当月的最后一天
+ (BOOL)isLastDayInMonth:(int)day
{
    if([self isCorrectDay:day])
    {
        if(day%100==[self daysInMonth:day/100])
        {
            return YES;
        }
    }
        
    return NO;
}


//简要日期时间
+ (NSString *)briefDateTime:(KATDateTime)dt
{
    if([self isCorrectDateTime:dt])
    {
        KATDateTime now=[self now];
        
        
        //秒差(60秒内)
        long long difS=[self difSecondsFromTime:dt toTime:now];
        
        if(difS<60)
        {
            if(LANGUAGE_CH)
            {
                return [NSString stringWithFormat:@"%lli秒前",difS];
            }
            
            if(LANGUAGE_CHT)
            {
                return [NSString stringWithFormat:@"%lli秒前",difS];
            }
            
            if(LANGUAGE_JA)
            {
                return [NSString stringWithFormat:@"%lli秒前",difS];
            }
            
            if(difS<=1)
            {
                return [NSString stringWithFormat:@"%lli second ago",difS];
            }
            else
            {
                return [NSString stringWithFormat:@"%lli seconds ago",difS];
            }
        }
        
        
        //分差(60分钟内)
        long long difM=[self difMinutesFromTime:dt toTime:now];
        
        if(difM<60)
        {
            if(LANGUAGE_CH)
            {
                return [NSString stringWithFormat:@"%lli分钟前",difM];
            }
            
            if(LANGUAGE_CHT)
            {
                return [NSString stringWithFormat:@"%lli分鐘前",difM];
            }
            
            if(LANGUAGE_JA)
            {
                return [NSString stringWithFormat:@"%lli分前",difM];
            }
            
            if(difM<=1)
            {
                return [NSString stringWithFormat:@"%lli minute ago",difM];
            }
            else
            {
                return [NSString stringWithFormat:@"%lli minutes ago",difM];
            }
        }
        
        
        //时差(12小时内)
        //分差(60分钟内)
        long long difH=[self difHoursFromTime:dt toTime:now];
        
        if(difH<12)
        {
            if(LANGUAGE_CH)
            {
                return [NSString stringWithFormat:@"%lli小時前",difH];
            }
            
            if(LANGUAGE_CHT)
            {
                return [NSString stringWithFormat:@"%lli小時前",difH];
            }
            
            if(LANGUAGE_JA)
            {
                return [NSString stringWithFormat:@"%lli時間前",difH];
            }
            
            if(difH<=1)
            {
                return [NSString stringWithFormat:@"%lli hour ago",difH];
            }
            else
            {
                return [NSString stringWithFormat:@"%lli hours ago",difH];
            }
        }

        
        //正常日期时间
        return [self stringWithDateTime:dt andFormatter:@"yyyy/MM/dd HH:mm:ss.SSS"];
    }
    
    return nil;
}



@end


