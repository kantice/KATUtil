//
//  KATURIParser.m
//  KATFramework
//
//  Created by Kantice on 2017/4/25.
//  Copyright © 2017年 KatApp. All rights reserved.


#import "KATURIParser.h"


NSString * const kURIKeyScheme=@"scheme";
NSString * const kURIKeyUser=@"user";
NSString * const kURIKeyHost=@"host";
NSString * const kURIKeyPort=@"port";
NSString * const kURIKeyPath=@"path";
NSString * const kURIKeyQuery=@"query";
NSString * const kURIKeyFragment=@"fragment";


@implementation KATURIParser


//解析方法
+ (KATHashMap *)parseURI:(NSString *)URIString
{
    if(URIString)
    {
        //去掉空格
        URIString=[URIString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if(URIString.length>0)
        {
            KATHashMap *map=[KATHashMap hashMapWithCapacity:20 andMaxUsage:100];
            
            NSRange range;
            
            
            //解析fragment #后的内容
            range=[URIString rangeOfString:@"#"];
            
            if(range.length>0)//找到
            {
                if(range.location<URIString.length-1)//非空内容
                {
                    NSString *fragment=[URIString substringFromIndex:range.location+1];
                    
                    map[kURIKeyFragment]=fragment;
                }
                
                //截取
                URIString=[URIString substringToIndex:range.location];
            }
            
            
            //解析scheme ://前的内容
            range=[URIString rangeOfString:@"://"];
            
            if(range.length>0)//找到
            {
                if(range.location>0)//非空内容
                {
                    NSString *scheme=[URIString substringToIndex:range.location];
                    
                    map[kURIKeyScheme]=scheme;
                }
                
                //截取
                URIString=[URIString substringFromIndex:range.location+3];
            }
            
            
            //解析user @之前的内容
            range=[URIString rangeOfString:@"@"];
            
            if(range.length>0)//找到
            {
                if(range.location>0)//非空内容
                {
                    NSString *user=[URIString substringToIndex:range.location];
                    
                    map[kURIKeyUser]=user;
                }
                
                //截取
                URIString=[URIString substringFromIndex:range.location+1];
            }
            
            
            //解析query ?之后的内容
            range=[URIString rangeOfString:@"?"];
            
            if(range.length>0)//找到
            {
                if(range.location<URIString.length-1)//非空内容
                {
                    NSString *query=[URIString substringFromIndex:range.location+1];
                    
                    KATHashMap *queryMap=[KATHashMap hashMapWithString:query andSep:@"&" andOpt:@"="];
                    
                    map[kURIKeyQuery]=queryMap;
                }
                
                //截取
                URIString=[URIString substringToIndex:range.location];
            }
            
            
            //解析path /之后的内容
            range=[URIString rangeOfString:@"/"];
            
            if(range.length>0)//找到
            {
                NSString *path=[URIString substringFromIndex:range.location];
                
                map[kURIKeyPath]=path;
                
                //截取
                URIString=[URIString substringToIndex:range.location];
            }
            
            
            //解析port :之后的内容
            range=[URIString rangeOfString:@":"];
            
            if(range.length>0)//找到
            {
                if(range.location<URIString.length-1)//非空内容
                {
                    NSString *port=[URIString substringFromIndex:range.location+1];
                    
                    map[kURIKeyPort]=port;
                }
                
                //截取
                URIString=[URIString substringToIndex:range.location];
            }
            
            
            //剩下的为host
            if(URIString.length>0)
            {
                map[kURIKeyHost]=URIString;
            }
                        
            return map;
        }
    }
    
    return nil;
}


//从map中构造URI
+ (NSString *)URIWithMap:(KATHashMap *)map
{
    if(map)
    {
        NSMutableString *URI=[NSMutableString string];
        
        if(map[kURIKeyScheme])
        {
            [URI appendFormat:@"%@://",map[kURIKeyScheme]];
        }
        
        if(map[kURIKeyUser])
        {
            [URI appendFormat:@"%@@",map[kURIKeyUser]];
        }
        
        if(map[kURIKeyHost])
        {
            [URI appendFormat:@"%@",map[kURIKeyHost]];
        }
        
        if(map[kURIKeyPort])
        {
            [URI appendFormat:@":%@",map[kURIKeyPort]];
        }
        
        if(map[kURIKeyPath])
        {
            [URI appendFormat:@"%@",map[kURIKeyPath]];
        }
        
        if(map[kURIKeyQuery] && [map[kURIKeyQuery] isKindOfClass:[KATHashMap class]])
        {
            KATHashMap *query=map[kURIKeyQuery];
            
            if(query.length>0)
            {
                [URI appendString:@"?"];
                
                KATArray<NSString *> *keys=[query allKeys];
                
                //遍历查询键值对
                for(int i=0;i<keys.length;i++)
                {
                    NSString *key=keys[i];
                    
                    if(i==0)
                    {
                        [URI appendFormat:@"%@=%@",key,query[key]];
                    }
                    else
                    {
                        [URI appendFormat:@"&%@=%@",key,query[key]];
                    }
                }
            }
        }
        
        if(map[kURIKeyFragment])
        {
            [URI appendFormat:@"#%@",map[kURIKeyFragment]];
        }
        
        
        return URI;
    }
    
    return nil;
}


//设置scheme(带不带://都可以)
+ (NSString *)setScheme:(NSString *)scheme withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    if(scheme)
    {
        scheme=[[scheme stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    
    map[kURIKeyScheme]=scheme;
    
    return [self URIWithMap:map];
}


//设置user(带不带@都可以)
+ (NSString *)setUser:(NSString *)user withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    if(user)
    {
        user=[user stringByReplacingOccurrencesOfString:@"@" withString:@""];
    }
    
    map[kURIKeyUser]=user;
    
    return [self URIWithMap:map];
}


//设置host
+ (NSString *)setHost:(NSString *)host withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    map[kURIKeyHost]=host;
    
    return [self URIWithMap:map];
}


//设置port
+ (NSString *)setPort:(unsigned)port withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    map[kURIKeyPort]=[NSString stringWithFormat:@"%u",port];
    
    return [self URIWithMap:map];
}


//设置path
+ (NSString *)setPath:(NSString *)path withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    map[kURIKeyPath]=path;
    
    return [self URIWithMap:map];
}


//设置query(带不带?都可以)
+ (NSString *)setQuery:(NSString *)query withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    if(query)
    {
        query=[query stringByReplacingOccurrencesOfString:@"?" withString:@""];
    }
    
    map[kURIKeyQuery]=[KATHashMap hashMapWithString:query andSep:@"&" andOpt:@"="];
    
    return [self URIWithMap:map];
}


//设置fragment(带不带#都可以)
+ (NSString *)setFragment:(NSString *)fragment withURI:(NSString *)URIString
{
    KATHashMap *map=[self parseURI:URIString];
    
    if(fragment)
    {
        fragment=[fragment stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    map[kURIKeyFragment]=fragment;
    
    return [self URIWithMap:map];
}



@end
