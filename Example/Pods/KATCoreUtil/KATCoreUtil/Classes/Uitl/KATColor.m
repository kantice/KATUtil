//
//  KATColors.m
//  KATFramework
//
//  Created by Kantice on 14-9-2.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//

#import "KATColor.h"

@implementation KATColor


//通过HSBA获取颜色(前2~3位为色相，取值范围为0~359度，之后2位为饱和度和明度，取值范围为0~99,最后2位为透明度，取值范围为0~99)
+ (UIColor *)colorWithHSBA:(int)HSBA
{
    CGFloat h=0,s=0,b=0,a=0;
    
    h=(HSBA/COLOR_HSBA_H%360)/360.0;
    s=(HSBA%COLOR_HSBA_H/COLOR_HSBA_S)/99.0;
    b=(HSBA%COLOR_HSBA_S/COLOR_HSBA_B)/99.0;
    a=(HSBA%COLOR_HSBA_B/COLOR_HSBA_A)/99.0;
    
    return [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
}


//通过颜色获取HSBA值
+ (KATFloatArray *)HSBAValueFromColor:(UIColor *)color
{
    if(color && [color respondsToSelector:@selector(getHue:saturation:brightness:alpha:)])
    {
        KATFloatArray *hsba=[KATFloatArray floatArrayWithCapacity:4];
        
        CGFloat h=0,s=0,b=0,a=0;
        
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
        
        [hsba put:h];
        [hsba put:s];
        [hsba put:b];
        [hsba put:a];
        
        return hsba;
    }
    
    return nil;
}


//通过颜色获取RGBA值
+ (KATFloatArray *)RGBAValueFromColor:(UIColor *)color
{
    if(color && [color respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        KATFloatArray *rgba=[KATFloatArray floatArrayWithCapacity:4];

        CGFloat r=0,g=0,b=0,a=0;

        [color getRed:&r green:&g blue:&b alpha:&a];

        [rgba put:r];
        [rgba put:g];
        [rgba put:b];
        [rgba put:a];

        return rgba;
    }

    return nil;
}


//通过RGBA字符串获取颜色
+ (UIColor *)colorWithRGBA:(NSString *)RGBA
{
    if(RGBA)
    {
        //去掉#
        RGBA=[RGBA stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    if(RGBA && RGBA.length==8)//8位数
    {
        const char *rgba=[RGBA UTF8String];
        
        if(strlen(rgba)==8)
        {
            int r=0;//红
            int g=0;//绿
            int b=0;//蓝
            int a=0;//透明
            
            for(int i=0;i<8 ;i++)
            {
                char ch=rgba[i];
                
                int value=-1;//数值
                
                if(ch>='0' && ch<='9')//数字
                {
                    value=ch-'0';
                }
                else if(ch>='A' && ch<='F')//大写字母
                {
                    value=ch-'A'+10;
                }
                else if(ch>='a' && ch<='z')//小写字母
                {
                    value=ch-'a'+10;
                }
                else//其他内容
                {
                    return nil;
                }
                
                if(i%2==0)//十位数
                {
                    value*=16;
                }
                
                if(i/2==0)//R
                {
                    r+=value;
                }
                else if(i/2==1)//G
                {
                    g+=value;
                }
                else if(i/2==2)//B
                {
                    b+=value;
                }
                else if(i/2==3)//A
                {
                    a+=value;
                }
            }
            
            return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
        }
    }
    
    return nil;
}


//通过RGB字符串获取颜色
+ (UIColor *)colorWithRGB:(NSString *)RGB
{
    return [KATColor colorWithRGBA:[NSString stringWithFormat:@"%@FF",RGB]];
}


//获取颜色的RGB字符串
+ (NSString *)RGBWithColor:(UIColor *)color
{
    if(!color)
    {
        return nil;
    }
    
    KATFloatArray *rgba=[self RGBAValueFromColor:color];
    
    return [NSString stringWithFormat:@"%02X%02X%02X",(int)([rgba get:0]*255),(int)([rgba get:1]*255),(int)([rgba get:2]*255)];
}


//获取颜色的RGBA字符串
+ (NSString *)RGBAWithColor:(UIColor *)color
{
    if(!color)
    {
        return nil;
    }
    
    KATFloatArray *rgba=[self RGBAValueFromColor:color];
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X",(int)([rgba get:0]*255),(int)([rgba get:1]*255),(int)([rgba get:2]*255),(int)([rgba get:3]*255)];
}


//获取颜色的HSBA数字
+ (int)HSBAWithColor:(UIColor *)color
{
    if(!color)
    {
        return 0;
    }
    
    KATFloatArray *hsba=[self HSBAValueFromColor:color];
    
    return ((int)([hsba get:0]*360))*COLOR_HSBA_H+((int)([hsba get:1]*99))*COLOR_HSBA_S+((int)([hsba get:2]*99))*COLOR_HSBA_B+((int)([hsba get:3]*99))*COLOR_HSBA_A;
}


//获取HSBA颜色代码:调整调整颜色代码的色相、纯度、亮度和透明度(调整值为当前值+偏移量)(偏移量为0则不调整，偏移量为负数则向左调整)(H范围为0~359,其他属性范围为0~99)
+ (int)HSBAFromOriginalHSBA:(int)HSBA withAdjustedH:(int)H S:(int)S B:(int)B A:(int)A
{
    int adjustedH=HSBA/COLOR_HSBA_H;
    int adjustedS=HSBA/COLOR_HSBA_S%100;
    int adjustedB=HSBA/COLOR_HSBA_B%100;
    int adjustedA=HSBA%100;
    
    //计算及修正
    adjustedH+=H;
    
    while(adjustedH<0 || adjustedH>=360)
    {
        if(adjustedH<0)
        {
            adjustedH+=360;
        }
        
        if(adjustedH>359)
        {
            adjustedH-=360;
        }
    }
    
    adjustedS+=S;
    
    if(adjustedS<0)
    {
        adjustedS=0;
    }
    
    if(adjustedS>99)
    {
        adjustedS=99;
    }
    
    adjustedB+=B;
    
    if(adjustedB<0)
    {
        adjustedB=0;
    }
    
    if(adjustedB>99)
    {
        adjustedB=99;
    }
    
    adjustedA+=A;
    
    if(adjustedA<0)
    {
        adjustedA=0;
    }
    
    if(adjustedA>99)
    {
        adjustedA=99;
    }
    
    return adjustedH*COLOR_HSBA_H+adjustedS*COLOR_HSBA_S+adjustedB*COLOR_HSBA_B+adjustedA*COLOR_HSBA_A;
}


//获取颜色:调整颜色代码的色相、纯度、亮度和透明度(调整值为当前值+偏移量)(偏移量为0则不调整，偏移量为负数则向左调整)(H范围为0~359,其他属性范围为0~99)
+ (UIColor *)colorFromOriginalHSBA:(int)HSBA withAdjustedH:(int)H S:(int)S B:(int)B A:(int)A
{
    return [self colorWithHSBA:[self HSBAFromOriginalHSBA:HSBA withAdjustedH:H S:S B:B A:A]];
}


//获取颜色:调整原有颜色的色相、纯度、亮度和透明度(调整值为当前值+偏移量)(偏移量为0则不调整，偏移量为负数则向左调整)(H范围为0~359,其他属性范围为0~99)
+ (UIColor *)colorFromOriginalColor:(UIColor *)color withAdjustedH:(int)H S:(int)S B:(int)B A:(int)A
{
    return [self colorFromOriginalHSBA:[self HSBAWithColor:color] withAdjustedH:H S:S B:B A:A];
}


//改变颜色的透明度
+ (UIColor *)colorFromOldColor:(UIColor *)old withAlpha:(float)alpha
{
    KATFloatArray *rgba=[self RGBAValueFromColor:old];
    
    return [UIColor colorWithRed:[rgba get:0] green:[rgba get:1] blue:[rgba get:2] alpha:alpha];
}


//获取颜色的透明度
+ (CGFloat)alphaWithColor:(UIColor *)color
{
    return [[self RGBAValueFromColor:color] get:3];
}


//获取两个颜色的中间过渡色
+ (UIColor *)middleColorWithColorA:(UIColor *)ca andColorB:(UIColor *)cb
{
    int hsbaA=[self HSBAWithColor:ca];
    int hsbaB=[self HSBAWithColor:cb];
    int ha=hsbaA/COLOR_HSBA_H;
    int hb=hsbaB/COLOR_HSBA_H;
    int sa=hsbaA/COLOR_HSBA_S%100;
    int sb=hsbaB/COLOR_HSBA_S%100;
    int ba=hsbaA/COLOR_HSBA_B%100;
    int bb=hsbaB/COLOR_HSBA_B%100;
    int aa=hsbaA%100;
    int ab=hsbaB%100;
    
    int h=0;
    int s=0;
    int b=0;
    int a=0;
    
    if(ha<=hb)
    {
        h=ha+(hb-ha)/2;
    }
    else
    {
        h=hb+(ha-hb)/2.0;
    }
    
    if(h>=360)
    {
        h-=360;
    }
    
    if(h<0)
    {
        h+=360;
    }
    
    if(sa<=sb)
    {
        s=sa+(sb-sa)/2;
    }
    else
    {
        s=sb+(sa-sb)/2;
    }
    
    if(s>99)
    {
        s=99;
    }
    
    if(s<0)
    {
        s=0;
    }
    
    if(ba<=bb)
    {
        b=ba+(bb-ba)/2;
    }
    else
    {
        b=bb+(ba-bb)/2;
    }
    
    if(b>99)
    {
        b=99;
    }
    
    if(b<0)
    {
        b=0;
    }
    
    if(aa<=ab)
    {
        a=aa+(ab-aa)/2;
    }
    else
    {
        a=ab+(aa-ab)/2;
    }
    
    if(a>99)
    {
        a=99;
    }
    
    if(a<0)
    {
        a=0;
    }
    
    NSLog(@"h=%i,s=%i,b=%i,a=%i",h,s,b,a);
    
    
    return [self colorWithHSBA:h*COLOR_HSBA_H+s*COLOR_HSBA_S+b*COLOR_HSBA_B+a*COLOR_HSBA_A];
}



@end
