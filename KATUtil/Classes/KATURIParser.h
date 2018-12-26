//
//  KATURIParser.h
//  KATFramework
//
//  Created by Kantice on 2017/4/25.
//  Copyright © 2017年 KatApp. All rights reserved.
//  URI解析工具


#import <Foundation/Foundation.h>

#import "KATHashMap.h"



//URI例: https://kat@kantice.com:80/path?id=1&name=k#frag
//       scheme://user@host:80/path?query#fragment


///scheme的key
extern NSString * const kURIKeyScheme;

///user的key
extern NSString * const kURIKeyUser;

///host的key
extern NSString * const kURIKeyHost;

///port的key
extern NSString * const kURIKeyPort;

///path的key
extern NSString * const kURIKeyPath;

///query的key
extern NSString * const kURIKeyQuery;

///fragment的key
extern NSString * const kURIKeyFragment;





@interface KATURIParser : NSObject


///解析方法
+ (KATHashMap *)parseURI:(NSString *)URIString;

///从map中构造URI
+ (NSString *)URIWithMap:(KATHashMap *)map;

///设置scheme(带不带://都可以)
+ (NSString *)setScheme:(NSString *)scheme withURI:(NSString *)URIString;

///设置user(带不带@都可以)
+ (NSString *)setUser:(NSString *)user withURI:(NSString *)URIString;

///设置host
+ (NSString *)setHost:(NSString *)host withURI:(NSString *)URIString;

///设置port
+ (NSString *)setPort:(unsigned)port withURI:(NSString *)URIString;

///设置path
+ (NSString *)setPath:(NSString *)path withURI:(NSString *)URIString;

///设置query(带不带?都可以)
+ (NSString *)setQuery:(NSString *)query withURI:(NSString *)URIString;

///设置fragment(带不带#都可以)
+ (NSString *)setFragment:(NSString *)fragment withURI:(NSString *)URIString;




@end





