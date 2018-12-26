//
//  KATAudioUtil.h
//  KATFramework
//
//  Created by kAt on 2018/9/29.
//  Copyright © 2018年 KatApp. All rights reserved.
//  音频工具类(创建波形还有缺陷，待改进)

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "KATMacros.h"


#pragma -mark 音调

#define AUDIO_TONE_A0   27.500
#define AUDIO_TONE_AS0  29.135
#define AUDIO_TONE_B0   30.868
#define AUDIO_TONE_C1   32.703
#define AUDIO_TONE_CS1  34.648
#define AUDIO_TONE_D1   36.708
#define AUDIO_TONE_DS1  38.891
#define AUDIO_TONE_E1   41.203
#define AUDIO_TONE_F1   43.654
#define AUDIO_TONE_FS1  46.249
#define AUDIO_TONE_G1   48.999
#define AUDIO_TONE_GS1  51.913
#define AUDIO_TONE_A1   55.000
#define AUDIO_TONE_AS1  58.270
#define AUDIO_TONE_B1   61.735
#define AUDIO_TONE_C2   65.406
#define AUDIO_TONE_CS2  69.296
#define AUDIO_TONE_D2   73.416
#define AUDIO_TONE_DS2  77.782
#define AUDIO_TONE_E2   82.407
#define AUDIO_TONE_F2   87.307
#define AUDIO_TONE_FS2  92.499
#define AUDIO_TONE_G2   97.999
#define AUDIO_TONE_GS2  103.826
#define AUDIO_TONE_A2   110.000
#define AUDIO_TONE_AS2  116.541
#define AUDIO_TONE_B2   123.471
#define AUDIO_TONE_C3   130.813
#define AUDIO_TONE_CS3  138.591
#define AUDIO_TONE_D3   146.832
#define AUDIO_TONE_DS3  155.563
#define AUDIO_TONE_E3   164.814
#define AUDIO_TONE_F3   174.614
#define AUDIO_TONE_FS3  184.997
#define AUDIO_TONE_G3   195.998
#define AUDIO_TONE_GS3  207.652
#define AUDIO_TONE_A3   220.000
#define AUDIO_TONE_AS3  233.082
#define AUDIO_TONE_B3   246.942
#define AUDIO_TONE_C4   261.626
#define AUDIO_TONE_CS4  277.183
#define AUDIO_TONE_D4   293.665
#define AUDIO_TONE_DS4  311.127
#define AUDIO_TONE_E4   329.628
#define AUDIO_TONE_F4   349.228
#define AUDIO_TONE_FS4  369.994
#define AUDIO_TONE_G4   391.995
#define AUDIO_TONE_GS4  415.305
#define AUDIO_TONE_A4   440.000
#define AUDIO_TONE_AS4  466.164
#define AUDIO_TONE_B4   493.883
#define AUDIO_TONE_C5   523.251
#define AUDIO_TONE_CS5  554.365
#define AUDIO_TONE_D5   587.330
#define AUDIO_TONE_DS5  622.254
#define AUDIO_TONE_E5   659.255
#define AUDIO_TONE_F5   698.456
#define AUDIO_TONE_FS5  739.989
#define AUDIO_TONE_G5   783.991
#define AUDIO_TONE_GS5  830.609
#define AUDIO_TONE_A5   880.000
#define AUDIO_TONE_AS5  932.328
#define AUDIO_TONE_B5   987.767
#define AUDIO_TONE_C6   1046.502
#define AUDIO_TONE_CS6  1108.731
#define AUDIO_TONE_D6   1174.659
#define AUDIO_TONE_DS6  1244.508
#define AUDIO_TONE_E6   1318.510
#define AUDIO_TONE_F6   1396.913
#define AUDIO_TONE_FS6  1479.978
#define AUDIO_TONE_G6   1567.982
#define AUDIO_TONE_GS6  1661.219
#define AUDIO_TONE_A6   1760.000
#define AUDIO_TONE_AS6  1864.655
#define AUDIO_TONE_B6   1975.533
#define AUDIO_TONE_C7   2093.005
#define AUDIO_TONE_CS7  2217.461
#define AUDIO_TONE_D7   2349.318
#define AUDIO_TONE_DS7  2489.016
#define AUDIO_TONE_E7   2637.020
#define AUDIO_TONE_F7   2793.826
#define AUDIO_TONE_FS7  2959.955
#define AUDIO_TONE_G7   3135.963
#define AUDIO_TONE_GS7  3322.438
#define AUDIO_TONE_A7   3520.000
#define AUDIO_TONE_AS7  3729.310
#define AUDIO_TONE_B7   3951.066
#define AUDIO_TONE_C8   4186.009

#pragma -mark 音分

#define AUDIO_TONE_STEP     1.0594630943593
#define AUDIO_TONE_STEP_2   1.112462
#define AUDIO_TONE_STEP_3   1.189207
#define AUDIO_TONE_STEP_4   1.259921
#define AUDIO_TONE_STEP_5   1.334840
#define AUDIO_TONE_STEP_6   1.414214
#define AUDIO_TONE_STEP_7   1.498307
#define AUDIO_TONE_STEP_8   1.587401
#define AUDIO_TONE_STEP_9   1.681793
#define AUDIO_TONE_STEP_10  1.781797
#define AUDIO_TONE_STEP_11  1.887749
#define AUDIO_TONE_STEP_12  2.0

///默认采样率
#define AUDIO_SAMPLE_RATE_DEFAULT 44100.0



@interface KATAudioUtil : NSObject

#pragma -mark 类方法

///获取音频文件信息
+ (KATHashMap *)infoWithAudioFile:(NSString *)filePath;

///创建正弦波单音符音频文件(音符频率hz,时长s,采样率,文件路径)
+ (BOOL)createAudioFileWithTone:(double)tone duration:(double)duration rate:(double)rate andPath:(NSString *)filePath;


@end

