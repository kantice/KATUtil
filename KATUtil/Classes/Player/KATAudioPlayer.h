//
//  KATAudioPlayer.h
//  KATFramework
//
//  Created by Kantice on 14/11/5.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//  音频播放器(播放本地音频)

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


#define AUDIO_PLAYER_STATE_ERROR 0
#define AUDIO_PLAYER_STATE_READY 1
#define AUDIO_PLAYER_STATE_PLAY 2
#define AUDIO_PLAYER_STATE_PAUSE 3
#define AUDIO_PLAYER_STATE_STOP 4


@class KATAudioPlayer;

//代理
@protocol KATAudioPlayerDelegate <NSObject>

@optional

///播放完成
- (void)audioPlayerPlayFinished:(KATAudioPlayer *)player successfully:(BOOL)flag;

@end



@interface KATAudioPlayer : NSObject <AVAudioPlayerDelegate>


#pragma -mark 属性

///事件代理
@property(nonatomic,assign) id<KATAudioPlayerDelegate> eventDelegate;

///播放器
@property(nonatomic,retain) AVAudioPlayer *player;

///资源路径
@property(nonatomic,copy) NSString *path;

///状态
@property(nonatomic,assign) int state;

///是否在播放
@property(nonatomic,readonly) BOOL isPlaying;

///音频时长
@property(nonatomic,readonly) double audioDuration;

///当前播放时间点
@property(nonatomic,assign) double currentTime;

///当前设备播放时长（包括暂停时间）
@property(nonatomic,readonly) double deviceTime;

///声道数
@property(nonatomic,readonly) long channels;

///音量0.0-1.0
@property(nonatomic,assign) float audioVolume;

///循环次数(-1无限 0不循环)
@property(nonatomic,assign) long playLoops;

///播放速率(0.5-2.0, 1为正常速率)(设置完播放生效)
@property(nonatomic,assign) float playRate;

///音乐专辑(mp3)
@property(nonatomic,copy) NSString *musicAlbum;

///音乐名称(mp3)
@property(nonatomic,copy) NSString *musicName;

///歌手(mp3)
@property(nonatomic,copy) NSString *musicAuthor;

///音乐封面(mp3)
@property(nonatomic,retain) UIImage *musicCover;


#pragma -mark 类方法

///从资源文件中获取实例
+ (instancetype)playerWithFile:(NSString *)file;

///从路径中获取实例
+ (instancetype)playerWithPath:(NSString *)path;


#pragma -mark 对象方法

///播放(继续)
- (void)play;

///停止
- (void)stop;

///暂停
- (void)pause;

///重新播放
- (void)replay;

///播放延迟
- (void)playWithDelay:(double)delay;


//波形

//后台播放

//耳机事件


///释放内存
- (void)dealloc;


@end


