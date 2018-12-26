//
//  KATSystemInfo.h
//  KATFramework
//
//  Created by Kantice on 14-1-8.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//  系统环境变量

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "KATHashMap.h"




#define SYSTEM_LANGUAGE_EN 0
#define SYSTEM_LANGUAGE_CH 1
#define SYSTEM_LANGUAGE_CHT 2
#define SYSTEM_LANGUAGE_JA 3
#define SYSTEM_LANGUAGE_OTHER 4


@interface KATSystemInfo : NSObject


#pragma mark - 属性

///手机序列号
@property(nonatomic,copy,readonly) NSString *imei;

///标示号(idfv)
@property(nonatomic,copy,readonly) NSString *uuid;

///设备别名
@property(nonatomic,copy,readonly) NSString *deviceName;

///系统名称
@property(nonatomic,copy,readonly) NSString *systemName;

///设备类型
@property(nonatomic,copy,readonly) NSString *deviceType;

///系统版本
@property(nonatomic,copy,readonly) NSString *osVersion;

///设备型号
@property(nonatomic,copy,readonly) NSString *deviceModel;

///设备具体型号
@property(nonatomic,copy,readonly) NSString *device;

///设备国际化型号
@property(nonatomic,copy,readonly) NSString *localModel;

///应用名称
@property(nonatomic,copy,readonly) NSString *appName;

///应用的BundleID
@property(nonatomic,copy,readonly) NSString *appID;

///应用版本
@property(nonatomic,copy,readonly) NSString *appVersion;

///应用路径
@property(nonatomic,copy,readonly) NSString *appPath;

///主目录
@property(nonatomic,copy,readonly) NSString *homePath;

///文档目录
@property(nonatomic,copy,readonly) NSString *documentsPath;

///缓存目录
@property(nonatomic,copy,readonly) NSString *cachesPath;

///临时目录
@property(nonatomic,copy,readonly) NSString *tmpPath;

///语言
@property(nonatomic,copy,readonly) NSString *language;

///语言ID
@property(nonatomic,assign,readonly) int languageID;

///地区
@property(nonatomic,copy,readonly) NSString *locale;

///应用版本数字码
@property(nonatomic,assign,readonly) int appVersionNum;

///info.plist
@property(nonatomic,retain,readonly) KATHashMap *info;

///Schemes
@property(nonatomic,retain,readonly) KATArray<NSString *> *schemes;


#pragma mark - 类方法

///获取实例，初始化系统参数(单例)
+ (instancetype)systemInfo;

///释放单例
+ (void)releaseInfo;


#pragma mark - 对象方法

///描述
- (NSString *)description;

///内存释放
- (void)dealloc;

@end



