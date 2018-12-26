//
//  KATSoundPlayer.h
//  KATFramework
//
//  Created by Kantice on 14-8-27.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//  音效播放器

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>



@interface KATSoundPlayer : NSObject


#pragma -mark 属性

@property(nonatomic,assign) SystemSoundID soundID;


#pragma -mark 类方法

///震动
+ (instancetype)vibratePlayer;

///系统音效
+ (instancetype)systemPlayerWithFile:(NSString *)name andType:(NSString *)type;

///自定义音效
+ (instancetype)customPlayerWithFile:(NSString *)file;

///自定义音效
+ (instancetype)customPlayerWithPath:(NSString *)path;


#pragma -mark 对象方法

///播放
- (void)play;


///释放内存
- (void)dealloc;


@end


