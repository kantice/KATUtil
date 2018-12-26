//
//  KATCodeUtil.m
//  KATFramework
//
//  Created by Kantice on 15/12/3.
//  Copyright © 2015年 KatApp. All rights reserved.
//

#import "KATCodeUtil.h"


@implementation KATCodeUtil


//MD5加密
+ (NSString *)MD5WithContent:(NSString *)content andBit:(int)b andCase:(int)c
{
    if(!content)
    {
        return nil;
    }
    
    const char *str= [content UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (unsigned int)strlen(str), result);
    
    NSMutableString *md5=[NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [md5 appendFormat:@"%02X", result[i]];
    }

    
    if(b==MD5_BIT_16)//16位
    {
        if(c==MD5_CASE_LOWER)//小写字母
        {
            return [[[md5 substringToIndex:24] substringFromIndex:8] lowercaseString];//9～25位;
        }
        else//大写字母
        {
            return [[[md5 substringToIndex:24] substringFromIndex:8] uppercaseString];//9～25位;
        }
    }
    else//32位
    {
        if(c==MD5_CASE_LOWER)//小写字母
        {
            return [md5 lowercaseString];
        }
        else//大写字母
        {
            return [md5 uppercaseString];
        }
    }
    
}


//AES加密
+ (NSData *)AESEncryptWithData:(NSData *)data andKey:(NSString *)key
{
    if(!data || !key)
    {
        return nil;
    }
    
    BOOL key32=NO;
    
    if(key.length>16)
    {
        key32=YES;
    }
    
    char keyPtr[(key32?kCCKeySizeAES256:kCCKeySizeAES128)+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength=[data length];
    
    size_t bufferSize=dataLength+kCCBlockSizeAES128;
    
    void *buffer=malloc(bufferSize);
    
    size_t numBytesEncrypted=0;
    
    CCCryptorStatus cryptStatus=CCCrypt(kCCEncrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, (key32?kCCKeySizeAES256:kCCKeySizeAES128),//256位
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    //加密成功
    if(cryptStatus==kCCSuccess)
    {
        //返回值
        NSData *result=[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];//该函数自动会释放buffer
        
        //转化为字符串
        if(result && result.length>0)
        {
            return result;
        }
    }
    
    //释放内存
    free(buffer);
    
    return nil;
}


//AES解密
+ (NSData *)AESDecryptWithData:(NSData *)data andKey:(NSString *)key;
{
    if(!data || !key)
    {
        return nil;
    }
    
    BOOL key32=NO;
    
    if(key.length>16)
    {
        key32=YES;
    }
    
    char keyPtr[(key32?kCCKeySizeAES256:kCCKeySizeAES128)+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength=[data length];

    size_t bufferSize=dataLength+kCCBlockSizeAES128;
    
    void *buffer=malloc(bufferSize);
    
    size_t numBytesDecrypted=0;
    
    CCCryptorStatus cryptStatus=CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, (key32?kCCKeySizeAES256:kCCKeySizeAES128),//256位
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    //解密成功
    if(cryptStatus==kCCSuccess)
    {
        //该函数自动会释放buffer
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }

    //释放内存
    free(buffer);
    
    return nil;
}


//AES加密成base64格式的字符串
+ (NSString *)AESEncrypt2Base64WithContent:(NSString *)content andKey:(NSString *)key
{
    if(!content || !key)
    {
        return nil;
    }
    
    NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[self AESEncryptWithData:data andKey:key] base64EncodedStringWithOptions:0];
}


//AES从base64字符串解密
+ (NSString *)AESDecryptWithBase64Content:(NSString *)content andKey:(NSString *)key
{
    if(!content || !key)
    {
        return nil;
    }
    
    NSData *data=[[[NSData alloc] initWithBase64EncodedString:content options:0] autorelease];
    
    return [[[NSString alloc] initWithData:[self AESDecryptWithData:data andKey:key] encoding:NSUTF8StringEncoding] autorelease];
}


//Base64编码
+ (NSString *)base64EncodeWithContent:(NSString *)content
{
    if(!content)
    {
        return nil;
    }
    
    NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}


//Base64解码
+ (NSString *)base64DecodeWithContent:(NSString *)content
{
    if(!content)
    {
        return nil;
    }
    
    NSData *data=[[[NSData alloc] initWithBase64EncodedString:content options:0] autorelease];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}





@end






