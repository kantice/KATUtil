//
//  KATHttpUtil.h
//  KATFramework
//
//  Created by Kantice on 13-11-28.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  通过http协议访问网络的工具类，非异步执行，访问网络的方法都可用KATHttpRequest代替，该类主要用于操作cookie、识别MIMEType及简单的网络访问。



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KATNetworkHeader.h"
#import "KATFileUtil.h"
#import "KATStringUtil.h"
#import "KATArray.h"
#import "KATReachability.h"



@interface KATHttpUtil : NSObject



#pragma mark - 类方法


///Post方式发送字符串，返回字符串
+ (NSString *)postText:(NSString *)text toHost:(NSString *)host andAddress:(NSString *)address;

///Get方式访问，返回字符串
+ (NSString *)getText:(NSString *)params toHost:(NSString *)host andAddress:(NSString *)address;

///下载文件到指定的目录
+ (BOOL)downloadFile:(NSString *)file fromHost:(NSString *)host andAddress:(NSString *)address;

///Post方式发送字符串，返回字符串
+ (NSString *)postText:(NSString *)text toUrl:(NSString *)url;

///Get方式访问，返回字符串
+ (NSString *)getText:(NSString *)params toUrl:(NSString *)url;

///Get方式访问url，返回字符串
+ (NSString *)getUrl:(NSString *)url;

///下载文件到指定的目录
+ (BOOL)downloadFile:(NSString *)file fromUrl:(NSString *)url;

///获取所有的cookie
+ (KATArray<NSHTTPCookie *> *)getCookies;

///清除所有的cookie
+ (void)clearCookies;

///添加cookie
+ (void)addCookie:(NSHTTPCookie *)cookie;

///获取mime类型
+ (NSString *)MIMETypeWithFile:(NSString *)file;

///获取网络状态
+ (int)networkStatus;

///针对某个主机的网络状态
+ (int)networkStatusWithHost:(NSString *)host;


@end



