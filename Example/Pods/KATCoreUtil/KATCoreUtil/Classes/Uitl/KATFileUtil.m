//
//  KATFileUtil.m
//  KATFramework
//
//  Created by Kantice on 15/11/23.
//  Copyright © 2015年 KatApp. All rights reserved.
//

#import "KATFileUtil.h"
#import "KATSystemInfo.h"
#import "KATDateUtil.h"


@implementation KATFileUtil


//从url或者path中获取文件名
+ (NSString *)fileNameWithUrl:(NSString *)url
{
    if(!url)
    {
        return nil;
    }
    
    NSString *name;
    
    //查找字符串
    NSRange range=[url rangeOfString:@"/" options:NSBackwardsSearch];
    
    if(range.location==NSNotFound)
    {
        name=url;
    }
    else
    {
        name=[url substringFromIndex:range.location+1];
    }
    
    return name;
}


//文件路径转化为URL
+ (NSURL *)urlWithPath:(NSString *)path
{
    return [NSURL fileURLWithPath:path];
}


//判断文件(目录)是否存在
+ (BOOL)existsFile:(NSString *)file;
{
    if(file)
    {
        return [[NSFileManager defaultManager] fileExistsAtPath:file];
    }
    
    return NO;
}



//复制文件(目录)
+ (BOOL)copyFile:(NSString *)file toPath:(NSString *)path
{
    if(file && path)
    {
        if([self existsFile:file])//文件必须存在
        {
            return [[NSFileManager defaultManager] copyItemAtPath:file toPath:path error:nil];
        }
    }
    
    return NO;
}



//删除文件(目录)
+ (BOOL)removeFile:(NSString *)file
{
    if(file)
    {
        if([self existsFile:file])//文件必须存在
        {
            return [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
    }
    
    return NO;
}



//重命名或者移动文件(目录)
+ (BOOL)moveFile:(NSString *)file toPath:(NSString *)path
{
    if(file && path)
    {
        if([self existsFile:file])//文件必须存在
        {
            return [[NSFileManager defaultManager] moveItemAtPath:file toPath:path error:nil];
        }
    }
    
    return NO;
}



//获取文件内容
+ (NSData *)contentsOfFile:(NSString *)file
{
    if(file)
    {
        if([self existsFile:file])//文件必须存在
        {
            return [[NSFileManager defaultManager] contentsAtPath:file];
        }
    }
    
    return nil;
}


//获取文本文件内容(UTF8)
+ (NSString *)stringOfFile:(NSString *)file
{
    if(file)
    {
        if([self existsFile:file])//文件必须存在
        {
            return [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        }
    }
    
    return nil;
}



//获取文件大小
+ (long long)sizeOfFile:(NSString *)file
{
    if(file)
    {
        if([self existsFile:file])//文件必须存在
        {
            NSDictionary *fileAttr=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
            
            if(fileAttr)
            {
                return [[fileAttr objectForKey:NSFileSize] unsignedLongLongValue];
            }
        }
    }
    
    return -1;
}



//获取文件创建日期
+ (NSDate *)creationDateOfFile:(NSString *)file
{
    if(file)
    {
        if([self existsFile:file])//文件必须存在
        {
            NSDictionary *fileAttr=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
            
            if(fileAttr)
            {
                return [fileAttr objectForKey:NSFileCreationDate];
            }
        }
    }
    
    return nil;
}


//获取文件修改日期
+ (NSDate *)modificationDateOfFile:(NSString *)file
{
    if(file)
    {
        if([self existsFile:file])//文件必须存在
        {
            NSDictionary *fileAttr=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
            
            if(fileAttr)
            {
                return [fileAttr objectForKey:NSFileModificationDate];
            }
        }
    }
    
    return nil;
}



//判断两个文件内容是否相同
+ (BOOL)isEqualWithFile1:(NSString *) file1 andFile2:(NSString *)file2
{
    if(file1 && file2)
    {
        if([self existsFile:file1] && [self existsFile:file2])//文件必须存在
        {
            return [[NSFileManager defaultManager] contentsEqualAtPath:file1 andPath:file2];
        }
    }
    
    return NO;
}



//获取当前目录
+ (NSString *)currentDir
{
    return [[NSFileManager defaultManager] currentDirectoryPath];
}



//更改当前目录
+ (BOOL)changeDir:(NSString *)dir
{
    if(dir)
    {
        if([self existsFile:dir])
        {
            return [[NSFileManager defaultManager] changeCurrentDirectoryPath:dir];
        }
    }
    
    return NO;
}



//创建目录
+ (BOOL)createDir:(NSString *)dir
{
    if(dir)
    {
        if(![self existsFile:dir])
        {
            return [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    return NO;
}



//判断文件是否是目录
+ (BOOL)isDir:(NSString *)dir;
{
    if(dir)
    {
        if([self existsFile:dir])
        {
            BOOL isDir=NO;
            
            [[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir];
            
            return isDir;
        }
    }
    
    return NO;
}



//当前目录文件列表
+ (KATArray<NSString *> *)filesInDir:(NSString *)dir
{
    if(dir)
    {
        if([self isDir:dir])
        {
            NSArray<NSString *> *arr=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
            
            if(arr)
            {
                KATArray<NSString *> *list=[KATArray arrayWithCapacity:(int)arr.count];
                
                for(NSString *file in arr)
                {
                    [list put:file];
                }
                
                return list;
            }
        }
    }
    
    return nil;
}


//获取文件后缀名
+ (NSString *)extensionWithFile:(NSString *)file
{
    if(!file)
    {
        return nil;
    }
    
    NSString *ext=nil;
    
    //查找字符串
    NSRange range=[file rangeOfString:@"." options:NSBackwardsSearch];
    
    if(range.location==NSNotFound)
    {
        ext=nil;
    }
    else
    {
        ext=[file substringFromIndex:range.location+1];
    }
    
    return ext;
}


//文本写入文件(是否追加)
+ (BOOL)writeToFile:(NSString *)file withData:(NSData *)data append:(BOOL)append
{
    if(data)
    {
        if(append)//追加模式
        {
            NSFileHandle *fileHandle=[NSFileHandle fileHandleForWritingAtPath:file];
            
            //如果存在文件则追加，否则创建
            if(fileHandle)
            {
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:data];
                [fileHandle closeFile];//关闭文件
                
                return YES;
            }
            else
            {
                return [data writeToFile:file atomically:YES];
            }
        }
        else
        {
            return [data writeToFile:file atomically:YES];
        }
    }
    else
    {
        return NO;
    }
}


//添加备份忽略的目录(防止iCloud同步)
+ (BOOL)skipBackupWithDir:(NSString *)dir
{
    if([self existsFile:dir])
    {
        NSError *error=nil;

        if(![[NSURL URLWithString:dir] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error])
        {
            NSLog(@"Error excluding: %@",error);
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}


//删除指定文件夹下创建时间在当前时间之前的秒数时间之前的文件
+ (int)removeFilesCreatedTimeBeforeSeconds:(long long int)seconds inDir:(NSString *)dir
{
    int count=0;
    
    KATArray<NSString *> *files=[self filesInDir:dir];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int createTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil dateTimeFromDate:[self creationDateOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]]]];
            long long int compareTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil now]]-seconds*DATE_TIME_SECOND;
            
            if(createTime<=compareTime)
            {
                [self removeFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return count;
}


//删除指定文件夹下创建时间在当前时间之前的秒数时间之后的文件
+ (int)removeFilesCreatedTimeAfterSeconds:(long long int)seconds inDir:(NSString *)dir
{
    int count=0;
    
    KATArray<NSString *> *files=[self filesInDir:dir];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int createTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil dateTimeFromDate:[self creationDateOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]]]];
            long long int compareTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil now]]-seconds*DATE_TIME_SECOND;
            
            if(createTime>=compareTime)
            {
                [self removeFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return count;
}


//删除指定文件夹下指定大小大的文件
+ (int)removeFilesMoreThanSize:(long long int)size inDir:(NSString *)dir
{
    int count=0;
    
    KATArray<NSString *> *files=[self filesInDir:dir];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int fileSize=[self sizeOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            
            if(fileSize>size)
            {
                [self removeFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return count;
}


//删除指定文件夹下指定大小小的文件
+ (int)removeFilesLessThanSize:(long long int)size inDir:(NSString *)dir
{
    int count=0;
    
    KATArray<NSString *> *files=[self filesInDir:dir];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int fileSize=[self sizeOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            
            if(fileSize<size)
            {
                [self removeFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return count;
}


//获取指定文件夹下创建时间在当前时间之前的秒数时间之前的文件
+ (KATArray<NSString *> *)filesCreatedTimeBeforeSeconds:(long long int)seconds inDir:(NSString *)dir
{
    KATArray<NSString *> *files=[self filesInDir:dir];
    KATArray<NSString *> *result=[KATArray arrayWithCapacity:files.length];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int createTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil dateTimeFromDate:[self creationDateOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]]]];
            long long int compareTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil now]]-seconds*DATE_TIME_SECOND;
            
            if(createTime<=compareTime)
            {
                [result put:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return result;
}


//获取指定文件夹下创建时间在当前时间之前的秒数时间之后的文件
+ (KATArray<NSString *> *)filesCreatedTimeAfterSeconds:(long long int)seconds inDir:(NSString *)dir
{
    KATArray<NSString *> *files=[self filesInDir:dir];
    KATArray<NSString *> *result=[KATArray arrayWithCapacity:files.length];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int createTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil dateTimeFromDate:[self creationDateOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]]]];
            long long int compareTime=[KATDateUtil intervalSince1970FromDateTime:[KATDateUtil now]]-seconds*DATE_TIME_SECOND;
            
            if(createTime>=compareTime)
            {
                [result put:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return result;
}


//获取指定文件夹下指定大小大的文件
+ (KATArray<NSString *> *)filesMoreThanSize:(long long int)size inDir:(NSString *)dir
{
    KATArray<NSString *> *files=[self filesInDir:dir];
    KATArray<NSString *> *result=[KATArray arrayWithCapacity:files.length];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int fileSize=[self sizeOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            
            if(fileSize>size)
            {
                [result put:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return result;
}


//获取指定文件夹下指定大小小的文件
+ (KATArray<NSString *> *)filesLessThanSize:(long long int)size inDir:(NSString *)dir
{
    KATArray<NSString *> *files=[self filesInDir:dir];
    KATArray<NSString *> *result=[KATArray arrayWithCapacity:files.length];
    
    if(files && files.length>0)
    {
        for(NSString *file in files)
        {
            long long int fileSize=[self sizeOfFile:[NSString stringWithFormat:@"%@/%@",dir,file]];
            
            if(fileSize<size)
            {
                [result put:[NSString stringWithFormat:@"%@/%@",dir,file]];
            }
        }
    }
    
    return result;
}


//清除目录下的所有文件
+ (void)clearDir:(NSString *)dir
{
    if([self isDir:dir])
    {
        //先删除
        [self removeFile:dir];
        
        //后新建
        [self createDir:dir];
    }
}


//获取目录大小
+ (long long int)sizeOfDir:(NSString *)dir
{
    if(![self isDir:dir])
    {
        return -1;
    }
    
    long long int size=0;
    
    KATArray<NSString *> *files=[self filesInDir:dir];
    
    for(NSString *file in files)
    {
        NSString *path=[NSString stringWithFormat:@"%@/%@",dir,file];//完整路径
        
        if([self isDir:path])//是文件夹
        {
            long long int dSize=[self sizeOfDir:path];
            
            if(dSize>0)
            {
                size+=dSize;
            }
        }
        else//文件
        {
            long long int fSize=[self sizeOfFile:path];
            
            if(fSize>0)
            {
                size+=fSize;
            }
        }
    }
    
    return size;
}


//获取磁盘总空间
+ (long long int)diskTotalSize
{
    NSDictionary *attrs=[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    return [[attrs objectForKey:NSFileSystemSize] longLongValue];
}


//获取磁盘剩余空间
+ (long long int)diskFreeSize
{
    NSDictionary *attrs=[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    return [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
}


//获取磁盘已用空间
+ (long long int)diskUsedSize
{
    return [KATFileUtil diskTotalSize]-[KATFileUtil diskFreeSize];
}


@end
