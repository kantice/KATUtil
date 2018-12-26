//
//  KATTimer.m
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATTimer.h"

@implementation KATTimer


#pragma mark - 类方法

//构造函数
+ (instancetype)timer
{
    return [[[self alloc] init] autorelease];
}


//构造函数，带开始时间参数
+ (instancetype)timerWithStart:(NSDate *)startTime
{
    KATTimer *timer=[self timer];
    timer.start=startTime;
    
    return timer;
}


//初始化
- (instancetype)init
{
    self=[super init];
    
    self.start=nil;
    self.end=nil;
    self.pauseTime=nil;
    self.resumeTime=nil;
    self.pauseDif=0;
    self.dif=0;
    
    return self;
}


#pragma mark - 对象方法

//重新开始记时
- (void)restart
{
    self.end=nil;
    self.pauseTime=nil;
    self.resumeTime=nil;
    self.pauseDif=0;
    self.dif=0;
    
    self.start=[NSDate date];
}


//结束记时
- (void)stop
{
    self.end=[NSDate date];
    
    if(_start)
    {
        _dif=[_end timeIntervalSinceDate:_start];
    }
    else
    {
        _dif=0;
    }
}


//暂停计时
- (void)pause
{
    self.pauseTime=[NSDate date];
}


//取消暂停
- (void)resume
{
    self.resumeTime=[NSDate date];
    
    if(_pauseTime)
    {
        _pauseDif+=[_resumeTime timeIntervalSinceDate:_pauseTime];
    }
    else
    {
        _pauseDif+=0;
    }
}



//返回时间差（小时）
- (int)difHour
{
    if((_dif-_pauseDif)>=0)
    {
        return (int)(_dif-_pauseDif)/3600;
    }
    else
    {
        return -1;
    }
}


//返回时间差（分钟）
- (int)difMin
{
    if((_dif-_pauseDif)>=0)
    {
        return (((int)(_dif-_pauseDif))%3600)/60;
    }
    else
    {
        return -1;
    }
}


//返回时间差（秒）
- (int)difSec
{
    if((_dif-_pauseDif)>=0)
    {
        return (((int)(_dif-_pauseDif)))%60;
    }
    else
    {
        return -1;
    }
    
}


//返回时间差（毫秒）
- (int)difMils
{
    if((_dif-_pauseDif)>=0)
    {
        return ((int)((_dif-_pauseDif)*10000))%10000;
    }
    else
    {
        return -1;
    }
    
}


//返回时间差（时分秒)
- (NSString *)difTime
{
//    return [NSString stringWithFormat:@"%i h %02i m %02i s",[self difHour],[self difMin],[self difSec]];
    return [NSString stringWithFormat:@"%02i:%02i:%02i",[self difHour],[self difMin],[self difSec]];
}


//返回时间差（时分秒毫秒）
- (NSString *)difTimes
{
    return [NSString stringWithFormat:@"%i h %02i m %02i s %04i",[self difHour],[self difMin],[self difSec],[self difMils]];
}


//释放内存
- (void)dealloc
{
    self.start=nil;
    self.end=nil;
    self.pauseTime=nil;
    self.resumeTime=nil;
    
    [super dealloc];
}

@end

