//
//  KATCodeUtil.h
//  KATFramework
//
//  Created by Kantice on 15/12/3.
//  Copyright © 2015年 KatApp. All rights reserved.
//  编码、解码、加密及解密工具

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define MD5_CASE_LOWER 0
#define MD5_CASE_UPPER 1

#define MD5_BIT_32 0
#define MD5_BIT_16 1


@interface KATCodeUtil : NSObject


#pragma mark - 类方法


///MD5加密（32位或16位，字母大写或小写）
+ (NSString *)MD5WithContent:(NSString *)content andBit:(int)b andCase:(int)c;


///AES加密(PKCS7Padding补码方式，ECB模式)(根据密钥长度自动判断是AES256(32)或AES128(16))
+ (NSData *)AESEncryptWithData:(NSData *)data andKey:(NSString *)key;


///AES解密(PKCS7Padding补码方式，ECB模式)(根据密钥长度自动判断是AES256(32)或AES128(16))
+ (NSData *)AESDecryptWithData:(NSData *)data andKey:(NSString *)key;


///AES加密成base64格式的字符串(PKCS7Padding补码方式，ECB模式)(根据密钥长度自动判断是AES256(32)或AES128(16))
+ (NSString *)AESEncrypt2Base64WithContent:(NSString *)content andKey:(NSString *)key;


///AES从base64字符串解密(PKCS7Padding补码方式，ECB模式)(根据密钥长度自动判断是AES256(32)或AES128(16))
+ (NSString *)AESDecryptWithBase64Content:(NSString *)content andKey:(NSString *)key;


///Base64编码
+ (NSString *)base64EncodeWithContent:(NSString *)content;


///Base64解码
+ (NSString *)base64DecodeWithContent:(NSString *)content;


@end




