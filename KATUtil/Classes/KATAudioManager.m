//
//  KATAudioManager.m
//  KATFramework
//
//  Created by Yi Yu on 2017/5/9.
//  Copyright © 2017年 KatApp. All rights reserved.
//

#import "KATAudioManager.h"


NSString * const kAudioManagerPlayerKey=@"audio_manager_player_key";
NSString * const kAudioManagerModeKey=@"audio_manager_player_mode";
NSString * const kAudioManagerModeGlobal=@"0";
NSString * const kAudioManagerModeCustom=@"1";



@interface KATAudioManager()

///播放器表
@property(nonatomic,retain) KATHashMap<KATAudioPlayer *> *players;

///文件路径表
@property(nonatomic,retain)  KATHashMap<NSString *> *files;

///是否关闭声音
@property(nonatomic,assign) BOOL isSoundOff;

///循环次数
@property(nonatomic,assign) long loops;

///音量
@property(nonatomic,assign) float volume;

///事件代理
@property(nonatomic,assign) id<KATAudioManagerDelegate> eventDelegate;


@end


@implementation KATAudioManager


//单例
static KATAudioManager *_manager=nil;



#pragma -mark 内部方法

//获取单例
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        //修复声音播放问题
        [KATAppUtil repairAudioPlayer];
        
        //初始化
        _manager=[[self alloc] init];
        
        _manager.players=[KATHashMap hashMap];
        _manager.files=[KATHashMap hashMap];
        _manager.isSoundOff=NO;
        _manager.loops=0;
        _manager.volume=1.0;
        _manager.eventDelegate=nil;
        
        //监听声音打断事件
        [[NSNotificationCenter defaultCenter] addObserver:_manager selector:@selector(audioDidInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    });
    
    return _manager;
}


//重写alloc
+ (instancetype)alloc
{
    if(_manager)
    {
        return nil;
    }
    else
    {
        return [super alloc];
    }
}



#pragma -mark 注册

//通过文件路径形式注册音频(播放时加载资源)
+ (void)registAudioWithFile:(NSString *)file forKey:(NSString *)key
{
    if(file && key)
    {
        KATAudioManager *manager=[self sharedManager];
        
        if(manager.files[key])//已注册
        {
            //如果已经初始化播放器，则释放该播放器
            [self releasePlayerForKey:key];
            
            //覆盖
            manager.files[key]=file;
        }
        else//未注册
        {
            manager.files[key]=file;
        }
    }
}



#pragma -mark 控制

//启用声音，并播放所有暂停的音频
+ (void)soundOn
{
    KATAudioManager *manager=[self sharedManager];
    
    manager.isSoundOff=NO;
    
    [self play];
}


//关闭声音，并暂停所有正在播放的音频
+ (void)soundOff
{
    KATAudioManager *manager=[self sharedManager];
    
    manager.isSoundOff=YES;
    
    [self pause];
}


//播放(继续)(播放所有暂停的音频)
+ (void)play
{
    KATAudioManager *manager=[self sharedManager];
    
    if(!manager.isSoundOff)
    {
        KATArray<KATAudioPlayer *> *players=[self initalizedPlayers];
        
        for(int i=0;i<players.length;i++)
        {
            if(players[i].state==AUDIO_PLAYER_STATE_PAUSE)//暂停状态
            {
                [players[i] play];
            }
        }
    }
}


//播放指定的音频
+ (void)playForKey:(NSString *)key
{
    KATAudioManager *manager=[self sharedManager];
    
    if(!manager.isSoundOff)
    {
        KATAudioPlayer *player=[self playerForKey:key];
        
        if(player)
        {
            [player play];
        }
    }
}


//停止所有正在播放和暂停的音频
+ (void)stop
{    
    KATArray<KATAudioPlayer *> *players=[self initalizedPlayers];
    
    for(int i=0;i<players.length;i++)
    {
        if(players[i].state==AUDIO_PLAYER_STATE_PAUSE || players[i].state==AUDIO_PLAYER_STATE_PLAY)//暂停或播放状态
        {
            [players[i] stop];
        }
    }
}


//停止指定的音频
+ (void)stopForKey:(NSString *)key
{
    KATAudioPlayer *player=[self playerForKey:key];
    
    if(player)
    {
        [player stop];
    }
}


//暂停所有正在播放的音频
+ (void)pause
{
    KATArray<KATAudioPlayer *> *players=[self initalizedPlayers];
    
    for(int i=0;i<players.length;i++)
    {
        if(players[i].state==AUDIO_PLAYER_STATE_PLAY)//播放状态
        {
            [players[i] pause];
        }
    }
}


//暂停指定的音频
+ (void)pauseForKey:(NSString *)key
{
    KATAudioPlayer *player=[self playerForKey:key];
    
    if(player)
    {
        [player pause];
    }

}


//重新播放所有正在播放的音频
+ (void)replay
{
    KATAudioManager *manager=[self sharedManager];
    
    if(!manager.isSoundOff)
    {
        KATArray<KATAudioPlayer *> *players=[self initalizedPlayers];
        
        for(int i=0;i<players.length;i++)
        {
            if(players[i].state==AUDIO_PLAYER_STATE_PLAY)//播放状态
            {
                [players[i] replay];
            }
        }
    }
}


//重新播放指定的音频
+ (void)replayForKey:(NSString *)key
{
    KATAudioManager *manager=[self sharedManager];
    
    if(!manager.isSoundOff)
    {
        KATAudioPlayer *player=[self playerForKey:key];
        
        if(player)
        {
            [player replay];
        }
    }
}


#pragma -mark 设置


///为指定的音频设置参数
+ (void)setLoops:(long)loops andvVolume:(float)volume forKey:(NSString *)key
{
    KATAudioManager *manager=[self sharedManager];
    
    if(manager.files[key])//存在该资源
    {
        KATAudioPlayer *player=[self playerForKey:key];
        
        if(player)
        {
            //设置定制模式
            objc_setAssociatedObject(player, kAudioManagerModeKey, kAudioManagerModeCustom, OBJC_ASSOCIATION_COPY_NONATOMIC);
            
            //设置
            player.audioVolume=volume;
            player.playLoops=loops;
        }
    }
}


//设置全局参数（未单独设置参数的音频使用全局参数）
+ (void)setLoops:(long)loops andVolume:(float)volume
{
    KATAudioManager *manager=[self sharedManager];
    
    manager.loops=loops;
    manager.volume=volume;
    
    //设置非定制的播放器
    KATArray<KATAudioPlayer *> *players=[self initalizedPlayers];
    
    for(int i=0;i<players.length;i++)
    {
        //模式
        NSString *mode=objc_getAssociatedObject(players[i], kAudioManagerModeKey);
        
        if(mode && [mode isEqualToString:kAudioManagerModeCustom])//定制模式
        {
            //不设置
        }
        else//全局模式
        {
            //更新数据
            players[i].audioVolume=manager.volume;
            players[i].playLoops=manager.loops;
        }
    }
}


//为指定的音频设置音量
+ (void)setVolume:(float)volume forKey:(NSString *)key
{
    [self setLoops:[self playerForKey:key].playLoops andvVolume:volume forKey:key];
}


//设置全局音量
+ (void)setVolume:(float)volume
{
    KATAudioManager *manager=[self sharedManager];
    
    [self setLoops:manager.loops andVolume:volume];
}


//为指定的音频设置循环次数
+ (void)setLoops:(long)loops forKey:(NSString *)key
{
    [self setLoops:loops andvVolume:[self playerForKey:key].audioVolume forKey:key];
}


//设置全局循环次数
+ (void)setLoops:(long)loops
{
    KATAudioManager *manager=[self sharedManager];
    
    [self setLoops:loops andVolume:manager.volume];
}


//设置代理
+ (void)setAudioManagerDelegate:(id<KATAudioManagerDelegate>)delegate
{
    KATAudioManager *manager=[self sharedManager];
    
    manager.eventDelegate=delegate;
}


#pragma -mark 内容管理

//获取指定的播放器
+ (KATAudioPlayer *)playerForKey:(NSString *)key
{
    if(key)
    {
        KATAudioManager *manager=[self sharedManager];
        
        if(manager.players[key])//已有的播放器
        {
            //模式
            NSString *mode=objc_getAssociatedObject(manager.players[key], kAudioManagerModeKey);
            
            if(mode && [mode isEqualToString:kAudioManagerModeCustom])//定制模式
            {
                //不设置
            }
            else//全局模式
            {
                //更新数据
                manager.players[key].audioVolume=manager.volume;
                manager.players[key].playLoops=manager.loops;
            }
            
            return manager.players[key];
        }
        else//没有则新建
        {
            if(manager.files[key])//存在资源路径
            {
                KATAudioPlayer *player=[KATAudioPlayer playerWithPath:manager.files[key]];
                
                if(player)//创建成功
                {
                    //关联对象
                    objc_setAssociatedObject(player, kAudioManagerPlayerKey, key, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    objc_setAssociatedObject(player, kAudioManagerModeKey, kAudioManagerModeGlobal, OBJC_ASSOCIATION_COPY_NONATOMIC);//默认为全局模式
                    
                    //默认设置全局模式
                    player.audioVolume=manager.volume;
                    player.playLoops=manager.loops;
                    
                    //设置代理
                    player.eventDelegate=manager;
                    
                    manager.players[key]=player;
                    
                    return player;
                }
            }
        }
    }
    
    return nil;
}


//获取所有已初始化的播放器
+ (KATArray<KATAudioPlayer *> *)initalizedPlayers
{
    KATAudioManager *manager=[self sharedManager];
    
    return [manager.players allValues];
}


//释放指定的播放器
+ (void)releasePlayerForKey:(NSString *)key
{
    KATAudioManager *manager=[self sharedManager];
    
    if(manager.players[key])
    {
        //取消关联
        objc_removeAssociatedObjects(manager.players[key]);
        
        [manager.players deleteValueWithKey:key];
    }
}


//释放所有的播放器
+ (void)releasePlayers
{
    KATAudioManager *manager=[self sharedManager];
    
    //取消关联
    KATArray *players=[manager.players allValues];
    
    for(int i=0;i<players.length;i++)
    {
        objc_removeAssociatedObjects(players[i]);
    }
    
    [manager.players clear];
}



//释放单例
+ (void)releaseManager
{
    [_manager release];
    
    _manager=nil;
}



//播放完成回调方法
- (void)audioPlayerPlayFinished:(KATAudioPlayer *)player successfully:(BOOL)flag
{
    NSString *key=objc_getAssociatedObject(player, kAudioManagerPlayerKey);
    
    if(key)
    {
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(audioPlayFinished:forKey:)])
        {
            [_eventDelegate audioPlayFinished:flag forKey:key];
        }
    }
}


//声音打断事件处理
- (void)audioDidInterrupt:(NSNotification *)notification
{
    if(AVAudioSessionInterruptionTypeBegan==[notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue])
    {
        //停止播放
        [KATAudioManager pause];
    }
    else if(AVAudioSessionInterruptionTypeEnded==[notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue])
    {
        //继续播放
        [KATAudioManager play];
    }
}


//释放内存
- (void)dealloc
{
    //取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_players release];
    
    [super dealloc];
}



@end


