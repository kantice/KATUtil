//
//  KATSoundPlayer.m
//  KATFramework
//
//  Created by Kantice on 14-8-27.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//

#import "KATSoundPlayer.h"

@implementation KATSoundPlayer


//震动
+ (instancetype)vibratePlayer
{
    KATSoundPlayer *player=[[[self alloc] init] autorelease];
    
    player.soundID=kSystemSoundID_Vibrate;
    
    return player;
}


//系统音效
+ (instancetype)systemPlayerWithFile:(NSString *)name andType:(NSString *)type
{
    KATSoundPlayer *player=[[[self alloc] init] autorelease];
    
    NSString *path=[[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:name ofType:type];
    
    if(path)
    {
        SystemSoundID theSoundID;
        
        OSStatus error=AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
        
        if(error==kAudioServicesNoError)
        {
            player.soundID=theSoundID;
            
            //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//            AudioServicesAddSystemSoundCompletion(player.soundID, NULL, NULL, soundCompleteCallback, NULL);
        }
        else
        {
            NSLog(@"Failed to create sound ");
        }
    }
    
    return player;
}


//自定义音效
+ (instancetype)customPlayerWithFile:(NSString *)file
{
    KATSoundPlayer *player=[[[self alloc] init] autorelease];
    
    NSURL *fileURL=[[NSBundle mainBundle] URLForResource:file withExtension:nil];
    
    if(fileURL)
    {
        SystemSoundID theSoundID;
        
        OSStatus error=AudioServicesCreateSystemSoundID((CFURLRef)fileURL, &theSoundID);
        
        if(error==kAudioServicesNoError)
        {
            player.soundID = theSoundID;
            
            //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//            AudioServicesAddSystemSoundCompletion(player.soundID, NULL, NULL, soundCompleteCallback, NULL);
        }
        else
        {
            NSLog(@"Failed to create sound!");
        }
    }

    return player;
}


//自定义音效
+ (instancetype)customPlayerWithPath:(NSString *)path
{
    KATSoundPlayer *player=[[[self alloc] init] autorelease];
    
    NSURL *fileURL=[[NSBundle mainBundle] URLForResource:path withExtension:nil];
    
    if(fileURL)
    {
        SystemSoundID theSoundID;
        
        OSStatus error=AudioServicesCreateSystemSoundID((CFURLRef)fileURL, &theSoundID);
        
        if(error==kAudioServicesNoError)
        {
            player.soundID = theSoundID;
            
            //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
            //            AudioServicesAddSystemSoundCompletion(player.soundID, NULL, NULL, soundCompleteCallback, NULL);
        }
        else
        {
            NSLog(@"Failed to create sound!");
        }
    }
    
    return player;
}


- (void)play
{
    AudioServicesPlaySystemSound(_soundID);
}


- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
    
    [super dealloc];
}


@end
