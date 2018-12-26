//
//  KATHttpRequest.h
//  KATFramework
//
//  Created by Kantice on 16/6/13.
//  Copyright © 2016年 KatApp. All rights reserved.
//  Http网络请求类，封装了URLConnection，异步请求的回调都在主线程中执行


#import <Foundation/Foundation.h>
#import "KATNetworkHeader.h"
#import "KATFileUtil.h"
#import "KATAppUtil.h"
#import "KATStringUtil.h"
#import "KATHashMap.h"
#import "KATHttpUtil.h"




@class KATHttpRequest;

//代理
@protocol KATHttpRequestDelegate <NSObject>

@optional

///

@end



@interface KATHttpRequest : NSObject


#pragma -mark 属性

///是否显示网络状态
@property(nonatomic,assign) BOOL showNetworkStatus;

///超时
@property(nonatomic,assign) double timeoutInterval;

///请求类型
@property(nonatomic,copy) NSString *contentType;

///缓存模式
@property(nonatomic,assign) int cacheMode;

///取消下载
@property(nonatomic,assign) BOOL downloadCanceled;

///http头属性
@property(nonatomic,retain) KATHashMap<NSString *> *headerFields;


#pragma -mark 响应内容

///响应的内容长度
@property(nonatomic,assign,readonly) long long contentLength;

///响应的数据类型
@property(nonatomic,copy,readonly) NSString *MIMEType;

///响应的URL
@property(nonatomic,retain,readonly) NSURL *responseURL;

///响应的Http头信息
@property(nonatomic,retain,readonly) KATHashMap *responseHeader;


///事件代理
@property(nonatomic,assign) id<KATHttpRequestDelegate> eventDelegate;


#pragma -mark 类方法

///获取实例
+ (instancetype)request;


#pragma -mark 对象方法


#pragma -mark 通用方法(一般不直接用)

///同步通用方法：地址、请求方式、返回的数据范围、发送的数据（Post）
- (NSData *)requestWithUrl:(NSString *)url method:(NSString *)method hasRange:(BOOL)hasRange rangeStart:(long long)start rangeEnd:(long long)end sendData:(NSData *)sendData;

///异步通用方法：地址、请求方式、返回的数据范围、发送的数据（Post）
- (void)requestWithUrl:(NSString *)url method:(NSString *)method hasRange:(BOOL)hasRange rangeStart:(long long)start rangeEnd:(long long)end sendData:(NSData *)sendData andandCallback:(void (^)(NSData *returnData))callback;


#pragma -mark GET请求

///用get请求方式获取数据（同步）
- (NSData *)getDataWithUrl:(NSString *)url;

///用get请求方式获取文本（同步）
- (NSString *)getTextWithUrl:(NSString *)url;

///用get请求方式获取数据（异步）
- (void)getDataWithUrl:(NSString *)url andCallback:(void (^)(NSData *returnData))callback;

///用get请求方式获取文本（异步）
- (void)getTextWithUrl:(NSString *)url andCallback:(void (^)(NSString *returnText))callback;


#pragma -mark POST请求

///用post请求方式发送数据，获取数据（同步）
- (NSData *)postDataWithUrl:(NSString *)url andSendData:(NSData *)data;

///用post请求方式发送文本，获取数据（同步）
- (NSData *)postDataWithUrl:(NSString *)url andSendText:(NSString *)text;

///用post请求方式发送数据，获取文本（同步）
- (NSString *)postTextWithUrl:(NSString *)url andSendData:(NSData *)data;

///用post请求方式发送文本，获取文本（同步）
- (NSString *)postTextWithUrl:(NSString *)url andSendText:(NSString *)text;

///用post请求方式发送数据，获取数据（异步）
- (void)postDataWithUrl:(NSString *)url andSendData:(NSData *)data andCallback:(void (^)(NSData *returnData))callback;

///用post请求方式发送文本，获取数据（异步）
- (void)postDataWithUrl:(NSString *)url andSendText:(NSString *)text andCallback:(void (^)(NSData *returnData))callback;

///用post请求方式发送数据，获取文本（异步）
- (void)postTextWithUrl:(NSString *)url andSendData:(NSData *)data andCallback:(void (^)(NSString *returnText))callback;

///用post请求方式发送文本，获取文本（异步）
- (void)postTextWithUrl:(NSString *)url andSendText:(NSString *)text andCallback:(void (^)(NSString *returnText))callback;


#pragma -mark 表单提交

///提交表单，获取数据（同步）
- (NSData *)postDataWithUrl:(NSString *)url andForm:(KATHashMap *)form;

///提交表单，获取文本（同步）
- (NSString *)postTextWithUrl:(NSString *)url andForm:(KATHashMap *)form;

///提交表单，获取数据（异步）
- (void)postDataWithUrl:(NSString *)url andForm:(KATHashMap *)form andCallback:(void (^)(NSData *returnData))callback;

///提交表单，获取文本（异步）
- (void)postTextWithUrl:(NSString *)url andForm:(KATHashMap *)form andCallback:(void (^)(NSString *returnText))callback;


#pragma -mark HEAD请求

///请求Http头信息（同步）
- (void)headWithUrl:(NSString *)url;

///请求Http头信息（异步）
- (void)headWithUrl:(NSString *)url andCallback:(void (^)(void))callback;


#pragma -mark 下载

///下载文件到指定的目录（适合小型文件），判断是否替换原文件(同步)
- (BOOL)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable append:(BOOL)append;

///下载文件到指定的目录（适合小型文件），判断是否替换原文件(异步)
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable append:(BOOL)append andCallback:(void (^)(BOOL success))callback;

///下载文件到指定目录(分块下载)，支持断点续传，指定每块数据大小，显示下载进度（适合大文件）（不能替换文件）（异步）
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url blockSize:(long long)blockSize andCallback:(void (^)(long long currentSize,long long totalSize,int status))callback;

///取消下载(只针对分块下载)
- (void)cancelDownload;


#pragma -mark 上传

///上传文件，设置表单属性名称（同步）
- (NSData *)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name;

///上传文件，设置表单属性名称（异步）
- (void)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name andCallback:(void (^)(NSData *returnData))callback;




///释放内存
- (void)dealloc;


@end
