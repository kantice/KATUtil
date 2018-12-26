//
//  KATKeyChainUtil.m
//  KATFramework
//
//  Created by Yi Yu on 2017/6/5.
//  Copyright © 2017年 KatApp. All rights reserved.
//

#import "KATKeyChainUtil.h"

@implementation KATKeyChainUtil


//生成新的密码字典，方便重复使用(内部方法)
+ (NSMutableDictionary *)newPasswordDictionaryForKey:(NSString *)key
{
    if(!key)
    {
        return nil;
    }
    
    NSMutableDictionary *dict=[[[NSMutableDictionary alloc] init] autorelease];
    
    //指定item的类型为GenericPassword
    [dict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    //类型为GenericPassword的信息必须提供以下两条属性作为unique identifier
    [dict setObject:key forKey:(id)kSecAttrAccount];
    [dict setObject:key forKey:(id)kSecAttrService];
    
    //设置访问类型,从iOS5.0开始kSecAttrAccessible默认为kSecAttrAccessibleWhenUnlocked
    [dict setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
    
    return dict;
}


//保存密码
+ (BOOL)savePassword:(NSString *)password forKey:(NSString *)key
{
    if(!password || !key)
    {
        return NO;
    }
    
    //获取字典
    NSMutableDictionary *dict=[self newPasswordDictionaryForKey:key];
    
    //方便起见，先删除后添加
    SecItemDelete((CFDictionaryRef)dict);
    
    //生成data
    NSData *data=[password dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置数据
    [dict setObject:data forKey:(id)kSecValueData];
    
    //添加
    OSStatus status=SecItemAdd((CFDictionaryRef)dict, NULL);
    
    //判断返回状态
    if(status==errSecSuccess)
    {
        return YES;
    }
    
    return NO;
}


//获取密码
+ (NSString *)passwordForKey:(NSString *)key
{
    if(!key)
    {
        return nil;
    }
    
    //获取字典
    NSMutableDictionary *searchDictionary=[self newPasswordDictionaryForKey:key];
    
    //在搜索keychain item的时候必须提供下面的两条用于搜索的属性
    //只返回搜索到的第一条item
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    //返回item的kSecValueData
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    //返回结果数据
    NSData *result=nil;
    
    //搜索
    OSStatus status=SecItemCopyMatching((CFDictionaryRef)searchDictionary,(CFTypeRef *)&result);
    
    if(status==errSecSuccess)
    {
        NSString *password=[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
        
        [result release];
        
        return password;
    }
    else
    {
        if(result)
        {
            [result release];
        }
    }
    
    return nil;
}


//删除密码
+ (BOOL)deletePasswordForKey:(NSString *)key
{
    if(!key)
    {
        return NO;
    }
    
    //获取字典
    NSMutableDictionary *dict=[self newPasswordDictionaryForKey:key];
    
    //删除
    OSStatus status=SecItemDelete((CFDictionaryRef)dict);
    
    if(status==errSecSuccess)
    {
        return YES;
    }
    
    return NO;
}


@end



