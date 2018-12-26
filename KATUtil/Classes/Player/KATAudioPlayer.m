//
//  KATAudioPlayer.m
//  KATFramework
//
//  Created by Kantice on 14/11/5.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//

#import "KATAudioPlayer.h"



@implementation KATAudioPlayer


+ (instancetype)playerWithFile:(NSString *)file
{
    // 设置音乐文件路径
    NSString *path=[[NSBundle mainBundle] pathForResource:file ofType:nil];
    
    // 判断是否可以访问这个文件
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        KATAudioPlayer *player=[[[self alloc] init] autorelease];
        
        NSError *err;
        player.player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
        [player.player release];
        
        if(err)
        {
            NSLog(@"err:%@",err);
            
            return nil;
        }
        
        player.path=path;
        
        player.player.delegate=player;
        player.player.volume=1.0;
        player.player.numberOfLoops=0;
        [player.player prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
        
        [player musicInfo];//获取音乐信息
        
        player.state=AUDIO_PLAYER_STATE_READY;
        
        return player;
    }
    else
    {
        NSLog(@"File load failed!");
        
        return nil;
    }
    
}


+ (instancetype)playerWithPath:(NSString *)path
{
    // 判断是否可以访问这个文件
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        KATAudioPlayer *player=[[[self alloc] init] autorelease];
        
        NSError *err;
        player.player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
        [player.player release];
        
        if(err)
        {
            NSLog(@"err:%@",err);
            
            return nil;
        }
        
        player.path=path;
        
        player.player.delegate=player;
        player.player.volume=1.0;
        player.player.numberOfLoops=0;
        [player.player prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
        
        [player musicInfo];//获取音乐信息
        
        player.state=AUDIO_PLAYER_STATE_READY;
        
        return player;
    }
    else
    {
        NSLog(@"File load failed!");
        
        return nil;
    }
    
}



- (double)audioDuration
{
    return _player.duration;
}


- (double)currentTime
{
    return _player.currentTime;
}


- (void)setCurrentTime:(double)currentTime
{
    if(currentTime<0.0)
    {
        currentTime=0.0;
    }
    
    if(currentTime>_player.duration)
    {
        currentTime=_player.duration;
    }
    
    _player.currentTime=currentTime;
}


- (double)deviceTime
{
    return _player.deviceCurrentTime;
}


- (float)audioVolume
{
    return _player.volume;
}


- (void)setAudioVolume:(float)audioVolume
{
    if(audioVolume<0.0)
    {
        audioVolume=0.0;
    }
    
    if(audioVolume>1.0)
    {
        audioVolume=1.0;
    }
    
    _player.volume=audioVolume;
}


- (long)playLoops
{
    return _player.numberOfLoops;
}


- (void)setPlayLoops:(long)playLoops
{
    _player.numberOfLoops=playLoops;
}


- (float)playRate
{
    return _player.rate;
}


- (void)setPlayRate:(float)playRate
{
    if(playRate<0.5)
    {
        playRate=0.5;
    }
    
    if(playRate>2.0)
    {
        playRate=2.0;
    }
    
    _player.enableRate=YES;
    _player.rate=playRate;
}


- (BOOL)isPlaying
{
    return _player.isPlaying;
}


- (long)channels
{
    return _player.numberOfChannels;
}


//获取音乐信息（内部函数）
- (void)musicInfo
{
    AVURLAsset *asset=[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_path] options:nil];
        
    if(asset)
    {
        for (NSString *format in [asset availableMetadataFormats])
        {
            // 根据数据格式获取AVMetadataItem（数据成员）；
            // 根据AVMetadataItem属性commonKey能够获取专辑信息；
            for(AVMetadataItem *metadataItem in [asset metadataForFormat:format])
            {
                if([metadataItem.commonKey isEqual:AVMetadataCommonKeyArtist])// 1、获取艺术家（歌手）名字commonKey：AVMetadataCommonKeyArtist
                {
                    self.musicAuthor=(NSString *)metadataItem.value;
                }
                else if([metadataItem.commonKey isEqual:AVMetadataCommonKeyTitle])// 2、获取音乐名字commonKey：AVMetadataCommonKeyTitle
                {
                    self.musicName=(NSString *)metadataItem.value;
                }
                else if([metadataItem.commonKey isEqual:AVMetadataCommonKeyArtwork])// 3、获取专辑图片commonKey：AVMetadataCommonKeyArtwork
                {
                    self.musicCover=[UIImage imageWithData:(NSData *)metadataItem.value];
                }
                else if([metadataItem.commonKey isEqual:AVMetadataCommonKeyAlbumName])// 4、获取专辑名commonKey：AVMetadataCommonKeyAlbumName
                {
                    self.musicAlbum=(NSString *)metadataItem.value;
                }
            }
        }
    }
}



//播放(继续)
- (void)play
{
    [_player play];
    
    _state=AUDIO_PLAYER_STATE_PLAY;
}


//重新播放
- (void)replay
{
    [_player setCurrentTime:0.0];
    [self play];
    
    _state=AUDIO_PLAYER_STATE_PLAY;
}


//停止
- (void)stop
{
    [_player stop];
    
    _state=AUDIO_PLAYER_STATE_STOP;
}


//暂停
- (void)pause
{
    [_player pause];
    
    _state=AUDIO_PLAYER_STATE_PAUSE;
}


//播放延迟
- (void)playWithDelay:(double)delay
{
    [_player playAtTime:_player.deviceCurrentTime+delay];
    
    _state=AUDIO_PLAYER_STATE_PLAY;
}



//代理方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _state=AUDIO_PLAYER_STATE_READY;
    
    //回调
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(audioPlayerPlayFinished:successfully:)])
    {
        [_eventDelegate audioPlayerPlayFinished:self successfully:flag];
    }
}



- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    //解码错误执行的动作
    NSLog(@"Audio error");
    
    _state=AUDIO_PLAYER_STATE_ERROR;
}


/** 废弃方法
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
    //开始中断
    NSLog(@"Audio interruption");
}


- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    //中断结束
    NSLog(@"Audio continue");
}
*/


- (void)dealloc
{
//    NSLog(@"KATAudio is delloc");
    
    [_path release];
    
    [_musicAlbum release];
    [_musicAuthor release];
    [_musicCover release];
    [_musicName release];
    
    if(_player)
    {
        [_player stop];
        [_player release];
    }
    
    [super dealloc];
}

@end
