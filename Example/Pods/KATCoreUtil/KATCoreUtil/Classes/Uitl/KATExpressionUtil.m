//
//  KATExpressionUtil.m
//  KATFramework
//
//  Created by Kantice on 16/1/21.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATExpressionUtil.h"


//常量
NSString * const kExpressionNumber=@"[+-]?([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+)";//数字
NSString * const kExpressionHex=@"(0x)?[0-9A-Fa-f]{2,}";//十六进制数
NSString * const kExpressionOperator=@"[()\\^=/*+-]{1}";//操作符
NSString * const kExpressionUrl=@"((http|ftp|https|HTTP|FTP|HTTPS)://)?([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}|localhost|([a-zA-Z0-9._-]+\\.[a-zA-Z]{2,6})|([a-zA-Z0-9._-]+\\.[a-zA-Z0-9._-]+\\.[a-zA-Z]{2,6})){1}(:[0-9]{1,5})?((/[a-zA-Z0-9._-]+)*)?(\\?([a-zA-Z0-9._-])+=([a-zA-Z0-9._-])+(&([a-zA-Z0-9._-])+=([a-zA-Z0-9._-])+)*)?";//url表达式
NSString * const kExpressionUri=@"\\w+(\\.\\w+)*";
NSString * const kExpressionPhone=@"((\\+?[0-9]{2,3}-?)?((1[0-9]{10})|(1[0-9]{2}-[0-9]{4}-[0-9]{4})))|((0[0-9]{2,3}-?)?[0-9]{7,8})";//电话
NSString * const kExpressionMail=@"[A-Z0-9a-z._-]+@[A-Z0-9a-z._-]+\\.[a-zA-Z]{2,6}";//邮箱
NSString * const kExpressionChineseId=@"[0-9]{6}[1-2][0-9]{3}[0-1][0-9][0-3][0-9]{4}[0-9xX]";//中国身份证
NSString * const kExpressionChineseCharacter=@"[\u0391-\uFFE5]+";//汉字
NSString * const kExpressionUser=@"[a-zA-Z_][a-zA-Z0-9_]{2,19}";//用户名
NSString * const kExpressionDate=@"([1-9][0-9]{3}(/|-)(([1][0-9])|([0]?[1-9]))(/|-)(([1-3][0-9])|([0]?[1-9])))|((([1][0-9])|([0]?[1-9]))(/|-)(([1-3][0-9])|([0]?[1-9])))";//日期格式表达式
NSString * const kExpressionTime=@"([0-2][0-9]:[0-5][0-9]:[0-5][0-9])|([0-2][0-9]:[0-5][0-9])";//时间格式表达式
NSString * const kExpressionEmoji=@"(([🀀-🿿])|(.(\uFE0F|\uFE0E|[\uF3FB-\uF3FF])))+";//emoji标签表达式
NSString * const kExpressionEmpty=@"[\\s]+";//空白符



@implementation KATExpressionUtil



//关键字转化为表达式
+ (NSString *)expressionFromArray:(KATArray *)array
{
    if(array && array.length>0)
    {
        NSString *key=[array get:0];
        
        NSMutableString *ms=[NSMutableString stringWithFormat:@"(%@)",[self formatWithString:key]];
        
        for(int i=1;i<array.length;i++)
        {
            key=[array get:i];
            [ms appendFormat:@"|(%@)",[self formatWithString:key]];
        }
        
        return ms;
    }
    else
    {
        return nil;
    }
}


//区间转化为表达式
+ (NSString *)expressionWithStart:(NSString *)start andEnd:(NSString *)end
{
    if(start && end)
    {
        if(start.length==0 && end.length>0)
        {
            return [NSString stringWithFormat:@".*%@",[self formatWithString:end]];
        }
        else if(start.length>0 && end.length==0)
        {
            return [NSString stringWithFormat:@"%@.*",[self formatWithString:start]];
        }
        
        return [NSString stringWithFormat:@"%@[\\s\\S]*?%@",[self formatWithString:start],[self formatWithString:end]];
    }
    else
    {
        return nil;
    }
}



//判断是否匹配表达式
+ (BOOL)matchExpression:(NSString *)exp inString:(NSString *)str
{
    if([self hasExpression:exp inString:str])
    {
        NSRange range=[(NSValue *)[[self rangesWithExpression:exp inString:str] get:0] rangeValue];
        
        if(range.location==0 && range.length==str.length)
        {
            return YES;
        }
        
        return NO;
    }
    else
    {
        return NO;
    }
}


//判断是否包含表达式
+ (BOOL)hasExpression:(NSString *)exp inString:(NSString *)str
{
    if(str && str.length>0)
    {
        NSError *error;
        
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:exp options:0 error:&error];
        
        if(regex)
        {
            NSArray *match=[regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
            
            if(match.count>0)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}


//获取表达式范围
+ (KATArray<NSValue *> *)rangesWithExpression:(NSString *)exp inString:(NSString *)str
{
    if(str && str.length>0)
    {
        NSError *error;
        
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:exp options:0 error:&error];
        
        if(regex)
        {
            NSArray *match=[regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
            
            if(match.count>0)
            {
                KATArray<NSValue *> *arr=[KATArray arrayWithCapacity:(int)match.count];
                
                for(NSTextCheckingResult *res in match)
                {
                    [arr put:[NSValue valueWithRange:res.range]];
                }
                
                return arr;
            }
            else
            {
                return nil;
            }
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return nil;
    }
}


//获取匹配的内容
+ (KATArray<NSString *> *)contentsWithExpression:(NSString *)exp inString:(NSString *)str
{
    if(str && str.length>0)
    {
        NSError *error;
        
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:exp options:0 error:&error];
        
        if(regex)
        {
            NSArray *match=[regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
            
            if(match.count>0)
            {
                KATArray<NSString *> *arr=[KATArray arrayWithCapacity:(int)match.count];
                
                for(NSTextCheckingResult *res in match)
                {
                    [arr put:[str substringWithRange:res.range]];
                }
                
                return arr;
            }
            else
            {
                return nil;
            }
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return nil;
    }
}



//格式化表达式因子
+ (NSString *)formatWithString:(NSString *)str
{
    str=[str stringByReplacingOccurrencesOfString:@"[" withString:@"\\["];
    str=[str stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"];
    str=[str stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
    str=[str stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
    str=[str stringByReplacingOccurrencesOfString:@"{" withString:@"\\{"];
    str=[str stringByReplacingOccurrencesOfString:@"}" withString:@"\\}"];
    str=[str stringByReplacingOccurrencesOfString:@"*" withString:@"\\*"];
    str=[str stringByReplacingOccurrencesOfString:@"+" withString:@"\\+"];
    str=[str stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    str=[str stringByReplacingOccurrencesOfString:@"?" withString:@"\\?"];
    str=[str stringByReplacingOccurrencesOfString:@"^" withString:@"\\^"];
    str=[str stringByReplacingOccurrencesOfString:@"|" withString:@"\\|"];
    str=[str stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    str=[str stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    str=[str stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    
    return str;
}


@end


