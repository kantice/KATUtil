//
//  KATStringUtil.m
//  KATFramework
//
//  Created by Kantice on 16/1/26.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATStringUtil.h"

@implementation KATStringUtil


//将html内容转化为富文本字符串
+ (NSAttributedString *)attrStringWithHtml:(NSString *)html
{
    if(html)
    {
        NSAttributedString *attrStr=[[[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil] autorelease];
    
        return attrStr;
    }
    else
    {
        return nil;
    }
}



//给url添加http头
+ (NSString *)httpHeaderWithUrl:(NSString *)url
{
    if(url)
    {
        NSRange range=[url rangeOfString:@"http://"];
        
        if(range.length>0)//有http头
        {
            return url;
        }
        else//添加http头
        {
            range=[url rangeOfString:@"https://"];
            
            if(range.length>0)//有https头的，不转化
            {
                return url;
            }
            else
            {
                return [NSString stringWithFormat:@"http://%@",url];
            }
        }
    }
    else
    {
        return nil;
    }
}



//给url添加https头
+ (NSString *)httpsHeaderWithUrl:(NSString *)url
{
    if(url)
    {
        NSRange range=[url rangeOfString:@"https://"];
        
        if(range.length>0)//有https头
        {
            return url;
        }
        else//添加https头
        {
            range=[url rangeOfString:@"http://"];
            
            if(range.length>0)//带http头，修改为https
            {
                return [NSString stringWithFormat:@"https://%@",[url substringFromIndex:range.location+range.length]];
            }
            else
            {
                return [NSString stringWithFormat:@"https://%@",url];
            }
        }
    }
    else
    {
        return nil;
    }
}


//字符串转URL
+ (NSURL *)urlWithString:(NSString *)string
{
    return [NSURL URLWithString:string];
}


//URL转字符串
+ (NSString *)stringWithUrl:(NSURL *)url
{
    return [url absoluteString];
}


//转化为百分号编码（Get请求带中文字符串）
+ (NSString *)percentEncodingWithString:(NSString *)string
{
    if(string)
    {
        return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        return nil;
    }
}


//获取字体大小(通过给定的字体名(空为系统默认字体)、尺寸、最大字体、最小字体和留空)
+ (UIFont *)fontWithName:(NSString *)name size:(CGSize)size max:(float)max min:(float)min padding:(float)padding andText:(NSString *)text
{
    //修正
    if(min<4.0)
    {
        min=4.0;
    }
    
    if(max>256.0)
    {
        max=256.0;
    }
    
    if(max<min)
    {
        max=min;
    }
    
    //返回的字体
    UIFont *font=nil;
    
    
    //二分法
    float l=min;//左
    float r=max;//右
    float m=(l+r)/2.0;//中
    float f=m;//字体尺寸
    float dif=0.4;//调控偏差
    
    //约束尺寸
    CGSize cs=CGSizeMake(size.width-2*padding, size.height-2*padding);
    
    while(m>min && m<max)
    {
        f=m;
        
        if(name)//指定字体
        {
            font=[UIFont fontWithName:name size:f];
        }
        else//系统字体
        {
            font=[UIFont systemFontOfSize:f];
        }
        
        CGSize ns=[text boundingRectWithSize:CGSizeMake(cs.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        
        if(ns.height<cs.height)//偏小
        {
            l=m;
        }
        else if(ns.height>cs.height)//偏大
        {
            r=m;
        }
        else//相等
        {
            break;
        }
        
        if(fabsf(r-l)<=dif*5.0)//精细控制
        {
            for(int i=4;i>=0;i--)
            {
                f=r-(5-i)*dif;
                
                if(name)//指定字体
                {
                    font=[UIFont fontWithName:name size:f];
                }
                else//系统字体
                {
                    font=[UIFont systemFontOfSize:f];
                }
                
                CGSize ns=[text boundingRectWithSize:CGSizeMake(cs.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
                
                if(ns.height<cs.height)
                {
                    break;
                }
            }
            
            break;
        }
        
        m=(l+r)/2.0;
        
        /*
        if(fabsf(f-m)<=dif)
        {
            break;
        }
        */
        
    }
    
    return font;
}


//获取字体大小(默认参数:系统字体、最大字体64、最小字体6、留空1)
+ (UIFont *)fontWithSize:(CGSize)size andText:(NSString *)text
{
    return [self fontWithName:nil size:size max:64.0 min:6.0 padding:1.0f andText:text];
}



@end
