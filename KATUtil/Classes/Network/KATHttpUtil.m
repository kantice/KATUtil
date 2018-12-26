//
//  KATHttpUtil.m
//  KATFramework
//
//  Created by Kantice on 13-11-28.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATHttpUtil.h"
#import "KATAppUtil.h"

@implementation KATHttpUtil


#pragma mark - 类方法



//Post方式发送字符串，返回字符串
+ (NSString *)postText:(NSString *)text toHost:(NSString *)host andAddress:(NSString *)address
{
    [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
    
    NSString *url=[KATStringUtil httpHeaderWithUrl:[NSString stringWithFormat:@"%@%@",host,address]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    request.HTTPMethod=@"POST";
    request.HTTPBody=[text dataUsingEncoding:NSUTF8StringEncoding];
    request.timeoutInterval=HTTP_REQUEST_TIMEOUT;
    
    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str=[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    
    [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
    
    return str;
}


//Post方式发送字符串，返回字符串
+ (NSString *)postText:(NSString *)text toUrl:(NSString *)url
{
    [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
    
    url=[KATStringUtil httpHeaderWithUrl:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    request.HTTPMethod=@"POST";
    request.HTTPBody=[text dataUsingEncoding:NSUTF8StringEncoding];
    request.timeoutInterval=HTTP_REQUEST_TIMEOUT;
    
    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str=[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    
    [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
    
    return str;
}



//Get方式访问，返回字符串
+ (NSString *)getText:(NSString *)params toHost:(NSString *)host andAddress:(NSString *)address
{
    [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
    
    NSString *url=[KATStringUtil httpHeaderWithUrl:[NSString stringWithFormat:@"%@%@?%@",host,address,params]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval=HTTP_REQUEST_TIMEOUT;//设置超时，POST无效
    
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* str=[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    
    [request release];
    request=nil;
    
    [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
    
    return str;
}


//Get方式访问，返回字符串
+ (NSString *)getText:(NSString *)params toUrl:(NSString *)url
{
    [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
    
    url=[KATStringUtil httpHeaderWithUrl:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval=HTTP_REQUEST_TIMEOUT;//设置超时，POST无效
    
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* str=[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    
    [request release];
    request=nil;
    
    [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
    
    return str;
}


//Get方式访问url，返回字符串
+ (NSString *)getUrl:(NSString *)url
{
    [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
    
    url=[KATStringUtil httpHeaderWithUrl:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval=HTTP_REQUEST_TIMEOUT;//设置超时，POST无效
    
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* str=[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    
    [request release];
    request=nil;
    
    [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
    
    return str;
}


//下载文件到指定的目录
+ (BOOL)downloadFile:(NSString *)file fromHost:(NSString *)host andAddress:(NSString *)address
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:false])//判断是非已经存在该文件
    {
        [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
        
        NSString *url=[KATStringUtil httpHeaderWithUrl:[NSString stringWithFormat:@"%@%@",host,address]];
        
        NSData *remoteData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
        [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
        
        if(remoteData)
        {
            return [remoteData writeToFile:file atomically:YES];
        }
        else
        {
            return NO;
        }

    }
    else
    {
        return YES;
    }
    
}


//下载文件到指定的目录
+ (BOOL)downloadFile:(NSString *)file fromUrl:(NSString *)url
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:false])//判断是否已经存在该文件
    {
        [KATAppUtil setNetworkStateActive:YES];//显示状态栏的网络活动指示器
        
        url=[KATStringUtil httpHeaderWithUrl:url];
        NSData *remoteData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        [KATAppUtil setNetworkStateActive:NO];//关闭状态栏的网络活动指示器
        
        if(remoteData)
        {
            return [remoteData writeToFile:file atomically:YES];
        }
        else
        {
            return NO;
        }        
    }
    else
    {
        return YES;
    }
    
}



//获取所有的cookie
+ (KATArray<NSHTTPCookie *> *)getCookies
{
    KATArray<NSHTTPCookie *> *cookies=[KATArray arrayWithCapacity:32];
    
    NSHTTPCookieStorage *cookieJar=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for(NSHTTPCookie *cookie in [cookieJar cookies])
    {
        [cookies put:cookie];
    }
    
    return cookies;
}



//清除所有的cookie
+ (void)clearCookies
{
    NSHTTPCookieStorage *cookieJar=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieArray=[NSArray arrayWithArray:[cookieJar cookies]];
    
    for(id obj in cookieArray)
    {
        [cookieJar deleteCookie:obj];
    }
}


///添加cookie
+ (void)addCookie:(NSHTTPCookie *)cookie
{
    if(cookie)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}


//获取mime类型
+ (NSString *)MIMETypeWithFile:(NSString *)file
{
    //获取扩展名
    NSString *ext=[KATFileUtil extensionWithFile:file];
    
    if(ext)
    {
        if([ext isEqualToString:@"htm"] || [ext isEqualToString:@"html"])
        {
            return MIME_TYPE_HTML;
        }
        else if([ext isEqualToString:@"txt"] || [ext isEqualToString:@"c"] || [ext isEqualToString:@"h"])
        {
            return MIME_TYPE_TEXT;
        }
        else if([ext isEqualToString:@"rtf"] || [ext isEqualToString:@"rtx"])
        {
            return MIME_TYPE_RICH;
        }
        else if([ext isEqualToString:@"gif"])
        {
            return MIME_TYPE_GIF;
        }
        else if([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"])
        {
            return MIME_TYPE_JPG;
        }
        else if([ext isEqualToString:@"png"])
        {
            return MIME_TYPE_PNG;
        }
        else if([ext isEqualToString:@"au"] || [ext isEqualToString:@"snd"])
        {
            return MIME_TYPE_AUDIO;
        }
        else if([ext isEqualToString:@"mid"])
        {
            return MIME_TYPE_MID;
        }
        else if([ext isEqualToString:@"ra"] || [ext isEqualToString:@"ram"])
        {
            return MIME_TYPE_RAM;
        }
        else if([ext isEqualToString:@"mpeg"] || [ext isEqualToString:@"mp4"])
        {
            return MIME_TYPE_MPEG;
        }
        else if([ext isEqualToString:@"mp3"])
        {
            return MIME_TYPE_MP3;
        }
        else if([ext isEqualToString:@"avi"])
        {
            return MIME_TYPE_AVI;
        }
        else if([ext isEqualToString:@"gz"])
        {
            return MIME_TYPE_GZ;
        }
        else if([ext isEqualToString:@"tar"])
        {
            return MIME_TYPE_TAR;
        }
        else if([ext isEqualToString:@"exe"])
        {
            return MIME_TYPE_EXE;
        }
        else if([ext isEqualToString:@"zip"])
        {
            return MIME_TYPE_ZIP;
        }
        else if([ext isEqualToString:@"swf"])
        {
            return MIME_TYPE_FLASH;
        }
        else if([ext isEqualToString:@"wav"])
        {
            return MIME_TYPE_WAV;
        }
        else if([ext isEqualToString:@"xls"] || [ext isEqualToString:@"xlsx"])
        {
            return MIME_TYPE_EXCEL;
        }
        else if([ext isEqualToString:@"doc"] || [ext isEqualToString:@"docx"])
        {
            return MIME_TYPE_WORD;
        }
        else if([ext isEqualToString:@"chm"])
        {
            return MIME_TYPE_CHM;
        }
        else if([ext isEqualToString:@"ppt"] || [ext isEqualToString:@"pptx"])
        {
            return MIME_TYPE_PPT;
        }
        else if([ext isEqualToString:@"pdf"])
        {
            return MIME_TYPE_PDF;
        }
        else if([ext isEqualToString:@"m4a"])
        {
            return MIME_TYPE_M4A;
        }
        else if([ext isEqualToString:@"m4v"])
        {
            return MIME_TYPE_M4V;
        }
        else if([ext isEqualToString:@".torrent"] || [ext isEqualToString:@".7z"] || [ext isEqualToString:@".iso"] || [ext isEqualToString:@".dmg"])
        {
            return MIME_TYPE_STREAM;
        }
        else if([ext isEqualToString:@"app"] || [ext isEqualToString:@"ipa"] || [ext isEqualToString:@"pxl"] || [ext isEqualToString:@"ded"])
        {
            return MIME_TYPE_IPHONE;
        }
        else if([ext isEqualToString:@"apk"])
        {
            return MIME_TYPE_ANDROID;
        }
    }
    
    return nil;
}


//获取网络状态
+ (int)networkStatus
{
    return [[KATReachability reachabilityForInternetConnection] currentReachabilityStatus];
}


//针对某个主机的网络状态
+ (int)networkStatusWithHost:(NSString *)host
{
    return [[KATReachability reachabilityWithHostName:host] currentReachabilityStatus];
}




@end
