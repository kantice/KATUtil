//
//  KATVideoPlayer.m
//  KATFramework
//
//  Created by Kantice on 16/1/4.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATVideoPlayer.h"

@implementation KATVideoPlayer


//播放本地视频文件
+ (instancetype)playerWithPath:(NSString *)path
{
    // 判断是否可以访问这个文件
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        KATVideoPlayer *player=[[[self alloc] init] autorelease];
        
        player.player=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
        [player.player release];
        
        player.path=path;
    
        [player.player prepareToPlay];//准备播放，加载视频数据到缓存，当调用play方法时如果没有准备好会自动调用此方法
        
        
        //注册事件到通知中心
        NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:player selector:@selector(playerStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:player.player];
        [notificationCenter addObserver:player selector:@selector(playerPlayFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:player.player];
        [notificationCenter addObserver:player selector:@selector(playerThumbFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:player.player];
        
        return player;
    }
    else
    {
        NSLog(@"File load failed!");
        
        return nil;
    }

}


//播放网络视频文件
+ (instancetype)playerWithUrl:(NSString *)url
{
    if(url)
    {
        KATVideoPlayer *player=[[[self alloc] init] autorelease];
        
//        url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//百分号转义符
        
        player.player=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
        [player.player release];
        
        player.url=url;
        
        [player.player prepareToPlay];//准备播放，加载视频数据到缓存，当调用play方法时如果没有准备好会自动调用此方法
        player.player.allowsAirPlay=YES;
        
        
        //注册事件到通知中心
        NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:player selector:@selector(playerStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:player.player];
        [notificationCenter addObserver:player selector:@selector(playerPlayFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:player.player];
        [notificationCenter addObserver:player selector:@selector(playerThumbFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:player.player];
        
        return player;
    }
    else
    {
        return nil;
    }
}




- (int)state
{
    if(_player.playbackState==MPMoviePlaybackStateStopped)
    {
        return VIDEO_PLAYER_STATE_STOP;
    }
    else if(_player.playbackState==MPMoviePlaybackStatePlaying)
    {
        return VIDEO_PLAYER_STATE_PLAY;
    }
    else if(_player.playbackState==MPMoviePlaybackStatePaused)
    {
        return VIDEO_PLAYER_STATE_PAUSE;
    }
    else if(_player.playbackState==MPMoviePlaybackStateInterrupted)
    {
        return VIDEO_PLAYER_STATE_INTERRUPT;
    }
    else if(_player.playbackState==MPMoviePlaybackStateSeekingForward)
    {
        return VIDEO_PLAYER_STATE_FORWARD;
    }
    else if(_player.playbackState==MPMoviePlaybackStateSeekingBackward)
    {
        return VIDEO_PLAYER_STATE_BACKWARD;
    }
    
    
    return -1;
}


- (int)loadState
{
    if(_player.loadState==MPMovieLoadStateUnknown)
    {
        return VIDEO_PLAYER_LOAD_UNKNOWN;
    }
    else if(_player.loadState==MPMovieLoadStatePlayable)
    {
        return VIDEO_PLAYER_LOAD_PLAYABLE;
    }
    else if(_player.loadState==MPMovieLoadStatePlaythroughOK)
    {
        return VIDEO_PLAYER_LOAD_PLAY_THROUGH_OK;
    }
    else if(_player.loadState==MPMovieLoadStateStalled)
    {
        return VIDEO_PLAYER_LOAD_STALLED;
    }
    
    
    return -1;
}


- (int)sourceType
{
    if(_player.movieSourceType==MPMovieSourceTypeFile)
    {
        return VIDEO_PLAYER_SOURCE_FILE;
    }
    else if(_player.movieSourceType==MPMovieSourceTypeStreaming)
    {
        return VIDEO_PLAYER_SOURCE_STREAMING;
    }
    else if(_player.movieSourceType==MPMovieSourceTypeUnknown)
    {
        return VIDEO_PLAYER_SOURCE_UNKNOWN;
    }
    
    
    return -1;
}


- (int)type
{
    if(_player.movieMediaTypes==MPMovieMediaTypeMaskVideo)
    {
        return VIDEO_PLAYER_TYPE_VIDEO;
    }
    else if(_player.movieMediaTypes==MPMovieMediaTypeMaskAudio)
    {
        return VIDEO_PLAYER_TYPE_AUDIO;
    }
    else if(_player.movieMediaTypes==MPMovieMediaTypeMaskNone)
    {
        return VIDEO_PLAYER_TYPE_NONE;
    }
    
    
    return -1;
}


- (int)scaleMode
{
    if(_player.scalingMode==MPMovieScalingModeNone)
    {
        return VIDEO_PLAYER_SCALE_NONE;
    }
    else if(_player.scalingMode==MPMovieScalingModeAspectFit)
    {
        return VIDEO_PLAYER_SCALE_ASPECT_FIT;
    }
    else if(_player.scalingMode==MPMovieScalingModeAspectFill)
    {
        return VIDEO_PLAYER_SCALE_ASPECT_FILL;
    }
    else if(_player.scalingMode==MPMovieScalingModeFill)
    {
        return VIDEO_PLAYER_SCALE_FILL;
    }
    
    return -1;
}


- (void)setScaleMode:(int)scaleMode
{
    if(scaleMode==VIDEO_PLAYER_SCALE_NONE)
    {
        _player.scalingMode=MPMovieScalingModeNone;
    }
    else if(scaleMode==VIDEO_PLAYER_SCALE_ASPECT_FIT)
    {
        _player.scalingMode=MPMovieScalingModeAspectFit;
    }
    else if(scaleMode==VIDEO_PLAYER_SCALE_ASPECT_FILL)
    {
        _player.scalingMode=MPMovieScalingModeAspectFill;
    }
    else if(scaleMode==VIDEO_PLAYER_SCALE_FILL)
    {
        _player.scalingMode=MPMovieScalingModeFill;
    }
}


- (BOOL)repeat
{
    if(_player.repeatMode==MPMovieRepeatModeNone)
    {
        return NO;
    }
    else if(_player.repeatMode==MPMovieRepeatModeOne)
    {
        return YES;
    }
    
    
    return NO;
}


- (void)setRepeat:(BOOL)repeat
{
    if(repeat)
    {
        _player.repeatMode=MPMovieRepeatModeOne;
    }
    else
    {
        _player.repeatMode=MPMovieRepeatModeNone;
    }
}


- (int)controlStyle
{
    if(_player.controlStyle==MPMovieControlStyleNone)
    {
        return VIDEO_PLAYER_STYLE_NONE;
    }
    else if(_player.controlStyle==MPMovieControlStyleEmbedded)
    {
        return VIDEO_PLAYER_STYLE_EMBEDDED;
    }
    else if(_player.controlStyle==MPMovieControlStyleFullscreen)
    {
        return VIDEO_PLAYER_STYLE_FULLSCREEN;
    }
    else if(_player.controlStyle==MPMovieControlStyleDefault)
    {
        return VIDEO_PLAYER_STYLE_DEFAULT;
    }
    
    
    return -1;
}


- (void)setControlStyle:(int)controlStyle
{
    if(controlStyle==VIDEO_PLAYER_STYLE_NONE)
    {
        _player.controlStyle=MPMovieControlStyleNone;
    }
    else if(controlStyle==VIDEO_PLAYER_STYLE_EMBEDDED)
    {
        _player.controlStyle=MPMovieControlStyleEmbedded;
    }
    else if(controlStyle==VIDEO_PLAYER_STYLE_FULLSCREEN)
    {
        _player.controlStyle=MPMovieControlStyleFullscreen;
    }
    else if(controlStyle==VIDEO_PLAYER_STYLE_DEFAULT)
    {
        _player.controlStyle=MPMovieControlStyleDefault;
    }
}


- (BOOL)autoPlay
{
    return _player.shouldAutoplay;
}



- (void)setAutoPlay:(BOOL)autoPlay
{
    _player.shouldAutoplay=autoPlay;
}


- (BOOL)fullScreen
{
    return _player.fullscreen;
}


- (void)setFullScreen:(BOOL)fullScreen
{
    _player.fullscreen=fullScreen;
}


- (double)videoDuration
{
    return _player.duration;
}


- (double)playableDuration
{
    return _player.playableDuration;
}


- (double)currentTime
{
    return _player.currentPlaybackTime;
}


- (void)setCurrentTime:(double)currentTime
{
    if(currentTime<0)
    {
        currentTime=0;
    }
    
    _player.currentPlaybackTime=currentTime;
}


- (double)startTime
{
    return _player.initialPlaybackTime;
}


- (void)setStartTime:(double)startTime
{
    if(startTime<0)
    {
        startTime=0;
    }
    
    _player.initialPlaybackTime=startTime;
}


- (double)endTime
{
    return _player.endPlaybackTime;
}


- (void)setEndTime:(double)endTime
{
    if(endTime<0)
    {
        endTime=0;
    }
    
    _player.endPlaybackTime=endTime;
}


- (float)playRate
{
    return _player.currentPlaybackRate;
}


- (void)setPlayRate:(float)playRate
{
    if(playRate<0)
    {
        playRate=0;
    }
    
    _player.currentPlaybackRate=playRate;
}


- (CGSize)videoSize
{
    return _player.naturalSize;
}


- (CGRect)videoFrame
{
    return _player.view.frame;
}


- (void)setVideoFrame:(CGRect)videoFrame
{
    _player.view.frame=videoFrame;
}





//显示
- (void)showInView:(UIView *)parent
{
    if(parent)
    {
        _isShown=YES;
        [parent addSubview:_player.view];
    }
}


//隐藏
- (void)hide
{
    _isShown=NO;
    [_player.view removeFromSuperview];
}


//播放(继续)
- (void)play
{
    [_player play];
}


//停止
- (void)stop
{
    [_player stop];
}


//暂停
- (void)pause
{
    [_player pause];
}


//重新播放
- (void)replay
{
    _player.currentPlaybackTime=0.0;
    [_player play];
}


//设置全屏
- (void)setFullScreen:(BOOL)fullScreen animated:(BOOL)animated
{
    [_player setFullscreen:fullScreen animated:animated];
}



//开始快进
- (void)seekingForward
{
    [_player beginSeekingForward];
}


//开始快退
- (void)seekingBackward
{
    [_player beginSeekingBackward];
}


//停止快进（快退）
- (void)endSeeking
{
    [_player endSeeking];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

//单张缩略图
- (UIImage *)thumbnailImageAtTime:(double)time
{
    return [_player thumbnailImageAtTime:time timeOption:MPMovieTimeOptionNearestKeyFrame];
}

#pragma clang diagnostic pop


//多张缩略图(回调函数中获取)
- (void)thumbnailImageAtTimes:(NSArray *)times;
{
    [_player requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionNearestKeyFrame];
}


#pragma -mark 通知事件


//播放状态改变，注意播放完成时的状态是暂停
- (void)playerStateChange:(NSNotification *)notification
{    
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(videoPlayerStateChange:)])
    {
        [_eventDelegate videoPlayerStateChange:self];
    }
}


//播放完成
- (void)playerPlayFinished:(NSNotification *)notification
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(videoPlayerPlayFinished:)])
    {
        [_eventDelegate videoPlayerPlayFinished:self];
    }
}


//缩略图请求完成,此方法每次截图成功都会调用一次
-(void)playerThumbFinished:(NSNotification *)notification
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(videoPlayerThumbnailRequestFinished:withThumb:)])
    {
        [_eventDelegate videoPlayerThumbnailRequestFinished:self withThumb:notification.userInfo[MPMoviePlayerThumbnailImageKey]];
    }
}




- (void)dealloc
{
    if(_isShown)
    {
        [self hide];
    }
    
    [_path release];
    [_url release];
    
    if(_player)
    {
        [_player stop];
        [_player release];
    }
    
    [super dealloc];
}



@end
