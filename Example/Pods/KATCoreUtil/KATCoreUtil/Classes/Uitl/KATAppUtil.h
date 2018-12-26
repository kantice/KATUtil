//
//  KATAppUtil.h
//  KATFramework
//
//  Created by Kantice on 16/4/5.
//  Copyright © 2016年 KatApp. All rights reserved.
//  App工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KATSystemInfo.h"


@interface KATAppUtil : NSObject

#pragma -mark 类方法

///发短信
+ (void)messageTo:(NSString *)number;

///打电话
+ (void)dialTo:(NSString *)number;

///发送邮件
+ (void)mailTo:(NSString *)address;

///打开URL(网页或地图)
+ (void)browseURL:(NSString *)URL;

///打开应用商店
+ (void)viewApp:(NSString *)appID;

///打开应用评分
+ (void)rateApp:(NSString *)appID;

///设置app
+ (void)goToAppSetting;

///打开app
+ (void)openApp:(NSString *)app withMessage:(NSString *)msg;

///打开URL
+ (void)openURL:(NSString *)URL;

///获取主窗口
+ (UIWindow *)keyWindow;

///获取根视图
+ (UIView *)rootViewFromView:(UIView *)view;

///获取当前的视图控制器
+ (UIViewController *)currentViewController;

///获取顶层的视图控制器
+ (UIViewController *)topViewController;

///获取view所在的视图控制器
+ (UIViewController *)controllerWithView:(UIView *)view;

///获取View相对keyWindow的frame
+ (CGRect)frameInWindowFromView:(UIView *)view;

///获取View相对于某个控件的frame
+ (CGRect)frameInOther:(UIView *)other fromView:(UIView *)view;

///获取View相对keyWindow的center
+ (CGPoint)centerInWindowFromView:(UIView *)view;

///获取View相对于某个控件的center
+ (CGPoint)centerInOther:(UIView *)other fromView:(UIView *)view;

///获取屏幕尺寸
+ (CGSize)screenSize;

///获取屏幕缩放比率
+ (float)screenScale;

///获取状态栏尺寸
+ (CGSize)statusBarSize;

///设置网络活动指示器
+ (void)setNetworkStateActive:(BOOL)active;

///设置状态栏隐藏
+ (void)setStatusBarHidden:(BOOL)hidden withAnimation:(BOOL)animation;

///设置状态栏亮色
+ (void)setStatusBarLightStyle;

///设置状态栏暗色
+ (void)setStatusBarDarkStyle;

///获取状态栏是否亮色
+ (BOOL)isStatusBarLightStyle;

///显示状态栏
+ (void)showStatusBar;

///隐藏状态栏
+ (void)hideStatusBar;

///获取app路径
+ (NSString *)appPath;

///获取文档路径
+ (NSString *)docPath;

///获取库文件路径
+ (NSString *)libPath;

///获取临时文件路径
+ (NSString *)tempPath;

///获取图标
+ (UIImage *)iconImage;

///获取启动图片(根据方向自动判断)
+ (UIImage *)launchImage;

///获取竖屏方向的启动图片
+ (UIImage *)portraitLaunchImage;

///获取横屏方向的启动图片
+ (UIImage *)landscapeLaunchImage;

///获取系统版本
+ (NSString *)OSVersion;

///获取app版本
+ (NSString *)appVersion;

///获取系统语言
+ (int)language;

///获取info.plist
+ (KATHashMap *)info;

///获取Schemes
+ (KATArray<NSString *> *)schemes;

///修复无法播放声音的问题
+ (void)repairAudioPlayer;

///设置应用图标徽标数字
+ (void)setBadgeNumber:(long)badge;

///获取当前应用图标徽标数字
+ (long)getBadgeNumber;

///设置屏幕方向
+ (BOOL)setOrientation:(UIInterfaceOrientation)orientation;

///获取当前的屏幕方向
+ (UIDeviceOrientation)currentOrientation;

///设置禁止自动锁屏
+ (void)setAutoLockScreenDisabled:(BOOL)disabled;

///获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

///获取mak地址(iOS7之后已经获取不到了)
+ (NSString *)getMakAddress;

///获取MAC地址(目前也无法获取)
+ (NSString *)getMacAddress;

///获取剪切板中的字符串
+ (NSString *)stringFromPasteboard;

///设置剪切板中的字符串
+ (void)setStringToPasteboard:(NSString *)string;

///获取剪切板中的图片
+ (UIImage *)imageFromPasteboard;

///设置剪切板中的图片
+ (void)setImageToPasteboard:(UIImage *)image;

///获取剪切板中的URL
+ (NSURL *)urlFromPasteboard;

///设置剪切板中的URL
+ (void)setUrlToPasteboard:(NSURL *)url;

///获取剪切板中的颜色
+ (UIColor *)colorFromPasteboard;

///设置剪切板中的颜色
+ (void)setColorToPasteboard:(UIColor *)color;

///分享内容(简单模式)
+ (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSURL *)url andCompletion:(void (^)(BOOL completed))completion;

///分享内容(Items只能为UIImage,NSString或NSURL)
+ (void)shareWithItems:(KATArray *)items excludedTypes:(KATArray<UIActivityType> *)types andCompletion:(void (^)(BOOL completed))completion;

///获取指定类的所有属性名称
+ (KATArray<NSString *> *)propertiesInClass:(Class)cls;

///加密保存对象
+ (void)saveObject:(id)object withPassword:(NSString *)password andPath:(NSString *)path;

///加载加密保存的对象
+ (id)loadObjectWithPassword:(NSString *)password andPath:(NSString *)path;

///内存使用量(Byte)
+ (long long int)usageOfMemory;

///CPU使用率(精确到0.1%)
+ (float)usageOfCPU;

///判断某个版本号是否不比指定版本早(xx.xx.xx)(大于等于返回YES)
+ (BOOL)isVersionA:(NSString *)versionA notEarlierThanVersionB:(NSString *)versionB;

///判断当前系统版本号是否是否不早于指定的版本号
+ (BOOL)isOSNotEarlierThanVersion:(NSString *)version;

///判断当前app版本号是否不早于指定的版本号
+ (BOOL)isAppNotEarlierThanVersion:(NSString *)version;

///隐藏键盘
+ (void)hideKeyboard;

@end




