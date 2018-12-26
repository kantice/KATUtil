//
//  KATHttpRequest.m
//  KATFramework
//
//  Created by Kantice on 16/6/13.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATHttpRequest.h"



@interface KATHttpRequest ()

///响应的内容长度
@property(nonatomic,assign) long long contentLength;

///响应的数据类型
@property(nonatomic,copy) NSString *MIMEType;

///响应的URL
@property(nonatomic,retain) NSURL *responseURL;

///响应的Http头信息
@property(nonatomic,retain) KATHashMap *responseHeader;


@end



@implementation KATHttpRequest


//获取实例
+ (instancetype)request
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
    self.contentType=nil;
    self.responseHeader=nil;
    self.eventDelegate=nil;
    self.downloadCanceled=NO;
    self.headerFields=nil;
    
    return self;
}


#pragma -mark 通用方法(一般不直接用)

//同步通用方法：地址、请求方式、返回的数据范围、发送的数据（Post）
- (NSData *)requestWithUrl:(NSString *)url method:(NSString *)method hasRange:(BOOL)hasRange rangeStart:(long long)start rangeEnd:(long long)end sendData:(NSData *)sendData
{
    //检查数据格式
    if(![self checkWithUrl:url Method:method hasRange:hasRange rangeStart:start rangeEnd:end])
    {
        return nil;
    }
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //URL处理
    url=[KATStringUtil httpHeaderWithUrl:url];
    
    //生产请求
    NSMutableURLRequest *request=[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval] autorelease];
    
    //设置请求模式
    [request setHTTPMethod:method];
    
    //设置请求数据范围
    if(hasRange)
    {
        NSString *range=[NSString stringWithFormat:@"Bytes=%lli-%lli",start,end];
        
        //通过请求头设置数据请求范围
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    
    //POST请求发送的数据
    if([method isEqualToString:HTTP_REQUEST_POST] && sendData)
    {
        request.HTTPBody=sendData;
    }
    
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
    
    //返回的数据
    NSURLResponse *response=nil;
    NSError *error=nil;
    NSData *returnData=nil;
    
    //清除响应头
    self.responseHeader=nil;
    
    //发送请求
    returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error || [(NSHTTPURLResponse *)response statusCode]/100!=2)//发生错误，或访问失败
    {
        NSLog(@"KATHttp Error:%@ (return code:%li)",error,(long)[(NSHTTPURLResponse *)response statusCode]);
        
        returnData=nil;
    }
    else//成功
    {
        //获取返回头信息
        _contentLength=response.expectedContentLength;
        self.MIMEType=response.MIMEType;
        self.responseURL=response.URL;
        
        self.responseHeader=[KATHashMap hashMapWithCapacity:32 andMaxUsage:80];
        
        NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
        [_responseHeader putWithDictionary:fields];
    }
    
    //隐藏网络状态
    [KATAppUtil setNetworkStateActive:NO];
    
    return returnData;
}



//异步通用方法：地址、请求方式、返回的数据范围、发送的数据（Post）
- (void)requestWithUrl:(NSString *)url method:(NSString *)method hasRange:(BOOL)hasRange rangeStart:(long long)start rangeEnd:(long long)end sendData:(NSData *)sendData andandCallback:(void (^)(NSData *returnData))callback
{
    //检查数据格式
    if(![self checkWithUrl:url Method:method hasRange:hasRange rangeStart:start rangeEnd:end])
    {
        if(callback)
        {
            callback(nil);
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
    NSMutableURLRequest *request=[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:_cacheMode timeoutInterval:_timeoutInterval] autorelease];
    
    //设置请求模式
    [request setHTTPMethod:method];
    
    //设置请求数据范围
    if(hasRange)
    {
        NSString *range=[NSString stringWithFormat:@"Bytes=%lli-%lli",start,end];
        
        //通过请求头设置数据请求类型
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    
    //POST请求发送的数据
    if([method isEqualToString:HTTP_REQUEST_POST] && sendData)
    {
        request.HTTPBody=sendData;
    }
    
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
    
    //清除响应头
    self.responseHeader=nil;
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [KATAppUtil setNetworkStateActive:NO];
            
            if(connectionError || [(NSHTTPURLResponse *)response statusCode]/100!=2)//访问失败
            {
                NSLog(@"KATHttp Error:%@ (return code:%li)",connectionError.localizedDescription,(long)[(NSHTTPURLResponse *)response statusCode]);
                
                if(callback)
                {
                    callback(nil);
                }
            }
            else//访问成功
            {
                //获取返回头信息
                _contentLength=response.expectedContentLength;
                self.MIMEType=response.MIMEType;
                self.responseURL=response.URL;
                
                self.responseHeader=[KATHashMap hashMapWithCapacity:32 andMaxUsage:80];
                
                NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
                [_responseHeader putWithDictionary:fields];
                
                if(callback)
                {
                    callback(data);
                }
            }
        });
    }];
}


//内部方法：检查参数是否正确
- (BOOL)checkWithUrl:(NSString *)url Method:(NSString *)method hasRange:(BOOL)hasRange rangeStart:(long long)start rangeEnd:(long long)end
{
    BOOL checkout=YES;
    
    if(!url)
    {
        checkout=NO;
    }
    
    if(!method)
    {
        checkout=NO;
    }
    
    if(!([method isEqualToString:HTTP_REQUEST_GET] || [method isEqualToString:HTTP_REQUEST_POST] || [method isEqualToString:HTTP_REQUEST_HEAD]))
    {
        checkout=NO;
    }
    
    if(hasRange && start>end)
    {
        checkout=NO;
    }
    
    return checkout;
}


#pragma -mark GET请求

//用get请求方式获取数据（同步）
- (NSData *)getDataWithUrl:(NSString *)url
{
    return [self requestWithUrl:url method:HTTP_REQUEST_GET hasRange:NO rangeStart:0 rangeEnd:0 sendData:nil];
}


//用get请求方式获取文本（同步）
- (NSString *)getTextWithUrl:(NSString *)url
{
    NSData *returnData=[self getDataWithUrl:url];
    
    if(returnData)
    {
        return [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {
        return nil;
    }
}


//用get请求方式获取数据（异步）
- (void)getDataWithUrl:(NSString *)url andCallback:(void (^)(NSData *returnData))callback
{
    [self requestWithUrl:url method:HTTP_REQUEST_GET hasRange:NO rangeStart:0 rangeEnd:0 sendData:nil andandCallback:callback];
}


//用get请求方式获取文本（异步）
- (void)getTextWithUrl:(NSString *)url andCallback:(void (^)(NSString *returnText))callback
{
    [self getDataWithUrl:url andCallback:^(NSData *returnData)
    {
        if(returnData)
        {
            if(callback)
            {
                callback([[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease]);
            }
        }
        else
        {
            if(callback)
            {
                callback(nil);
            }
        }
    }];
}


#pragma -mark POST请求

//用post请求方式发送数据，获取数据（同步）
- (NSData *)postDataWithUrl:(NSString *)url andSendData:(NSData *)data
{
    return [self requestWithUrl:url method:HTTP_REQUEST_POST hasRange:NO rangeStart:0 rangeEnd:0 sendData:data];
}


//用post请求方式发送文本，获取数据（同步）
- (NSData *)postDataWithUrl:(NSString *)url andSendText:(NSString *)text
{
    return [self postDataWithUrl:url andSendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
}


//用post请求方式发送数据，获取文本（同步）
- (NSString *)postTextWithUrl:(NSString *)url andSendData:(NSData *)data
{
    NSData *returnData=[self postDataWithUrl:url andSendData:data];
    
    if(returnData)
    {
        return [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {
        return nil;
    }
}


//用post请求方式发送文本，获取文本（同步）
- (NSString *)postTextWithUrl:(NSString *)url andSendText:(NSString *)text
{
    return [self postTextWithUrl:url andSendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
}


//用post请求方式发送数据，获取数据（异步）
- (void)postDataWithUrl:(NSString *)url andSendData:(NSData *)data andCallback:(void (^)(NSData *returnData))callback
{
    [self requestWithUrl:url method:HTTP_REQUEST_POST hasRange:NO rangeStart:0 rangeEnd:0 sendData:data andandCallback:callback];
}


//用post请求方式发送文本，获取数据（异步）
- (void)postDataWithUrl:(NSString *)url andSendText:(NSString *)text andCallback:(void (^)(NSData *returnData))callback
{
    [self postDataWithUrl:url andSendData:[text dataUsingEncoding:NSUTF8StringEncoding] andCallback:callback];
}


//用post请求方式发送数据，获取文本（异步）
- (void)postTextWithUrl:(NSString *)url andSendData:(NSData *)data andCallback:(void (^)(NSString *returnText))callback
{
    [self postDataWithUrl:url andSendData:data andCallback:^(NSData *returnData)
    {
        if(returnData)
        {
            if(callback)
            {
                callback([[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease]);
            }
        }
        else
        {
            if(callback)
            {
                callback(nil);
            }
        }
    }];
}


//用post请求方式发送文本，获取文本（异步）
- (void)postTextWithUrl:(NSString *)url andSendText:(NSString *)text andCallback:(void (^)(NSString *returnText))callback
{
    [self postTextWithUrl:url andSendData:[text dataUsingEncoding:NSUTF8StringEncoding] andCallback:callback];
}


#pragma -mark 表单提交

//提交表单，获取数据（同步）
- (NSData *)postDataWithUrl:(NSString *)url andForm:(KATHashMap *)form;
{
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    //构建上传数据
    NSMutableData *data=[NSMutableData data];
    
    //遍历内容
    for(NSString *key in form.allKeys)
    {
        [data appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",HTTP_FILE_UPLOAD_BOUNDARY,key,form[key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //设置尾内容
    [data appendData:[[NSString stringWithFormat:@"--%@--",HTTP_FILE_UPLOAD_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    //[request setHTTPBody:data];
    
    //返回的数据
    NSURLResponse *response=nil;
    NSError *error=nil;
    NSData *returnData=nil;
    
    //清除响应头
    self.responseHeader=nil;
    
    //发送请求
    returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error)//发生错误
    {
        NSLog(@"KATHttpRequest Error:%@",error);
        
        returnData=nil;
    }
    else//成功
    {
        //获取返回头信息
        _contentLength=response.expectedContentLength;
        self.MIMEType=response.MIMEType;
        self.responseURL=response.URL;
        
        self.responseHeader=[KATHashMap hashMapWithCapacity:32 andMaxUsage:80];
        
        NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
        [_responseHeader putWithDictionary:fields];
    }
    
    //隐藏网络状态
    [KATAppUtil setNetworkStateActive:NO];
    
    [request release];
    
    
    return returnData;
}


//提交表单，获取文本（同步）
- (NSString *)postTextWithUrl:(NSString *)url andForm:(KATHashMap *)form
{
    return [[[NSString alloc] initWithData:[self postDataWithUrl:url andForm:form] encoding:NSUTF8StringEncoding] autorelease];
}


//提交表单，获取数据（异步）
- (void)postDataWithUrl:(NSString *)url andForm:(KATHashMap *)form andCallback:(void (^)(NSData *returnData))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        NSData *returnData=[self postDataWithUrl:url andForm:form];
    
        if(callback)
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                callback(returnData);
            });
        }
    });
}


//提交表单，获取文本（异步）
- (void)postTextWithUrl:(NSString *)url andForm:(KATHashMap *)form andCallback:(void (^)(NSString *returnText))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        NSString *returnText=[self postTextWithUrl:url andForm:form];
        
        if(callback)
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                callback(returnText);
            });
        }
    });
}



#pragma -mark HEAD请求

//请求Http头信息（同步）
- (void)headWithUrl:(NSString *)url
{
    [self requestWithUrl:url method:HTTP_REQUEST_HEAD hasRange:NO rangeStart:0 rangeEnd:0 sendData:nil];
}


//请求Http头信息（异步）
- (void)headWithUrl:(NSString *)url andCallback:(void (^)(void))callback
{
    [self requestWithUrl:url method:HTTP_REQUEST_HEAD hasRange:NO rangeStart:0 rangeEnd:0 sendData:nil andandCallback:^(NSData *returnData)
    {
        if(callback)
        {
            callback();
        }
    }];
}


#pragma -mark 下载

//下载文件到指定的目录（适合小型文件），判断是否替换原文件(同步)
- (BOOL)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable append:(BOOL)append
{
    if(!file || !url)
    {
        return NO;
    }
    
    //判断文件是否存在
    BOOL fileExists=[KATFileUtil existsFile:file];
    
    if(fileExists && !replaceable)//文件已存在且不替换
    {
        return YES;
    }
    
    //下载
    NSData *returnData=[self getDataWithUrl:url];
    
    //写入文件
    if(returnData)
    {
        [KATFileUtil writeToFile:file withData:returnData append:append];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//下载文件到指定的目录（适合小型文件），判断是否替换原文件(异步)
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url replaceable:(BOOL)replaceable append:(BOOL)append andCallback:(void (^)(BOOL success))callback
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
    
    [self getDataWithUrl:url andCallback:^(NSData *returnData)
    {
        //写入文件
        if(returnData)
        {
            [KATFileUtil writeToFile:file withData:returnData append:append];
            
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
        
    }];
}


//下载文件到指定目录，支持断点续传，指定每块数据大小，显示下载进度（适合大文件）（不能替换文件）（异步）
- (void)downloadFile:(NSString *)file withUrl:(NSString *)url blockSize:(long long)blockSize andCallback:(void (^)(long long currentSize,long long totalSize,int status))callback
{
    if(!file || !url)
    {
        return;
    }
    
    if(blockSize>HTTP_FILE_BLOCK_SIZE_MAX || blockSize<HTTP_FILE_BLOCK_SIZE_MIN)
    {
        blockSize=HTTP_FILE_BLOCK_SIZE_DEFAULT;
    }
    
    _downloadCanceled=NO;
    
    //文件尺寸
    __block long long currentSize=0LL;
    __block long long totalSize=0LL;
    
    //判断文件是否存在
    BOOL fileExists=[KATFileUtil existsFile:file];
    
    if(fileExists)
    {
        currentSize=[KATFileUtil sizeOfFile:file];
    }
    
    
    //异步处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        //获取头文件
        [self headWithUrl:url];
        
        if(!_responseHeader)//获取文件头失败
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                if(callback)
                {
                    callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_FAILED);
                }
            });
                          
            return;
        }
        else//获取文件头成功
        {
            totalSize=_contentLength;
            
            if(totalSize<=0)//没有该文件
            {
                dispatch_sync(dispatch_get_main_queue(), ^
                {
                    if(callback)
                    {
                        callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_FAILED);
                    }
                });
                
                return;
            }
            
            
            if(currentSize>=totalSize)//已经下载完成
            {
                dispatch_sync(dispatch_get_main_queue(), ^
                {
                    if(callback)
                    {
                        callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_FINISHED);
                    }
                });
                
                return;
            }
            
            
            //末尾尺寸
            __block long long endSize=currentSize+blockSize;
            

            //分段下载
            while(totalSize>currentSize)
            {
                if(endSize>totalSize)
                {
                    endSize=totalSize;
                }
                
                //同步下载
                NSData *data=[self requestWithUrl:url method:HTTP_REQUEST_GET hasRange:YES rangeStart:currentSize rangeEnd:endSize sendData:nil];
                
                if(!data)//下载失败
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        if(callback)
                        {
                            callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_FAILED);
                        }
                    });
                    
                    return;
                }
                else//下载成功
                {
                    //追加写入文件
                    [KATFileUtil writeToFile:file withData:data append:YES];
                    
                    //重新计算当前尺寸
                    currentSize=[KATFileUtil sizeOfFile:file];
                    
                    endSize=currentSize+blockSize;
                    
                    if(currentSize>=totalSize)//下载完成
                    {
                        //下载完毕
                        dispatch_sync(dispatch_get_main_queue(), ^
                        {
                            if(callback)
                            {
                                callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_FINISHED);
                            }
                        });
                        
                        return;
                    }
                    else if(_downloadCanceled)//取消下载
                    {
                        //下载取消
                        dispatch_sync(dispatch_get_main_queue(), ^
                        {
                            if(callback)
                            {
                                callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_CANCELED);
                            }
                        });
                        
                        return;
                    }
                    else//继续下载
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if(callback)
                            {
                                callback(currentSize,totalSize,HTTP_FILE_DOWNLOAD_UNFINISHED);
                            }
                        });
                    }
                }
            }
        }
        
    });
    
}


///取消下载(只针对分块下载)
- (void)cancelDownload
{
    _downloadCanceled=YES;
}



#pragma -mark 上传

//上传文件，设置表单属性名称（同步）
- (NSData *)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name
{
    if(!file || !url || !name)
    {
        return nil;
    }
    
    //判断文件是否存在
    if(![KATFileUtil existsFile:file])
    {
        return nil;
    }
    
    //显示网络状态
    if(_showNetworkStatus)
    {
        [KATAppUtil setNetworkStateActive:YES];
    }
    
    
    //构建上传数据
    NSMutableData *data=[NSMutableData data];
    
    //设置内容
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
    //[request setHTTPBody:data];
    
    //返回的数据
    NSURLResponse *response=nil;
    NSError *error=nil;
    NSData *returnData=nil;
    
    //清除响应头
    self.responseHeader=nil;
    
    //发送请求
    returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error)//发生错误
    {
        NSLog(@"KATHttpRequest Error:%@",error);
        
        returnData=nil;
    }
    else//成功
    {
        //获取返回头信息
        _contentLength=response.expectedContentLength;
        self.MIMEType=response.MIMEType;
        self.responseURL=response.URL;
        
        self.responseHeader=[KATHashMap hashMapWithCapacity:32 andMaxUsage:80];
        
        NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
        [_responseHeader putWithDictionary:fields];
    }
    
    //隐藏网络状态
    [KATAppUtil setNetworkStateActive:NO];
    
    [request release];


    return returnData;
}


//上传文件，设置表单属性名称（异步）
- (void)uploadFile:(NSString *)file withUrl:(NSString *)url andName:(NSString *)name andCallback:(void (^)(NSData *returnData))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        NSData *returnData=[self uploadFile:file withUrl:url andName:name];
        
        if(callback)
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                callback(returnData);
            });
        }
    });
}




- (void)dealloc
{
//    NSLog(@"KATHttpRequest is dealloc...");
    
    [_headerFields release];
    [_contentType release];
    [_responseHeader release];
    [_MIMEType release];
    [_responseURL release];
    
    [super dealloc];
}



@end
