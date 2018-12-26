//
//  KATFileUtil.h
//  KATFramework
//
//  Created by Kantice on 15/11/23.
//  Copyright © 2015年 KatApp. All rights reserved.
//  文件工具类

#import <Foundation/Foundation.h>
#import "KATArray.h"



@interface KATFileUtil : NSObject


#pragma mark - 类方法

///从url或者path中获取文件名
+ (NSString *)fileNameWithUrl:(NSString *)url;

///文件路径转化为URL
+ (NSURL *)urlWithPath:(NSString *)path;

///判断文件(目录)是否存在
+ (BOOL)existsFile:(NSString *)file;

///复制文件(目录)
+ (BOOL)copyFile:(NSString *)file toPath:(NSString *)path;

///删除文件(目录)
+ (BOOL)removeFile:(NSString *)file;

///重命名或者移动文件(目录)
+ (BOOL)moveFile:(NSString *)file toPath:(NSString *)path;

///获取文件内容
+ (NSData *)contentsOfFile:(NSString *)file;

///获取文本文件内容(UTF8)
+ (NSString *)stringOfFile:(NSString *)file;

///获取文件大小
+ (long long)sizeOfFile:(NSString *)file;

///获取文件创建日期
+ (NSDate *)creationDateOfFile:(NSString *)file;

///获取文件修改日期
+ (NSDate *)modificationDateOfFile:(NSString *)file;

///判断两个文件内容是否相同
+ (BOOL)isEqualWithFile1:(NSString *) file1 andFile2:(NSString *)file2;

///获取当前目录
+ (NSString *)currentDir;

///更改当前目录
+ (BOOL)changeDir:(NSString *)dir;

///创建目录
+ (BOOL)createDir:(NSString *)dir;

///判断文件是否是目录
+ (BOOL)isDir:(NSString *)dir;

///当前目录文件列表
+ (KATArray<NSString *> *)filesInDir:(NSString *)dir;

///获取文件后缀名
+ (NSString *)extensionWithFile:(NSString *)file;

///写入文件(是否追加)
+ (BOOL)writeToFile:(NSString *)file withData:(NSData *)data append:(BOOL)append;

///添加备份忽略的目录(防止iCloud同步)
+ (BOOL)skipBackupWithDir:(NSString *)dir;

///删除指定文件夹下创建时间在当前时间之前的秒数时间之前的文件
+ (int)removeFilesCreatedTimeBeforeSeconds:(long long int)seconds inDir:(NSString *)dir;

///删除指定文件夹下创建时间在当前时间之前的秒数时间之后的文件
+ (int)removeFilesCreatedTimeAfterSeconds:(long long int)seconds inDir:(NSString *)dir;

///删除指定文件夹下指定大小大的文件
+ (int)removeFilesMoreThanSize:(long long int)size inDir:(NSString *)dir;

///删除指定文件夹下指定大小小的文件
+ (int)removeFilesLessThanSize:(long long int)size inDir:(NSString *)dir;

///获取指定文件夹下创建时间在当前时间之前的秒数时间之前的文件
+ (KATArray<NSString *> *)filesCreatedTimeBeforeSeconds:(long long int)seconds inDir:(NSString *)dir;

///获取指定文件夹下创建时间在当前时间之前的秒数时间之后的文件
+ (KATArray<NSString *> *)filesCreatedTimeAfterSeconds:(long long int)seconds inDir:(NSString *)dir;

///获取指定文件夹下指定大小大的文件
+ (KATArray<NSString *> *)filesMoreThanSize:(long long int)size inDir:(NSString *)dir;

///获取指定文件夹下指定大小小的文件
+ (KATArray<NSString *> *)filesLessThanSize:(long long int)size inDir:(NSString *)dir;

///清除目录下的所有文件
+ (void)clearDir:(NSString *)dir;

///获取目录大小
+ (long long int)sizeOfDir:(NSString *)dir;

///获取磁盘总空间
+ (long long int)diskTotalSize;

///获取磁盘剩余空间
+ (long long int)diskFreeSize;

///获取磁盘已用空间
+ (long long int)diskUsedSize;


@end




