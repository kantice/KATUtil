//
//  KATHttpSession.h
//  KATFramework
//
//  Created by Kantice on 16/7/22.
//  Copyright © 2016年 KatApp. All rights reserved.
//  封装了NSURLSession类，用于管理KATHttpTask对象(后台会话应为单例)

#import <Foundation/Foundation.h>
#import "KATHttpTask.h"
#import "KATArray.h"



#define SESSION_TYPE_DEFAULT 0
#define SESSION_TYPE_EPHEMERAL 1
#define SESSION_TYPE_BACKGROUND 2

#define SESSION_TIMEOUT_DEFAULT 10.0
#define SESSION_HOST_CONNECTION_MAX 10
#define SESSION_BACKGROUND_ID @"kat.library.session.bgid"




@class KATHttpSession;

//代理
@protocol KATHttpSessionDelegate <NSObject>

@optional

///会话终止
- (void)sessionDidInvalid:(KATHttpSession *)session;

///会话后台任务完成
- (void)sessionDidFinishBackgroundTasks:(KATHttpSession *)session;

@end



@interface KATHttpSession : NSObject <NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>


#pragma -mark 属性

///内部操作的session
@property(nonatomic,retain) NSURLSession *session;

///管理的task数组
@property(nonatomic,retain) KATArray<KATHttpTask *> *tasks;

///事件代理
@property(nonatomic,assign) id<KATHttpSessionDelegate> eventDelegate;


#pragma -mark 类方法

///通过配置获取实例
+ (instancetype)sessionWithType:(int)type andConfig:(NSURLSessionConfiguration *)config delegateQueue:(NSOperationQueue *)queue;

///通过参数获取实例
+ (instancetype)sessionWithType:(int)type andCacheMode:(int)cacheMode timeout:(double)timeout cellularAccess:(BOOL)cellularAccess delegateQueue:(NSOperationQueue *)queue;

///获取默认的实例(代理线程队列为主线程队列)
+ (instancetype)sessionWithType:(int)type;


#pragma -mark 对象方法

///失效（失效后不能再使用该会话）
- (void)invalidate;


///释放内存
- (void)dealloc;


@end


