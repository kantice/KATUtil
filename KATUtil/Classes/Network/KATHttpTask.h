//
//  KATHttpTask.h
//  KATFramework
//
//  Created by Kantice on 16/7/21.
//  Copyright © 2016年 KatApp. All rights reserved.
//  基于SessionTask的网络连接类，使用默认的session或与KATHttpSession配合使用，全部采用异步方法

#import <Foundation/Foundation.h>
#import "KATNetworkHeader.h"
#import "KATFileUtil.h"
#import "KATAppUtil.h"
#import "KATStringUtil.h"
#import "KATHttpUtil.h"



#define TASK_TYPE_NONE 0
#define TASK_TYPE_DATA 1
#define TASK_TYPE_UPLOAD 2
#define TASK_TYPE_DOWNLOAD 3


@class KATHttpSession;
@class KATHttpTask;

//代理
@protocol KATHttpTaskDelegate <NSObject>

@optional

///任务完成
- (void)task:(KATHttpTask *)task didFinishSucceed:(BOOL)succeed;

///下载任务完成
- (void)task:(KATHttpTask *)task didFinishDownloadSucceed:(BOOL)succeed;

///下载任务完成进度
- (void)task:(KATHttpTask *)task didDownloadData:(long long)download withTotalData:(long long)total;

///数据任务获取到数据
- (void)task:(KATHttpTask *)task didReceiveData:(NSData *)data;

@end




@interface KATHttpTask : NSObject

#pragma -mark 属性

///携带的标签
@property(nonatomic,assign) long long tag;

///携带的消息
@property(nonatomic,copy) NSString *message;

///是否显示网络状态
@property(nonatomic,assign) BOOL showNetworkStatus;

///超时
@property(nonatomic,assign) double timeoutInterval;

///请求类型
@property(nonatomic,copy) NSString *contentType;

///缓存模式
@property(nonatomic,assign) int cacheMode;

///当前执行的任务
@property(nonatomic,retain) NSURLSessionTask *task;

///task的类型
@property(nonatomic,assign) int type;

///下载的文件路径
@property(nonatomic,copy) NSString *downloadPath;

///http头属性
@property(nonatomic,retain) KATHashMap<NSString *> *headerFields;

///管理的会话
@property(nonatomic,assign) KATHttpSession *session;

///事件代理
@property(nonatomic,assign) id<KATHttpTaskDelegate> eventDelegate;


#pragma -mark 类方法

///获取实例
+ (instancetype)task;


#pragma -mark 对象方法

///用get请求方式获取数据（默认的全局Session）
- (void)getWithUrl:(NSString *)url andCallback:(void (^)(NSData *returnData))callback;

///用post请求方式发送数据，获取数据（默认的全局Session）
- (void)postWithUrl:(NSString *)url sendData:(NSData *)data andCallback:(void (^)(NSData *returnData))callback;

///下载文件到指定的目录，判断是否替换原文件（默认的全局Session）
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable andCallback:(void (^)(BOOL success))callback;

///上传文件，设置表单属性名称（默认的全局Session）
- (void)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name andCallback:(void (^)(NSData *returnData))callback;

///用get请求方式获取数据（指定的Session，用代理回调）
- (void)getWithUrl:(NSString *)url andSession:(KATHttpSession *)session;

///用post请求方式发送数据，获取数据（指定的Session，用代理回调）
- (void)postWithUrl:(NSString *)url sendData:(NSData *)data andSession:(KATHttpSession *)session;

///下载文件到指定的目录，判断是否替换原文件（指定的Session，用代理回调）
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable andSession:(KATHttpSession *)session;

///上传文件，设置表单属性名称（指定的Session，用代理回调）
- (void)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name andSession:(KATHttpSession *)session;

///继续
- (void)resume;

///取消
- (void)cancel;

///挂起
- (void)suspend;


///释放内存
- (void)dealloc;


@end



