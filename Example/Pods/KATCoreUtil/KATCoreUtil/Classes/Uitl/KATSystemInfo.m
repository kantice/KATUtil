//
//  KATSystemInfo.m
//  KATFramework
//
//  Created by Kantice on 14-1-8.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//  系统环境变量

#import "KATSystemInfo.h"

#import "sys/utsname.h"



@interface KATSystemInfo ()

#pragma mark - 属性

///手机序列号
@property(nonatomic,copy) NSString *imei;

///标示号
@property(nonatomic,copy) NSString *uuid;

///设备别名
@property(nonatomic,copy) NSString *deviceName;

///设备名称
@property(nonatomic,copy) NSString *systemName;

///设备类型
@property(nonatomic,copy) NSString *deviceType;

///系统版本
@property(nonatomic,copy) NSString *osVersion;

///设备型号
@property(nonatomic,copy) NSString *deviceModel;

///设备具体型号
@property(nonatomic,copy) NSString *device;

///手机国际化型号
@property(nonatomic,copy) NSString *localModel;

///应用名称
@property(nonatomic,copy) NSString *appName;

///应用的BundleID
@property(nonatomic,copy) NSString *appID;

///应用版本
@property(nonatomic,copy) NSString *appVersion;

///应用路径
@property(nonatomic,copy) NSString *appPath;

///主目录
@property(nonatomic,copy) NSString *homePath;

///文档目录
@property(nonatomic,copy) NSString *documentsPath;

///缓存目录
@property(nonatomic,copy) NSString *cachesPath;

///临时目录
@property(nonatomic,copy) NSString *tmpPath;

///语言
@property(nonatomic,copy) NSString *language;

///语言ID
@property(nonatomic,assign) int languageID;

///地区
@property(nonatomic,copy) NSString *locale;

///应用版本数字码
@property(nonatomic,assign) int appVersionNum;

///info.plist
@property(nonatomic,retain) KATHashMap *info;

///Schemes
@property(nonatomic,retain) KATArray<NSString *> *schemes;


@end



@implementation KATSystemInfo


//单例
static KATSystemInfo *_info=nil;


//获取实例，初始化系统参数
+ (instancetype)systemInfo
{    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^
    {
        _info=[[self alloc] init];
        
        //    info.imei=[[UIDevice currentDevice] uniqueIdentifier];
        _info.uuid=[[UIDevice currentDevice].identifierForVendor UUIDString];
        _info.deviceName=[[UIDevice currentDevice] name];
        _info.systemName=[[UIDevice currentDevice] systemName];
        _info.osVersion=[[UIDevice currentDevice] systemVersion];
        _info.deviceModel=[[UIDevice currentDevice] model];
        _info.localModel=[[UIDevice currentDevice] localizedModel];
        
        //设备类型
        struct utsname systemInfo;
        uname(&systemInfo);
        _info.deviceType=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        //具体型号
        if([@"i386" isEqualToString:_info.deviceType] || [@"x86_64" isEqualToString:_info.deviceType])
        {
            _info.device=@"Simulator";
        }
        else if([@"iPhone3,1" isEqualToString:_info.deviceType] || [@"iPhone3,2" isEqualToString:_info.deviceType] || [@"iPhone3,3" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 4";
        }
        else if([@"iPhone4,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 4s";
        }
        else if([@"iPhone5,1" isEqualToString:_info.deviceType] || [@"iPhone5,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 5";
        }
        else if([@"iPhone5,3" isEqualToString:_info.deviceType] || [@"iPhone5,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 5c";
        }
        else if([@"iPhone6,1" isEqualToString:_info.deviceType] || [@"iPhone6,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 5s";
        }
        else if([@"iPhone7,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 6 Plus";
        }
        else if([@"iPhone7,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 6";
        }
        else if([@"iPhone8,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 6s";
        }
        else if([@"iPhone8,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 6s Plus";
        }
        else if([@"iPhone8,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone SE";
        }
        else if([@"iPhone9,1" isEqualToString:_info.deviceType] || [@"iPhone9,3" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 7";
        }
        else if([@"iPhone9,2" isEqualToString:_info.deviceType] || [@"iPhone9,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 7 Plus";
        }
        else if([@"iPhone10,1" isEqualToString:_info.deviceType] || [@"iPhone10,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 8";
        }
        else if([@"iPhone10,2" isEqualToString:_info.deviceType] || [@"iPhone10,5" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone 8 Plus";
        }
        else if([@"iPhone10,3" isEqualToString:_info.deviceType] || [@"iPhone10,6" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone X";
        }
        else if([@"iPhone11,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone Xs";
        }
        else if([@"iPhone11,4" isEqualToString:_info.deviceType] || [@"iPhone11,6" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone Xs Max";
        }
        else if([@"iPhone11,8" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPhone XR";
        }
        else if([@"iPod1,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPod Touch 1G";
        }
        else if([@"iPod2,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPod Touch 2G";
        }
        else if([@"iPod3,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPod Touch 3G";
        }
        else if([@"iPod4,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPod Touch 4G";
        }
        else if([@"iPod5,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPod Touch 5G";
        }
        else if([@"iPad1,1" isEqualToString:_info.deviceType] || [@"iPad1,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad";
        }
        else if([@"iPad2,1" isEqualToString:_info.deviceType] || [@"iPad2,2" isEqualToString:_info.deviceType] || [@"iPad2,3" isEqualToString:_info.deviceType] || [@"iPad2,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad 2";
        }
        else if([@"iPad2,5" isEqualToString:_info.deviceType] || [@"iPad2,6" isEqualToString:_info.deviceType] || [@"iPad2,7" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Mini";
        }
        else if([@"iPad3,1" isEqualToString:_info.deviceType] || [@"iPad3,2" isEqualToString:_info.deviceType] || [@"iPad3,3" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad 3";
        }
        else if([@"iPad3,4" isEqualToString:_info.deviceType] || [@"iPad3,5" isEqualToString:_info.deviceType] || [@"iPad3,6" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad 4";
        }
        else if([@"iPad4,1" isEqualToString:_info.deviceType] || [@"iPad4,2" isEqualToString:_info.deviceType] || [@"iPad4,3" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Air";
        }
        else if([@"iPad4,4" isEqualToString:_info.deviceType] || [@"iPad4,5" isEqualToString:_info.deviceType] || [@"iPad4,6" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Mini 2";
        }
        else if([@"iPad4,7" isEqualToString:_info.deviceType] || [@"iPad4,8" isEqualToString:_info.deviceType] || [@"iPad4,9" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Mini 3";
        }
        else if([@"iPad5,1" isEqualToString:_info.deviceType] || [@"iPad5,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Mini 4";
        }
        else if([@"iPad5,3" isEqualToString:_info.deviceType] || [@"iPad5,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Air 2";
        }
        else if([@"iPad6,3" isEqualToString:_info.deviceType] || [@"iPad6,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Pro 9.7";
        }
        else if([@"iPad6,7" isEqualToString:_info.deviceType] || [@"iPad6,8" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Pro 12.9";
        }
        else if([@"iPad6,11" isEqualToString:_info.deviceType] || [@"iPad6,12" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad 5";
        }
        else if([@"iPad7,1" isEqualToString:_info.deviceType] || [@"iPad7,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Pro 12.9 2nd";
        }
        else if([@"iPad7,3" isEqualToString:_info.deviceType] || [@"iPad7,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad Pro 10.5";
        }
        else if([@"iPad7,5" isEqualToString:_info.deviceType] || [@"iPad7,6" isEqualToString:_info.deviceType])
        {
            _info.device=@"iPad 6";
        }
        else if([@"Watch1,1" isEqualToString:_info.deviceType] || [@"Watch1,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple Watch";
        }
        else if([@"Watch2,3" isEqualToString:_info.deviceType] || [@"Watch2,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple Watch S2";
        }
        else if([@"Watch2,6" isEqualToString:_info.deviceType] || [@"Watch2,7" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple Watch S1";
        }
        else if([@"Watch3,1" isEqualToString:_info.deviceType] || [@"Watch3,2" isEqualToString:_info.deviceType] || [@"Watch3,3" isEqualToString:_info.deviceType] || [@"Watch3,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple Watch S3";
        }
        else if([@"Watch4,1" isEqualToString:_info.deviceType] || [@"Watch4,2" isEqualToString:_info.deviceType] || [@"Watch4,3" isEqualToString:_info.deviceType] || [@"Watch4,4" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple Watch S4";
        }
        else if([@"AppleTV2,1" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple TV 2";
        }
        else if([@"AppleTV3,1" isEqualToString:_info.deviceType] || [@"AppleTV3,2" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple TV 3";
        }
        else if([@"AppleTV5,3" isEqualToString:_info.deviceType])
        {
            _info.device=@"Apple TV 4";
        }
        else
        {
            _info.device=@"Undefine";
        }

        NSDictionary *infoDictionary=[[NSBundle mainBundle] infoDictionary];
        
        _info.appName=[infoDictionary objectForKey:@"CFBundleDisplayName"];
        _info.appID=[infoDictionary objectForKey:@"CFBundleIdentifier"];
        _info.appVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _info.appVersionNum=[[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
        
        _info.appPath=[[NSBundle mainBundle] bundlePath];
        _info.homePath=NSHomeDirectory();
        _info.documentsPath=[NSString stringWithFormat:@"%@/Documents",_info.homePath];
        _info.cachesPath=[NSString stringWithFormat:@"%@/Library/Caches",_info.homePath];
        _info.tmpPath=[NSString stringWithFormat:@"%@/tmp",_info.homePath];
        
        
        //简体中文：zh-Hans
        //繁体中文：zh-Hant
        //英语：en
        _info.language=[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        _info.locale=[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLocale"];
        
        _info.locale=[_info.locale substringFromIndex:_info.locale.length-2];//地区码截取最后两位
        
        if([_info.language hasPrefix:@"zh-Hans"])
        {
            _info.languageID=SYSTEM_LANGUAGE_CH;
        }
        else if([_info.language hasPrefix:@"zh-Hant"] || [_info.language hasPrefix:@"zh-HK"])
        {
            _info.languageID=SYSTEM_LANGUAGE_CHT;
        }
        else if([_info.language hasPrefix:@"en"])
        {
            _info.languageID=SYSTEM_LANGUAGE_EN;
        }
        else if([_info.language hasPrefix:@"ja"])
        {
            _info.languageID=SYSTEM_LANGUAGE_JA;
        }
        else
        {
            _info.languageID=SYSTEM_LANGUAGE_OTHER;
        }
        
        //info.plist
        _info.info=[KATHashMap hashMapWithDictionary:infoDictionary];
        
        //schemes
        _info.schemes=[KATArray array];
        
        KATArray *URLTypes=_info.info[@"CFBundleURLTypes"];
        
        for(KATHashMap *map in URLTypes)
        {
            [_info.schemes putArray:map[@"CFBundleURLSchemes"] withIndex:_info.schemes.length];
        }
    });
    
        
    return _info;
}


//重写alloc
+ (instancetype)alloc
{
    if(_info)
    {
        return nil;
    }
    else
    {
        return [super alloc];
    }
}


//释放单例
+ (void)releaseInfo
{
    if(_info)
    {
        [_info release];
    }
}


//描述
- (NSString *)description
{
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATSystemInfo:\n{\n"];

    [ms appendFormat:@"   [IEMI] %@ \n",_imei];
    [ms appendFormat:@"   [UUID] %@ \n",_uuid];
    [ms appendFormat:@"   [DeviceName] %@ \n",_deviceName];
    [ms appendFormat:@"   [SystemName] %@ \n",_systemName];
    [ms appendFormat:@"   [OSVersion] %@ \n",_osVersion];
    [ms appendFormat:@"   [Device] %@ \n",_device];
    [ms appendFormat:@"   [DeviceModel] %@ \n",_deviceModel];
    [ms appendFormat:@"   [DeviceType] %@ \n",_deviceType];
    [ms appendFormat:@"   [LocalModel] %@ \n",_localModel];
    [ms appendFormat:@"   [AppName] %@ \n",_appName];
    [ms appendFormat:@"   [AppID] %@ \n",_appID];
    [ms appendFormat:@"   [AppVersion] %@ \n",_appVersion];
    [ms appendFormat:@"   [Language] %@ \n",_language];
    [ms appendFormat:@"   [Locale] %@ \n",_locale];
    [ms appendFormat:@"   [AppNum] %i \n",_appVersionNum];
    [ms appendFormat:@"   [AppPath] %@ \n",_appPath];
    [ms appendFormat:@"   [HomePath] %@ \n",_homePath];
    [ms appendString:@"}"];
    
    return ms;
}


//内存释放
- (void)dealloc
{
//    NSLog(@"KATSystemInfo is delloc!");
    
    [_imei release];
    [_uuid release];
    [_deviceName release];
    [_systemName release];
    [_osVersion release];
    [_deviceModel release];
    [_deviceType release];
    [_device release];
    [_localModel release];
    [_appName release];
    [_appVersion release];
    [_appPath release];
    [_homePath release];
    [_documentsPath release];
    [_cachesPath release];
    [_tmpPath release];
    [_language release];
    [_locale release];
    [_info release];
    [_schemes release];
    
    [super dealloc];
}

@end
