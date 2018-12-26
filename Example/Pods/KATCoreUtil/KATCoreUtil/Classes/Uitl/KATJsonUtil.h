//
//  KATJsonUtil.h
//  KATFramework
//
//  Created by Kantice on 15/9/15.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  Json格式文本解析工具

#import <Foundation/Foundation.h>

#import "KATArray.h"
#import "KATHashMap.h"


#define JSON_ARRAY_CAPACITY (256)
#define JSON_MAP_CAPACITY (256)
#define JSON_MAP_USAGE_MAX (70)


@interface KATJsonUtil : NSObject


#pragma mark - 类方法

///解析josn格式数据，返回HashMap，所有的非字符串数据都解析成字符串，字符串格式数据不支持单引号解析，支持转义符
+ (KATHashMap *)hashMapFromJson:(NSString *)json;


///json转对象(有class_name字段)
+ (id)objectFromJson:(NSString *)json;


///json转对象
+ (id)objectFromJson:(NSString *)json withClass:(Class)cls;


@end
