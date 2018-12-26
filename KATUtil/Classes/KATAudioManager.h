//
//  KATAudioManager.h
//  KATFramework
//
//  Created by Yi Yu on 2017/5/9.
//  Copyright © 2017年 KatApp. All rights reserved.
//  音频管理中心

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "KATArray.h"
#import "KATHashMap.h"
#import "KATAudioPlayer.h"
#import "KATAppUtil.h"



///音频播放器关联的key
extern NSString * const kAudioManagerPlayerKey;

///音频播放器配置模式的key
extern NSString * const kAudioManagerModeKey;

///音频播放器配置模式全局
extern NSString *const kAudioManagerModeGlobal;

///音频播放器配置模式定制
extern NSString *const kAudioManagerModeCustom;



//音频中心协议
@protocol KATAudioManagerDelegate <NSObject>

@optional

///播放完毕
- (void)audioPlayFinished:(BOOL)success forKey:(NSString *)key;

@end



@interface KATAudioManager : NSObject <KATAudioPlayerDelegate>


#pragma -mark 注册

///通过文件路径形式注册音频(播放时加载资源)
+ (void)registAudioWithFile:(NSString *)file forKey:(NSString *)key;


#pragma -mark 控制

///启用声音，并播放所有暂停的音频
+ (void)soundOn;

///关闭声音，并暂停所有正在播放的音频
+ (void)soundOff;

///播放(继续)(播放所有暂停的音频)
+ (void)play;

///播放指定的音频
+ (void)playForKey:(NSString *)key;

///停止所有正在播放和暂停的音频
+ (void)stop;

///停止指定的音频
+ (void)stopForKey:(NSString *)key;

///暂停所有正在播放的音频
+ (void)pause;

///暂停指定的音频
+ (void)pauseForKey:(NSString *)key;

///重新播放所有正在播放的音频
+ (void)replay;

///重新播放指定的音频
+ (void)replayForKey:(NSString *)key;


#pragma -mark 设置


/**
 为指定的音频设置参数

 @param loops 循环次数(-1无限 0不循环)
 @param volume 音量(0.0-1.0)
 @param key 音频的key
 */
+ (void)setLoops:(long)loops andvVolume:(float)volume forKey:(NSString *)key;

/**
 设置全局参数（未单独设置参数的音频使用全局参数）

 @param loops 循环次数(-1无限 0不循环)
 @param volume 音量(0.0-1.0)
 */
+ (void)setLoops:(long)loops andVolume:(float)volume;

///为指定的音频设置音量
+ (void)setVolume:(float)volume forKey:(NSString *)key;

///设置全局音量
+ (void)setVolume:(float)volume;

///为指定的音频设置循环次数
+ (void)setLoops:(long)loops forKey:(NSString *)key;

///设置全局循环次数
+ (void)setLoops:(long)loops;

///设置代理
+ (void)setAudioManagerDelegate:(id<KATAudioManagerDelegate>)delegate;


#pragma -mark 内容管理

///获取指定的播放器(若未初始化播放器，则调用该方法会初始化播放器)
+ (KATAudioPlayer *)playerForKey:(NSString *)key;

///获取所有已初始化的播放器
+ (KATArray<KATAudioPlayer *> *)initalizedPlayers;

///释放指定的播放器
+ (void)releasePlayerForKey:(NSString *)key;

///释放所有的播放器
+ (void)releasePlayers;

///释放单例
+ (void)releaseManager;



@end
