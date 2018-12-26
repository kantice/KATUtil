//
//  KATHttpTask.m
//  KATFramework
//
//  Created by Kantice on 16/7/21.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATHttpTask.h"
#import "KATHttpSession.h"



@implementation KATHttpTask


#pragma -mark 类方法

///获取实例
+ (instancetype)task
{
    return [[[self alloc] init] autorelease];
}


//初始化
- (instancetype)init
{
    self=[super init];
    
    self.showNetworkStatus=YES;
    self.cacheMode=HTTP_CACHE_DEFAULT;
    self.timeoutInterval=HTTP_REQUEST_TIMEOUT;
    self.task=nil;
    self.type=TASK_TYPE_NONE;
    self.downloadPath=nil;
    self.session=nil;
    self.tag=0;
    self.message=nil;
    self.contentType=nil;
    self.headerFields=nil;
    self.eventDelegate=nil;
    
    return self;
}



#pragma -mark 对象方法

//用get请求方式获取数据（异步）
- (void)getWithUrl:(NSString *)url andCallback:(void (^)(NSData *returnData))callback
{
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }

    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_GET];
    
    //请求类型
    if(_contentType)
    {
        //通过请求头设置数据请求类型
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    //头属性
    if(_headerFields)
    {
        KATArray<NSString *> *keys=[_headerFields allKeys];
        
        for(NSString *key in keys)
        {
            if(_headerFields[key])
            {
                [request setValue:_headerFields[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //创建会话（使用全局会话）
    NSURLSession *session=[NSURLSession sharedSession];
    
    //从会话创建任务
    self.task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        [request release];
        
        [KATAppUtil setNetworkStateActive:NO];
        
        if(!error && [(NSHTTPURLResponse *)response statusCode]/100==2)
        {
            if(callback)
            {
                callback(data);
            }
        }
        else
        {
            NSLog(@"KATHttpTask Error:%@ (return code:%li)",error.localizedDescription,(long)[(NSHTTPURLResponse *)response statusCode]);
            
            if(callback)
            {
                callback(nil);
            }
        }
    }];
    
    _type=TASK_TYPE_DATA;
    
    [_task resume];//恢复线程，启动任务
}


//用post请求方式发送数据，获取数据（异步）
- (void)postWithUrl:(NSString *)url sendData:(NSData *)data andCallback:(void (^)(NSData *returnData))callback
{
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    //请求类型
    if(_contentType)
    {
        //通过请求头设置数据请求类型
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    //头属性
    if(_headerFields)
    {
        KATArray<NSString *> *keys=[_headerFields allKeys];
        
        for(NSString *key in keys)
        {
            if(_headerFields[key])
            {
                [request setValue:_headerFields[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //设置数据
    request.HTTPBody=data;
    
    //创建会话（使用全局会话）
    NSURLSession *session=[NSURLSession sharedSession];
    
    //从会话创建任务
    self.task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        [request release];
        
        [KATAppUtil setNetworkStateActive:NO];
        
        if(!error && [(NSHTTPURLResponse *)response statusCode]/100==2)
        {
            if(callback)
            {
                callback(data);
            }
        }
        else
        {
            NSLog(@"KATHttpTask Error:%@ (return code:%li)",error.localizedDescription,(long)[(NSHTTPURLResponse *)response statusCode]);
            
            if(callback)
            {
                callback(nil);
            }
        }
    }];
    
    _type=TASK_TYPE_DATA;
    
    [_task resume];//恢复线程，启动任务
}


//下载文件到指定的目录，判断是否替换原文件(异步)
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable andCallback:(void (^)(BOOL success))callback
{
    if(!file || !url)
    {
        return;
    }
    
    //判断文件是否存在
    BOOL fileExists=[KATFileUtil existsFile:file];
    
    if(fileExists && !replaceable)//文件已存在且不替换
    {
        if(callback)
        {
            callback(YES);
        }
        
        return;
    }
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_GET];
    
    //请求类型
    if(_contentType)
    {
        //通过请求头设置数据请求类型
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    //头属性
    if(_headerFields)
    {
        KATArray<NSString *> *keys=[_headerFields allKeys];
        
        for(NSString *key in keys)
        {
            if(_headerFields[key])
            {
                [request setValue:_headerFields[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //创建会话（使用全局会话）
    NSURLSession *session=[NSURLSession sharedSession];
    
    //从会话创建任务
    self.task=[session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [request release];
        
        [KATAppUtil setNetworkStateActive:NO];
        
        if(!error && [(NSHTTPURLResponse *)response statusCode]/100==2)
        {
            if([KATFileUtil existsFile:file])//如果文件已经存在，则先删除
            {
                [KATFileUtil removeFile:file];
            }
            
            //注意location是下载后的临时保存路径,需要将它移动到需要保存的位置
            if([KATFileUtil moveFile:[[location absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""] toPath:file])
            {
                if(callback)
                {
                    callback(YES);
                }
            }
            else
            {
                if(callback)
                {
                    callback(NO);
                }
            }
        }
        else
        {
            NSLog(@"KATHttpTask Error:%@ (return code:%li)",error.localizedDescription,(long)[(NSHTTPURLResponse *)response statusCode]);
            
            if(callback)
            {
                callback(NO);
            }
        } 
    }];
    
    _type=TASK_TYPE_DOWNLOAD;

    [_task resume];//恢复线程，启动任务
}



//上传文件，设置表单属性名称（异步）
- (void)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name andCallback:(void (^)(NSData *returnData))callback
{
    if(!file || !url || !name)
    {
        if(callback)
        {
            callback(nil);
        }
        
        return ;
    }
    
    //判断文件是否存在
    if(![KATFileUtil existsFile:file])
    {
        if(callback)
        {
            callback(nil);
        }
        
        return ;
    }
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //构建上传数据
    NSMutableData *data=[NSMutableData data];
    
    //设置头内容
    [data appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",HTTP_FILE_UPLOAD_BOUNDARY,name,[KATFileUtil fileNameWithUrl:file],[KATHttpUtil MIMETypeWithFile:file]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置文件内容
    [data appendData:[NSData dataWithContentsOfFile:file]];
    
    //设置尾内容
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--",HTTP_FILE_UPLOAD_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    //通过请求头设置
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",HTTP_FILE_UPLOAD_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    //设置数据体
    request.HTTPBody=data;
    
    //创建会话（使用全局会话）
    NSURLSession *session=[NSURLSession sharedSession];
    
    //从会话创建任务
    self.task=[session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [request release];
        
        [KATAppUtil setNetworkStateActive:NO];
        
        if(!error && [(NSHTTPURLResponse *)response statusCode]/100==2)
        {
            if(callback)
            {
                callback(data);
            }
        }
        else
        {
            NSLog(@"KATHttpTask Error:%@ (return code:%li)",error.localizedDescription,(long)[(NSHTTPURLResponse *)response statusCode]);
            
            if(callback)
            {
                callback(nil);
            }
        }
    }];
    
    _type=TASK_TYPE_UPLOAD;
    
    [_task resume];
}


//用get请求方式获取数据（指定的Session，用代理回调）
- (void)getWithUrl:(NSString *)url andSession:(KATHttpSession *)session
{
    if(!session)
    {
        return;
    }
    
    self.session=session;
    
    //加入数组
    [_session.tasks put:self];
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_GET];
    
    //请求类型
    if(_contentType)
    {
        //通过请求头设置数据请求类型
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    //头属性
    if(_headerFields)
    {
        KATArray<NSString *> *keys=[_headerFields allKeys];
        
        for(NSString *key in keys)
        {
            if(_headerFields[key])
            {
                [request setValue:_headerFields[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //从会话中创建任务
    self.task=[_session.session dataTaskWithRequest:request];
    
    _type=TASK_TYPE_DATA;
    
    [_task resume];//恢复线程，启动任务
}


//用post请求方式发送数据，获取数据（指定的Session，用代理回调）
- (void)postWithUrl:(NSString *)url sendData:(NSData *)data andSession:(KATHttpSession *)session
{
    if(!session)
    {
        return;
    }
    
    self.session=session;
    
    //加入数组
    [_session.tasks put:self];
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    //请求类型
    if(_contentType)
    {
        //通过请求头设置数据请求类型
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    //头属性
    if(_headerFields)
    {
        KATArray<NSString *> *keys=[_headerFields allKeys];
        
        for(NSString *key in keys)
        {
            if(_headerFields[key])
            {
                [request setValue:_headerFields[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //设置数据
    request.HTTPBody=data;
    
    //从会话中创建任务
    self.task=[_session.session dataTaskWithRequest:request];
    
    _type=TASK_TYPE_DATA;
    
    [_task resume];//恢复线程，启动任务
}


//下载文件到指定的目录，判断是否替换原文件（指定的Session，用代理回调）
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable andSession:(KATHttpSession *)session
{
    if(!file || !url)
    {
        return;
    }
    
    //判断文件是否存在
    BOOL fileExists=[KATFileUtil existsFile:file];
    
    if(fileExists && !replaceable)//文件已存在且不替换
    {
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(task:didFinishDownloadSucceed:)])
        {
            [_eventDelegate task:self didFinishDownloadSucceed:YES];
        }
        
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(task:didFinishSucceed:)])
        {
            [_eventDelegate task:self didFinishSucceed:YES];
        }
        
        return;
    }
    
    if(!session)
    {
        return;
    }
    
    self.session=session;
    self.downloadPath=file;
    
    //加入数组
    [_session.tasks put:self];
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_GET];
    
    //请求类型
    if(_contentType)
    {
        //通过请求头设置数据请求类型
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    //头属性
    if(_headerFields)
    {
        KATArray<NSString *> *keys=[_headerFields allKeys];
        
        for(NSString *key in keys)
        {
            if(_headerFields[key])
            {
                [request setValue:_headerFields[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //从会话中创建任务
    self.task=[_session.session downloadTaskWithRequest:request];
    
    _type=TASK_TYPE_DOWNLOAD;
    
    [_task resume];//恢复线程，启动任务
}


//上传文件，设置表单属性名称（指定的Session，用代理回调）
- (void)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name andSession:(KATHttpSession *)session
{
    if(!file || !url || !name)
    {
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(task:didFinishSucceed:)])
        {
            [_eventDelegate task:self didFinishSucceed:NO];
        }
        
        return ;
    }
    
    //判断文件是否存在
    if(![KATFileUtil existsFile:file])
    {
        if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(task:didFinishSucceed:)])
        {
            [_eventDelegate task:self didFinishSucceed:NO];
        }
        
        return ;
    }
    
    if(!session)
    {
        return;
    }
    
    self.session=session;
    
    //加入数组
    [_session.tasks put:self];
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //构建上传数据
    NSMutableData *data=[NSMutableData data];
    
    //设置头内容
    [data appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",HTTP_FILE_UPLOAD_BOUNDARY,name,[KATFileUtil fileNameWithUrl:file],[KATHttpUtil MIMETypeWithFile:file]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置文件内容
    [data appendData:[NSData dataWithContentsOfFile:file]];
    
    //设置尾内容
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--",HTTP_FILE_UPLOAD_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval];
    
    //设置请求模式
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    //通过请求头设置
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",HTTP_FILE_UPLOAD_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    //设置数据体
    request.HTTPBody=data;
    
    //从会话中创建任务
    self.task=[_session.session uploadTaskWithStreamedRequest:request];
    
    _type=TASK_TYPE_UPLOAD;
    
    [_task resume];
}



//继续
- (void)resume
{
    if(_task)
    {
        [_task resume];
    }
}


//取消
- (void)cancel
{
    if(_task)
    {
        [_task cancel];
    }
}


//挂起
- (void)suspend
{
    if(_task)
    {
        [_task suspend];
    }
}




//释放内存
- (void)dealloc
{
    [_task cancel];
    
    [_task release];
    [_message release];
    [_downloadPath release];
    [_contentType release];
    [_headerFields release];
    
    [super dealloc];
}



@end
