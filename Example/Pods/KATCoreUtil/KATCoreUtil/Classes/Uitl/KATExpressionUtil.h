//
//  KATExpressionUtil.h
//  KATFramework
//
//  Created by Kantice on 16/1/21.
//  Copyright © 2016年 KatApp. All rights reserved.
//  正则表达式匹配工具

#import <Foundation/Foundation.h>

#import "KATArray.h"


#pragma -mark 常量

///数字表达式
extern NSString * const kExpressionNumber;

///十六进制数表达式
extern NSString * const kExpressionHex;

///操作符表达式
extern NSString * const kExpressionOperator;

///url表达式
extern NSString * const kExpressionUrl;

///URI资源定位符，带.分隔的
extern NSString * const kExpressionUri;

///电话号码表达式
extern NSString * const kExpressionPhone;

///邮箱地址表达式
extern NSString * const kExpressionMail;

///中国身份证号码表达式
extern NSString * const kExpressionChineseId;

///汉字表达式
extern NSString * const kExpressionChineseCharacter;

///用户名格式表达式
extern NSString * const kExpressionUser;

///日期格式表达式
extern NSString * const kExpressionDate;

///时间格式表达式
extern NSString * const kExpressionTime;

///emoji标签表达式
extern NSString * const kExpressionEmoji;

///空白符
extern NSString * const kExpressionEmpty;




@interface KATExpressionUtil : NSObject


#pragma mark - 类方法

///关键字转化为表达式
+ (NSString *)expressionFromArray:(KATArray *)array;

///区间转化为表达式（空字符串表示非换行符）(start或end其中一个为空串则表示单行区间)
+ (NSString *)expressionWithStart:(NSString *)start andEnd:(NSString *)end;

///判断是否匹配表达式
+ (BOOL)matchExpression:(NSString *)exp inString:(NSString *)str;

///判断是否包含表达式
+ (BOOL)hasExpression:(NSString *)exp inString:(NSString *)str;

///获取表达式范围
+ (KATArray<NSValue *> *)rangesWithExpression:(NSString *)exp inString:(NSString *)str;

///获取匹配的内容
+ (KATArray<NSString *> *)contentsWithExpression:(NSString *)exp inString:(NSString *)str;

///格式化表达式因子
+ (NSString *)formatWithString:(NSString *)str;


@end
