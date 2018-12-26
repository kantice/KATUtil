//
//  KATJsonUtil.m
//  KATFramework
//
//  Created by Kantice on 15/9/15.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//

#import "KATJsonUtil.h"

@implementation KATJsonUtil



//Json转对象
+ (id)objectFromJson:(NSString *)json
{
    return [[self hashMapFromJson:json] object];
}


//json转对象
+ (id)objectFromJson:(NSString *)json withClass:(Class)cls
{
    return [[self hashMapFromJson:json] objectFromMapWithClass:cls];
}


//解析josn
+ (KATHashMap *)hashMapFromJson:(NSString *)json
{
    if(json && json.length>0)
    {
        //转变为C字符串
        const char *src=[json cStringUsingEncoding:NSUTF8StringEncoding];
        
        KATHashMap *root=[KATHashMap hashMapWithCapacity:JSON_MAP_CAPACITY andMaxUsage:JSON_MAP_USAGE_MAX];
        root.isJsonDescription=YES;
        
        int si=-1;//开始点
        int ei=-1;//结束点
        int i=0;
        BOOL quote=NO;
        int mark=0;//括号标记(左括号＋1，右括号－1)
        
        //计算开始点与结束点
        while(src[i]!='\0')
        {
            if(src[i]=='"' && i>0 && src[i-1]!='\\')
            {
                quote=!quote;
            }
            
            if(src[i]=='{' && !quote)
            {
                mark++;
                
                if(si<0)
                {
                    si=i;
                }
            }
            else if (src[i]=='}' && !quote)
            {
                mark--;
                
                if(mark==0)//结束
                {
                    ei=i;
                    
                    break;
                }
            }
            
            i++;
        }
        
        [self parseWithRoot:root andStartIndex:si+1 andEndIndex:ei-1 andSrc:src];
        
        return root;
    }
    else
    {
        return nil;
    }
}



//内部方法：解析根节点，作为Object的属性
+ (void)parseWithRoot:(KATHashMap *)root andStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src
{
//    NSLog(@"######  root");
    
    //解析内容，按逗号分割item
    BOOL quote=NO;
    int mark=0;//花括号标记(左括号＋1，右括号－1)
    int mark2=0;//方括号标记(左括号＋1，右括号－1)
    
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        
        if(src[i]=='{' && !quote)
        {
            mark++;
        }
        else if (src[i]=='}' && !quote)
        {
            mark--;
        }
        
        if(src[i]=='[' && !quote)
        {
            mark2++;
        }
        else if (src[i]==']' && !quote)
        {
            mark2--;
        }
        
        
        if(src[i]==',' && !quote && mark==0 && mark2==0)//遇到非引号内的逗号
        {
            [self parseItemWithStartIndex:si andEndIndex:i-1 andSrc:src andObjectParent:root];
            
            si=i+1;
        }
    }
    
    //最后一个item
    [self parseItemWithStartIndex:si andEndIndex:ei andSrc:src andObjectParent:root];
 
}




//内部方法：解析数组，作为Object的属性
+ (void)parseArrayWithKey:(NSString *)key andStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src andObjectParent:(KATHashMap *)parent
{
//    NSLog(@"######  arr > map");
    
    //创建Object的Hash Map
    KATArray *array=[KATArray arrayWithCapacity:JSON_ARRAY_CAPACITY];
    array.isJsonDescription=YES;
    
    [parent putWithKey:key andValue:array];
    
    
    //解析内容，按逗号分割item
    BOOL quote=NO;
    int mark=0;//花括号标记(左括号＋1，右括号－1)
    int mark2=0;//方括号标记(左括号＋1，右括号－1)
    
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]=='{' && !quote)
        {
            mark++;
        }
        else if (src[i]=='}' && !quote)
        {
            mark--;
        }
        
        if(src[i]=='[' && !quote)
        {
            mark2++;
        }
        else if (src[i]==']' && !quote)
        {
            mark2--;
        }
        
        if(src[i]==',' && !quote && mark==0 && mark2==0)//遇到非引号内的逗号
        {
            [self parseItemWithStartIndex:si andEndIndex:i-1 andSrc:src andArrayParent:array];
            
            si=i+1;
        }
    }
    
    //最后一个item
    [self parseItemWithStartIndex:si andEndIndex:ei andSrc:src andArrayParent:array];
    
}


//内部方法：解析数组，作为Array的成员
+ (void)parseArrayWithStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src andArrayParent:(KATArray *)parent
{
//    NSLog(@"######  arr > arr");
    
    //创建Object的Hash Map
    KATArray *array=[KATArray arrayWithCapacity:JSON_ARRAY_CAPACITY];
    array.isJsonDescription=YES;
    
    [parent put:array];
    
    
    //解析内容，按逗号分割item
    BOOL quote=NO;
    int mark=0;//花括号标记(左括号＋1，右括号－1)
    int mark2=0;//方括号标记(左括号＋1，右括号－1)
    
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]=='{' && !quote)
        {
            mark++;
        }
        else if (src[i]=='}' && !quote)
        {
            mark--;
        }
        
        if(src[i]=='[' && !quote)
        {
            mark2++;
        }
        else if (src[i]==']' && !quote)
        {
            mark2--;
        }
        
        if(src[i]==',' && !quote && mark==0 && mark2==0)//遇到非引号内的逗号
        {
            [self parseItemWithStartIndex:si andEndIndex:i-1 andSrc:src andArrayParent:array];
            
            si=i+1;
        }
    }
    
    //最后一个item
    [self parseItemWithStartIndex:si andEndIndex:ei andSrc:src andArrayParent:array];
}



//内部方法：解析对象，作为Array的成员
+ (void)parseObjectWithStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src andArrayParent:(KATArray *)parent
{
//    NSLog(@"######  map > arr");
    
    //创建Object的Hash Map
    KATHashMap *map=[KATHashMap hashMapWithCapacity:JSON_MAP_CAPACITY andMaxUsage:JSON_MAP_USAGE_MAX];
    map.isJsonDescription=YES;
    
    [parent put:map];
    
    //解析内容，按逗号分割item
    BOOL quote=NO;
    int mark=0;//花括号标记(左括号＋1，右括号－1)
    int mark2=0;//方括号标记(左括号＋1，右括号－1)
    
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]=='{' && !quote)
        {
            mark++;
        }
        else if (src[i]=='}' && !quote)
        {
            mark--;
        }
        
        if(src[i]=='[' && !quote)
        {
            mark2++;
        }
        else if (src[i]==']' && !quote)
        {
            mark2--;
        }
        
        if(src[i]==',' && !quote && mark==0 && mark2==0)//遇到非引号内的逗号
        {
            [self parseItemWithStartIndex:si andEndIndex:i-1 andSrc:src andObjectParent:map];
            
            si=i+1;
        }
    }
    
    //最后一个item
    [self parseItemWithStartIndex:si andEndIndex:ei andSrc:src andObjectParent:map];
}


//内部方法：解析对象，作为Object的属性
+ (void)parseObjectWithKey:(NSString *)key andStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src andObjectParent:(KATHashMap *)parent
{
//    NSLog(@"######  map > map");
    
    //创建Object的Hash Map
    KATHashMap *map=[KATHashMap hashMapWithCapacity:JSON_MAP_CAPACITY andMaxUsage:JSON_MAP_USAGE_MAX];
    map.isJsonDescription=YES;
    
    [parent putWithKey:key andValue:map];
    
    //解析内容，按逗号分割item
    BOOL quote=NO;
    int mark=0;//花括号标记(左括号＋1，右括号－1)
    int mark2=0;//方括号标记(左括号＋1，右括号－1)
    
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]=='{' && !quote)
        {
            mark++;
        }
        else if (src[i]=='}' && !quote)
        {
            mark--;
        }
        
        if(src[i]=='[' && !quote)
        {
            mark2++;
        }
        else if (src[i]==']' && !quote)
        {
            mark2--;
        }
        
        if(src[i]==',' && !quote && mark==0 && mark2==0)//遇到非引号内的逗号
        {
            [self parseItemWithStartIndex:si andEndIndex:i-1 andSrc:src andObjectParent:map];
            
            si=i+1;
        }
    }
    
    //最后一个item
    [self parseItemWithStartIndex:si andEndIndex:ei andSrc:src andObjectParent:map];
}



//内部方法：解析内容，作为Array的成员(没有键)
+ (void)parseItemWithStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src andArrayParent:(KATArray *)parent
{
//    NSLog(@"######  a_item");
    
    BOOL isObjectValue=NO;//是否为对象值
    BOOL isArrayValue=NO;//是否为数组值
    BOOL quote=NO;
    
    //解析值类型
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]=='[' && !quote)
        {
            isArrayValue=YES;
            si=i+1;
            break;
        }
        
        if(src[i]=='{' && !quote)
        {
            isObjectValue=YES;
            si=i+1;
            break;
        }
    }
    
    if(isObjectValue)//对象值
    {
        BOOL quote=NO;
        int mark=1;//花括号标记(左括号＋1，右括号－1)
        
        //计算开始点与结束点
        for(int i=si;i<=ei;i++)
        {
            if(src[i]=='"' && i>0 && src[i-1]!='\\')
            {
                quote=!quote;
            }
            
            if(src[i]=='{' && !quote)
            {
                mark++;
            }
            else if (src[i]=='}' && !quote)
            {
                mark--;
                
                if(mark==0)//结束
                {
                    ei=i-1;
                    
                    break;
                }
            }
        }
        
        [self parseObjectWithStartIndex:si andEndIndex:ei andSrc:src andArrayParent:parent];
    }
    else if(isArrayValue)//数组值
    {
        BOOL quote=NO;
        int mark=1;//方括号标记(左括号＋1，右括号－1)
        
        //计算开始点与结束点
        for(int i=si;i<=ei;i++)
        {
            if(src[i]=='"' && i>0 && src[i-1]!='\\')
            {
                quote=!quote;
            }
            
            if(src[i]=='[' && !quote)
            {
                mark++;
            }
            else if (src[i]==']' && !quote)
            {
                mark--;
                
                if(mark==0)//结束
                {
                    ei=i-1;
                    
                    break;
                }
            }
        }
        
        [self parseArrayWithStartIndex:si andEndIndex:ei andSrc:src andArrayParent:parent];
    }
    else//普通值
    {
        id value=[self parseValueWithStartIndex:si andEndIndex:ei andSrc:src];
        
        [parent put:value];
    }
    
}



//内部方法：解析条目，作为Object的属性
+ (void)parseItemWithStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src andObjectParent:(KATHashMap *)parent
{
//    NSLog(@"######  m_item");
    
    NSString *key=nil;//键
    
    BOOL quote=NO;
    
    //先解析出冒号
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]==':' && !quote)//找到冒号，则为键值对格式
        {
            key=[self parseKeyWithStartIndex:si andEndIndex:i-1 andSrc:src];
            
            si=i+1;
            
            break;
        }
    }
    
    
    BOOL isObjectValue=NO;//是否为对象值
    BOOL isArrayValue=NO;//是否为数组值
    quote=NO;
    
    //解析值类型
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')//遇到双引号
        {
            if(src[i-1]!='\\')
            {
                quote=!quote;
            }
        }
        
        if(src[i]=='[' && !quote)
        {
            isArrayValue=YES;
            si=i+1;
            break;
        }
        
        if(src[i]=='{' && !quote)
        {
            isObjectValue=YES;
            si=i+1;
            break;
        }
    }
    
    
    if(isObjectValue)//对象值
    {
        BOOL quote=NO;
        int mark=1;//花括号标记(左括号＋1，右括号－1)
        
        //计算开始点与结束点
        for(int i=si;i<=ei;i++)
        {
            if(src[i]=='"' && i>0 && src[i-1]!='\\')
            {
                quote=!quote;
            }
            
            if(src[i]=='{' && !quote)
            {
                mark++;
            }
            else if (src[i]=='}' && !quote)
            {
                mark--;
                
                if(mark==0)//结束
                {
                    ei=i-1;
                    
                    break;
                }
            }
        }
        
        [self parseObjectWithKey:key andStartIndex:si andEndIndex:ei andSrc:src andObjectParent:parent];
    }
    else if(isArrayValue)//数组值
    {
        BOOL quote=NO;
        int mark=1;//方括号标记(左括号＋1，右括号－1)
        
        //计算开始点与结束点
        for(int i=si;i<=ei;i++)
        {
            if(src[i]=='"' && i>0 && src[i-1]!='\\')
            {
                quote=!quote;
            }
            
            if(src[i]=='[' && !quote)
            {
                mark++;
            }
            else if (src[i]==']' && !quote)
            {
                mark--;
                
                if(mark==0)//结束
                {
                    ei=i-1;
                    
                    break;
                }
            }
        }
        
        [self parseArrayWithKey:key andStartIndex:si andEndIndex:ei andSrc:src andObjectParent:parent];
    }
    else//普通值
    {
        id value=[self parseValueWithStartIndex:si andEndIndex:ei andSrc:src];
        
        [parent putWithKey:key andValue:value];
    }
}





//内部方法：解析key
+ (NSString *)parseKeyWithStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src
{
//    NSLog(@"######  key");
    
    //寻找key首字符
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')
        {
            si=i+1;
            
            break;
        }
    }
    
    //寻找key尾字符
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"' && src[i-1]!='\\')
        {
            ei=i-1;
            
            break;
        }
    }
    
    
    if(ei-si+1<0)//边界判断
    {
//        NSLog(@"key xxxx");
        
        return nil;
    }
    
    if(ei-si+1==0)//空字符
    {
        return @"";
    }
    
    //复制字符串
//    char *k=malloc(sizeof(char)*(ei-si+1+1));
    char k[ei-si+1+1];
    
    for(int i=0;i<ei-si+1;i++)
    {
        k[i]=src[si+i];
    }

    k[ei-si+1]='\0';
    
    //转化为NSString
    NSString *key=[NSString stringWithCString:k encoding:NSUTF8StringEncoding];
    
    //解析转义的引号
    key=[key stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    //释放内存
//    free(k);
    
//    NSLog(@"key=%@",key);
    
    return key;
}



//内部方法：解析值（普通）
+ (id)parseValueWithStartIndex:(int)si andEndIndex:(int)ei andSrc:(const char *)src
{
//    NSLog(@"######  value");
    
    //解析内容，按逗号分割item
    BOOL quote=NO;
    
    //寻找value首字符
    for(int i=si;i<=ei;i++)
    {
        if(src[i]=='"')
        {
            quote=YES;
            
            si=i+1;
            
            break;
        }
        
        if(src[i]!=' ' && src[i]!='\t' && src[i]!='\n' && src[i]!='\r' && src[i]!='"')
        {
            si=i;
            
            break;
        }
    }
    
    //寻找value尾字符
    for(int i=si;i<=ei;i++)
    {
        if(quote)//字符串类型
        {
            if(src[i]=='"' && src[i-1]!='\\')
            {
                ei=i-1;
                
                break;
            }
        }
        else
        {
            if(src[i]==' ' || src[i]=='\t' || src[i]=='\n' || src[i]=='\r')
            {
                ei=i-1;
                
                break;
            }
        }
    }
    
    if(ei-si+1<0)//边界判断
    {
        return nil;
    }
    
    if(ei-si+1==0)//空字符
    {
        if(quote)//字符串内容值
        {
            return @"";
        }
        else
        {
            return nil;
        }
    }
    
    //复制字符串
//    char *v=malloc(sizeof(char)*(ei-si+1+1));
    char v[ei-si+1+1];
    
    for(int i=0;i<ei-si+1;i++)
    {
        v[i]=src[si+i];
    }
    
    v[ei-si+1]='\0';
    
    //转化为NSString
    NSString *value=[NSString stringWithCString:v encoding:NSUTF8StringEncoding];
    
    //解析转义的引号
    value=[value stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    //释放内存
//    free(v);
    
    if(!quote)//非字符串
    {
        //空值
        if([[value lowercaseString] isEqualToString:@"null"] || [[value lowercaseString] isEqualToString:@"nil"])//空值判断
        {
            return nil;
        }
        
        //bool类型
        if([[value lowercaseString] isEqualToString:@"true"] || [[value lowercaseString] isEqualToString:@"yes"])
        {
            return @(YES);
        }
        else if([[value lowercaseString] isEqualToString:@"false"] || [[value lowercaseString] isEqualToString:@"no"])
        {
            return @(NO);
        }
        
        //数值类型
        NSRange range=[value rangeOfString:@"."];//寻找小数点
        
        if(range.length>0)//带小数点
        {
            return @([value doubleValue]);
        }
        else//不带小数点
        {
            return @([value longLongValue]);
        }
    }

//    NSLog(@"v=%@",value);
    
    return value;
}


@end
