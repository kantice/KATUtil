//
//  KATHttpSession.m
//  KATFramework
//
//  Created by Kantice on 16/7/22.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATHttpSession.h"



@implementation KATHttpSession


#pragma -mark 类方法

//通过配置获取实例
+ (instancetype)sessionWithType:(int)type andConfig:(NSURLSessionConfiguration *)config delegateQueue:(NSOperationQueue *)queue
{
    if(config)
    {
        KATHttpSession *session=[[[self alloc] init] autorelease];
        
        session.tasks=[KATArray arrayWithCapacity:32];
        session.session=[NSURLSession sessionWithConfiguration:config delegate:session delegateQueue:queue];
        session.eventDelegate=nil;
        
        return session;
    }
    
    return nil;
}


//通过参数获取实例
+ (instancetype)sessionWithType:(int)type andCacheMode:(int)cacheMode timeout:(double)timeout cellularAccess:(BOOL)cellularAccess delegateQueue:(NSOperationQueue *)queue
{
    NSURLSessionConfiguration *config=nil;
    
    if(type==SESSION_TYPE_DEFAULT)
    {
        config=[NSURLSessionConfiguration defaultSessionConfiguration];
    }
    else if(type==SESSION_TYPE_EPHEMERAL)
    {
        config=[NSURLSessionConfiguration ephemeralSessionConfiguration];
    }
    else if(type==SESSION_TYPE_BACKGROUND)
    {
        config=[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:SESSION_BACKGROUND_ID];
    }
    
    if(config)
    {
        config.requestCachePolicy=cacheMode;
        config.timeoutIntervalForRequest=timeout;
        config.timeoutIntervalForResource=timeout;
        config.allowsCellularAccess=cellularAccess;
        config.HTTPMaximumConnectionsPerHost=SESSION_HOST_CONNECTION_MAX;
        config.discretionary=YES;
        
        KATHttpSession *session=[[[self alloc] init] autorelease];
        
        session.tasks=[KATArray arrayWithCapacity:32];
        session.session=[NSURLSession sessionWithConfiguration:config delegate:session delegateQueue:queue];
        session.eventDelegate=nil;
        
        return session;
    }
    else
    {
        return nil;
    }
}


//获取默认的实例(代理线程队列为主线程队列)
+ (instancetype)sessionWithType:(int)type
{
    return [self sessionWithType:type andCacheMode:HTTP_CACHE_DEFAULT timeout:SESSION_TIMEOUT_DEFAULT cellularAccess:YES delegateQueue:[NSOperationQueue mainQueue]];
}


#pragma -mark 对象方法

//失效（失效后不能再使用该会话）
- (void)invalidate;
{
    if(_session)
    {
        [_session finishTasksAndInvalidate];
    }
}


#pragma -mark 回调函数

//会话终止
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(sessionDidInvalid:)])
    {
        [_eventDelegate sessionDidInvalid:self];
    }
}


//后台会话完成
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(sessionDidFinishBackgroundTasks:)])
    {
        [_eventDelegate sessionDidFinishBackgroundTasks:self];
    }
    
    /*应在代理中加入该段代码，执行AppDelegate中完成后台任务后的回调代码，（不加入也无所谓）
    
    KATAppDelegate *appDelegate=(KATAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.backgroundSessionCompletionHandler)
    {
        
        void (^completionHandler)()=appDelegate.backgroundSessionCompletionHandler;
        
        completionHandler();
     
        Block_release(appDelegate.backgroundSessionCompletionHandler);
        appDelegate.backgroundSessionCompletionHandler=nil;
    }
    */
}


//任务完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(_tasks)
    {
        for(int i=0;i<_tasks.length;i++)
        {
            if([[_tasks get:i] isKindOfClass:[KATHttpTask class]])
            {
                KATHttpTask *t=(KATHttpTask *)[_tasks get:i];
                
                if(task==t.task)
                {
                    if(t.eventDelegate && [t.eventDelegate respondsToSelector:@selector(task:didFinishSucceed:)])
                    {
                        [t.eventDelegate task:t didFinishSucceed:(error?NO:YES)];
                    }
                    
                    //任务完成后移除数组
                    [_tasks deleteMember:t];
                    
                    //全部任务完成后关闭网络指示器
                    if(_tasks.length==0)
                    {
                        [KATAppUtil setNetworkStateActive:NO];
                    }
                    
                    break;
                }
            }
        }
    }
}


//下载任务完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if(_tasks)
    {
        for(int i=0;i<_tasks.length;i++)
        {
            if([[_tasks get:i] isKindOfClass:[KATHttpTask class]])
            {
                KATHttpTask *task=(KATHttpTask *)[_tasks get:i];
                
                if(downloadTask==task.task)
                {
                    //转移文件到下载路径
                    BOOL succeed=NO;
                    
                    if(task.downloadPath)
                    {
                        if([KATFileUtil existsFile:task.downloadPath])//如果文件已经存在，则先删除
                        {
                            [KATFileUtil removeFile:task.downloadPath];
                        }
                        
                        succeed=[KATFileUtil moveFile:[[location absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""] toPath:task.downloadPath];
                    }
                    
                    if(task.type==TASK_TYPE_DOWNLOAD && task.eventDelegate && [task.eventDelegate respondsToSelector:@selector(task:didFinishSucceed:)])
                    {
                        [task.eventDelegate task:task didFinishDownloadSucceed:succeed];
                    }
                    
                    break;
                }
            }
        }
    }
}


//下载任务进行中
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if(_tasks)
    {
        for(int i=0;i<_tasks.length;i++)
        {
            if([[_tasks get:i] isKindOfClass:[KATHttpTask class]])
            {
                KATHttpTask *task=(KATHttpTask *)[_tasks get:i];
                
                if(downloadTask==task.task)
                {
                    if(task.type==TASK_TYPE_DOWNLOAD && task.eventDelegate && [task.eventDelegate respondsToSelector:@selector(task:didDownloadData:withTotalData:)])
                    {
                        [task.eventDelegate task:task didDownloadData:totalBytesWritten withTotalData:totalBytesExpectedToWrite];
                    }
                    
                    break;
                }
            }
        }
    }
}


//获取到数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if(_tasks)
    {
        for(int i=0;i<_tasks.length;i++)
        {
            if([[_tasks get:i] isKindOfClass:[KATHttpTask class]])
            {
                KATHttpTask *task=(KATHttpTask *)[_tasks get:i];
                
                if(dataTask==task.task)
                {
                    if(task.type==TASK_TYPE_DATA && task.eventDelegate && [task.eventDelegate respondsToSelector:@selector(task:didReceiveData:)])
                    {
                        [task.eventDelegate task:task didReceiveData:data];
                    }
                    
                    break;
                }
            }
        }
    }
}



//释放内存
- (void)dealloc
{
    [_session release];
    [_tasks release];
    
    [super dealloc];
}

@end
