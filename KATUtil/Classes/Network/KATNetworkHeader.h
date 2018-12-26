//
//  KATNetworkHeader.h
//  KATFramework
//
//  Created by Kantice on 16/6/13.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef KATNetworkHeader_h
#define KATNetworkHeader_h


//网络状态

#define NETWORK_STATUS_NONE 0
#define NETWORK_STATUS_WIFI 1
#define NETWORK_STATUS_WWAN 2



//请求方式
#define HTTP_REQUEST_GET @"GET"
#define HTTP_REQUEST_POST @"POST"
#define HTTP_REQUEST_HEAD @"HEAD"


//默认超时
#define HTTP_REQUEST_TIMEOUT 20.0


//缓存策略

///默认：协议缓存，根据response中的Cache-Control字段判断缓存是否有效，如果缓存有效则使用缓存数据否则重新从服务器请求
#define HTTP_CACHE_DEFAULT NSURLRequestUseProtocolCachePolicy

///忽略：不使用缓存，直接请求新数据
#define HTTP_CACHE_IGNORE NSURLRequestReloadIgnoringLocalCacheData

///缓存优先：直接使用缓存数据不管是否有效，没有缓存则重新请求
#define HTTP_CACHE_FIRST NSURLRequestReturnCacheDataElseLoad

///只用缓存：直接使用缓存数据不管是否有效，没有缓存数据则失败
#define HTTP_CACHE_ONLY NSURLRequestReturnCacheDataDontLoad



//文件块大小（分段下载）

///文件块默认尺寸
#define HTTP_FILE_BLOCK_SIZE_DEFAULT (1024*1024)

///文件块最小尺寸
#define HTTP_FILE_BLOCK_SIZE_MIN (1024*32)

///文件块最大尺寸
#define HTTP_FILE_BLOCK_SIZE_MAX (1024*1024*32)



//下载状态

///下载失败
#define HTTP_FILE_DOWNLOAD_FAILED 0

///下载未完成
#define HTTP_FILE_DOWNLOAD_UNFINISHED 1

///下载完成
#define HTTP_FILE_DOWNLOAD_FINISHED 2

///下载取消
#define HTTP_FILE_DOWNLOAD_CANCELED 3



//上传状态

///上传文件分割字符串
#define HTTP_FILE_UPLOAD_BOUNDARY @"------------kantice_boundary_31415926_112358132134_YYYYYYYYYYYYY--"

///上传失败
#define HTTP_FILE_UPLOAD_FAILED 0

///上传完成
#define HTTP_FILE_UPLOAD_FINISHED 1



//MIME类型

///Html
#define MIME_TYPE_HTML @"text/html"

///Json
#define MIME_TYPE_JSON @"application/json"

///普通文本
#define MIME_TYPE_TEXT @"text/plain"

///富文本
#define MIME_TYPE_RICH @"application/rtf"

///GIF图片
#define MIME_TYPE_GIF @"image/gif"

///jpg图片
#define MIME_TYPE_JPG @"image/jpeg"

///png图片
#define MIME_TYPE_PNG @"image/png"

///声音文件
#define MIME_TYPE_AUDIO @"audio/basic"

///mid音乐文件
#define MIME_TYPE_MID @"audio/x-midi"

///ram音乐文件
#define MIME_TYPE_RAM @"audio/x-pn-realaudio"

///mpeg等
#define MIME_TYPE_MPEG @"video/mpeg"

///mpe等
#define MIME_TYPE_MP3 @"audio/mpeg"

///avi视频文件
#define MIME_TYPE_AVI @"video/x-msvideo"

///gz压缩文件
#define MIME_TYPE_GZ @"application/x-gzip"

///tar压缩文件
#define MIME_TYPE_TAR @"application/x-tar"

///exe文件
#define MIME_TYPE_EXE @"application/octet-stream"

///zip压缩文件
#define MIME_TYPE_ZIP @"application/zip"

///flash文件
#define MIME_TYPE_FLASH @"application/x-shockwave-flash"

///wav声音文件
#define MIME_TYPE_WAV @"audio/x-wav"

///Excel
#define MIME_TYPE_EXCEL @"application/msexcel"

///Word
#define MIME_TYPE_WORD @"application/msword"

///CHM
#define MIME_TYPE_CHM @"application/mshelp";

///PPT
#define MIME_TYPE_PPT @"application/mspowerpoint"

///PDF
#define MIME_TYPE_PDF @"application/pdf"

///m4a
#define MIME_TYPE_M4A @"audio/mp4a-latm"

///m4v
#define MIME_TYPE_M4V @"video/x-m4v"

///stream
#define MIME_TYPE_STREAM @"application/octet-stream"

///iPhone
#define MIME_TYPE_IPHONE @"application/vnd.iphone"

///Android
#define MIME_TYPE_ANDROID @"application/vnd.android.package-archive"




#endif /* KATNetworkHeader_h */




