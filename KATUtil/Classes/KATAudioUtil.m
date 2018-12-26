//
//  KATAudioUtil.m
//  KATFramework
//
//  Created by kAt on 2018/9/29.
//  Copyright © 2018年 KatApp. All rights reserved.
//

#import "KATAudioUtil.h"

@implementation KATAudioUtil

#pragma -mark 类方法

//获取音频文件信息
+ (KATHashMap *)infoWithAudioFile:(NSString *)filePath
{
    //空地址检查
    if(!filePath || filePath.length==0)
    {
        return nil;
    }
    
    //AudioFile API使用的是URL来代表文件路径，所以把字符串再转换成URL
    NSURL *audioURL=[NSURL fileURLWithPath:filePath];
    
    //CoreAuido使用AudioFileID类型来指代音频文件对象
    AudioFileID audioFile;
    
    //大部分CoreAuido调用函数成功或失败的信号通过一个OSStatus类型的返回值来确认,除了noErr信号外的信号都代表发生了错误。
    OSStatus error=noErr;
    
    //通过URL打开音频文件，读取权限
    error=AudioFileOpenURL((__bridge CFURLRef)audioURL, kAudioFileReadPermission, 0, &audioFile);
    
    //调用失败判断
    if(error!=noErr)
    {
        return nil;
    }
    
    //拿文件的元数据时，会被要求提供一个元数据属性：kAudioFilePropertyInfoDictionary，需要为返回的元数据分配内存，所以声明一个变量来接收需要分配的内存的size。
    UInt32 dictionarySize=0;
    
    //获取音频文件属性信息
    error=AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0);
    
    //调用失败判断
    if(error!=noErr)
    {
        return nil;
    }
    
    //定义接收属性的字典
    CFDictionaryRef dictionary;
    
    //获取音频文件信息，存放到指定的字典中
    error=AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary);
    
    //调用失败判断
    if(error!=noErr)
    {
        return nil;
    }
    
    //改造字典
    KATHashMap *info=[KATHashMap hashMap];
    [info putWithDictionary:(__bridge NSDictionary *)dictionary];
    
    //释放字典
    CFRelease(dictionary); // 15
    
    //关闭音频资源文件
    error=AudioFileClose(audioFile);
    
    //调用失败判断
    if(error!=noErr)
    {
        return nil;
    }
    
    return info;
}


///创建正弦波单音符音频文件(音符频率hz,时长s,采样率,文件路径)
+ (BOOL)createAudioFileWithTone:(double)tone duration:(double)duration rate:(double)rate andPath:(NSString *)filePath
{
    //参数检测
    if(tone<0 || duration<0 || rate<0)
    {
        return NO;
    }
    
    //AudioFile API使用的是URL来代表文件路径，所以把字符串再转换成URL
    NSURL *fileURL=[NSURL fileURLWithPath:filePath];
    
    //创建音频描述文件
    AudioStreamBasicDescription asbd;
    
    //初始化数据(清零)
    memset(&asbd, 0, sizeof(asbd));
    
    //设置描述文件
    asbd.mFormatID=kAudioFormatLinearPCM;//格式化类型
    asbd.mSampleRate=rate;//采样率
    asbd.mBitsPerChannel=16;//使用16位采样，每一帧为2个字节
    asbd.mChannelsPerFrame=1;//单声道
    asbd.mFramesPerPacket=1;//每组1帧
    asbd.mBytesPerFrame=2;//每帧2个字节
    asbd.mBytesPerPacket=2;//每组2个字节
    asbd.mFormatFlags=kAudioFormatFlagIsBigEndian|kAudioFormatFlagIsSignedInteger|kAudioFormatFlagIsPacked;//对于PCM，必须表明你的采样是大端模式(字节或者文字的的高位在数字上对其意义的影响更大)亦或相反;同样需要表明采样的数值格式(kAudioFormatFlagIsSignedInteger);采样值使用每一个字节的所有可用位(kAudioFormatFlagIsPacked)
    
    //音频文件ID
    AudioFileID audioFile;
    
    //错误标识
    OSStatus error=noErr;
    
    //创建音频文件ID(kAudioFileFlags_EraseFile表明覆盖同名文件)
    error=AudioFileCreateWithURL((__bridge CFURLRef)fileURL, kAudioFileAIFFType, &asbd, kAudioFileFlags_EraseFile, &audioFile);
    
    //调用失败判断
    if(error!=noErr)
    {
        return NO;
    }

    //参考值
    long maxSampleCount=asbd.mSampleRate*duration;//最大采样数
    long sampleCount=0;//当前采样数
    double wavelengthInSamples=asbd.mSampleRate/tone;//计算组成一个波需要多少采样值
    SInt16 samplesBuffer[1024*64];//缓冲区
    int bufferIndex=0;//缓冲区索引
    long bytesWritten=0;//已写入的字节
    UInt32 bytesToWrite=1024*64*2;//写采样的调用需要一个指向UInt32的指针
    
    //写波形
    while(sampleCount<maxSampleCount)
    {
        for(int i=0;i<wavelengthInSamples;i++)
        {
            //正弦波(Mac和iPhone的处理器都是小端的，所以需要把CPU表示的字符切换为大端模式)
            SInt16 sample=CFSwapInt16HostToBig((SInt16)SHRT_MAX*sin(2*M_PI*(i/wavelengthInSamples)));
            
            samplesBuffer[bufferIndex]=sample;
            
            bufferIndex++;
            sampleCount++;
            
            if(bufferIndex>=1024*64)//缓冲区存满
            {
                //写入文件
                AudioFileWriteBytes(audioFile, false, bytesWritten, &bytesToWrite, &samplesBuffer);
                
                bytesWritten+=1024*64*2;
                bufferIndex=0;
            }
        }
    }
    
    //最后再把剩下的数据写入
    bytesToWrite=bufferIndex*2;
    
    AudioFileWriteBytes(audioFile, false, bytesWritten, &bytesToWrite, &samplesBuffer);
    
    
    //关闭音频资源文件
    error=AudioFileClose(audioFile);
    
    //调用失败判断
    if(error!=noErr)
    {
        return NO;
    }
    
    return YES;
}


@end
