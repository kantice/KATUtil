//
//  KATVideoPlayer.h
//  KATFramework
//
//  Created by Kantice on 16/1/4.
//  Copyright © 2016年 KatApp. All rights reserved.
//  视频播放器(可以播放本地和网络视频)

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


#define VIDEO_PLAYER_STATE_ERROR 0
#define VIDEO_PLAYER_STATE_STOP 1
#define VIDEO_PLAYER_STATE_PLAY 2
#define VIDEO_PLAYER_STATE_PAUSE 3
#define VIDEO_PLAYER_STATE_INTERRUPT 4
#define VIDEO_PLAYER_STATE_FORWARD 5
#define VIDEO_PLAYER_STATE_BACKWARD 6


#define VIDEO_PLAYER_LOAD_UNKNOWN 0
#define VIDEO_PLAYER_LOAD_PLAYABLE 1
#define VIDEO_PLAYER_LOAD_PLAY_THROUGH_OK 2
#define VIDEO_PLAYER_LOAD_STALLED 3


#define VIDEO_PLAYER_SOURCE_UNKNOWN 0
#define VIDEO_PLAYER_SOURCE_FILE 1
#define VIDEO_PLAYER_SOURCE_STREAMING 2


#define VIDEO_PLAYER_TYPE_NONE 0
#define VIDEO_PLAYER_TYPE_VIDEO 1
#define VIDEO_PLAYER_TYPE_AUDIO 2


#define VIDEO_PLAYER_SCALE_NONE 0
#define VIDEO_PLAYER_SCALE_ASPECT_FIT 1
#define VIDEO_PLAYER_SCALE_ASPECT_FILL 2
#define VIDEO_PLAYER_SCALE_FILL 3


#define VIDEO_PLAYER_REPEAT_OFF 0
#define VIDEO_PLAYER_REPEAT_ON 1


#define VIDEO_PLAYER_STYLE_NONE 0
#define VIDEO_PLAYER_STYLE_EMBEDDED 1
#define VIDEO_PLAYER_STYLE_FULLSCREEN 2
#define VIDEO_PLAYER_STYLE_DEFAULT 3





@class KATVideoPlayer;

//音频播放器代理
@protocol KATVideoPlayerDelegate <NSObject>

@optional

///状态改变
- (void)videoPlayerStateChange:(KATVideoPlayer *)player;

///播放完毕
- (void)videoPlayerPlayFinished:(KATVideoPlayer *)player;

///截图完成
- (void)videoPlayerThumbnailRequestFinished:(KATVideoPlayer *)player withThumb:(UIImage *)thumb;

@end





@interface KATVideoPlayer : NSObject


#pragma -mark 属性

///事件代理
@property(nonatomic,assign) id<KATVideoPlayerDelegate> eventDelegate;

///播放器
@property(nonatomic,retain) MPMoviePlayerController *player;

///资源路径（本地）
@property(nonatomic,copy) NSString *path;

///资源的链接（网络）
@property(nonatomic,copy) NSString *url;

///状态
@property(nonatomic,readonly) int state;

///网络加载状态
@property(nonatomic,readonly) int loadState;

///源类型
@property(nonatomic,readonly) int sourceType;

///播放类型
@property(nonatomic,readonly) int type;

///缩放模式
@property(nonatomic,assign) int scaleMode;

///重复播放
@property(nonatomic,assign) BOOL repeat;

///控制风格
@property(nonatomic,assign) int controlStyle;

///当网络媒体缓存到一定数据时是否自动播放，默认为YES
@property(nonatomic,assign) BOOL autoPlay;

///是否全屏展示，默认为NO，注意如果要通过此属性设置全屏必须在视图显示完成后设置，否则无效
@property(nonatomic,assign) BOOL fullScreen;

///是否显示
@property(nonatomic,readonly) BOOL isShown;

///视频时长，未知则为0
@property(nonatomic,readonly) double videoDuration;

///媒体可播放时长，主要用于表示网络媒体已下载视频时长
@property(nonatomic,readonly) double playableDuration;

///当前播放时间
@property(nonatomic,assign) double currentTime;

///开始播放时间
@property(nonatomic,assign) double startTime;

///终止播放时间
@property(nonatomic,assign) double endTime;

///当前播放速度，如果暂停则为0，正常速度为1.0，非0数据表示倍率
@property(nonatomic,assign) float playRate;

///视频的实际尺寸
@property(nonatomic,readonly) CGSize videoSize;

///视频的展示位置及大小
@property(nonatomic,assign) CGRect videoFrame;


#pragma -mark 类方法

///播放本地视频文件
+ (instancetype)playerWithPath:(NSString *)path;

///播放网络视频文件
+ (instancetype)playerWithUrl:(NSString *)url;


#pragma -mark 对象方法

///显示
- (void)showInView:(UIView *)parent;

///隐藏
- (void)hide;

///播放(继续)
- (void)play;

///停止
- (void)stop;

///暂停
- (void)pause;

///重新播放
- (void)replay;

///设置全屏
- (void)setFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

///开始快进
- (void)seekingForward;

///开始快退
- (void)seekingBackward;

///停止快进（快退）
- (void)endSeeking;

///单张缩略图
- (UIImage *)thumbnailImageAtTime:(double)time;

///多张缩略图(回调函数中获取)
- (void)thumbnailImageAtTimes:(NSArray *)times;


///释放内存
- (void)dealloc;


@end


