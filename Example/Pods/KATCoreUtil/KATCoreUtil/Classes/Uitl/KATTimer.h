//
//  KATTimer.h
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  计时器类

#import <Foundation/Foundation.h>

@interface KATTimer : NSObject

#pragma mark - 属性

///时间差
@property(nonatomic) double dif;

///暂停时间差
@property(nonatomic) double pauseDif;

///开始时间
@property(nonatomic,retain) NSDate *start;

///结束时间
@property(nonatomic,retain) NSDate *end;

///暂停时间
@property(nonatomic,retain) NSDate *pauseTime;

///恢复时间
@property(nonatomic,retain) NSDate *resumeTime;


#pragma mark - 类方法

///构造函数(重新开始记时)
+ (instancetype)timer;

///构造函数(从一个已有时间开始记时)
+ (instancetype)timerWithStart:(NSDate *) startTime;


#pragma mark - 对象方法

///重新开始记时
- (void)restart;

///结束记时
- (void)stop;

///暂停
- (void)pause;

///恢复
- (void)resume;

///返回时间差（小时）
- (int)difHour;

///返回时间差（分钟）
- (int)difMin;

///返回时间差（秒）
- (int)difSec;

///返回时间差（毫秒）
- (int)difMils;

///返回时间差（时分秒）
- (NSString *)difTime;

///返回时间差（时分秒毫秒）
- (NSString *)difTimes;


///释放内存
- (void)dealloc;


@end


