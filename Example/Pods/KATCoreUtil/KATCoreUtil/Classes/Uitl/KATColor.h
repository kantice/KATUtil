//
//  KATColors.h
//  KATFramework
//
//  Created by Kantice on 14-9-2.
//  Copyright (c) 2014年 KatApp. All rights reserved.
//  拾色器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "KATArray.h"
#import "KATFloatArray.h"



#define COLOR_HSBA_H 1000000
#define COLOR_HSBA_S 10000
#define COLOR_HSBA_B 100
#define COLOR_HSBA_A 1

//色环
#define COLOR_H0 999999
#define COLOR_H15 15999999
#define COLOR_H30 30999999
#define COLOR_H45 45999999
#define COLOR_H60 60999999
#define COLOR_H75 75999999
#define COLOR_H90 90999999
#define COLOR_H105 105999999
#define COLOR_H120 120999999
#define COLOR_H135 135999999
#define COLOR_H150 150999999
#define COLOR_H165 165999999
#define COLOR_H180 180999999
#define COLOR_H195 195999999
#define COLOR_H210 210999999
#define COLOR_H225 225999999
#define COLOR_H240 240999999
#define COLOR_H255 255999999
#define COLOR_H270 270999999
#define COLOR_H285 285999999
#define COLOR_H300 300999999
#define COLOR_H315 315999999
#define COLOR_H330 330999999
#define COLOR_H345 345999999

//灰阶
#define COLOR_G99 9999
#define COLOR_G95 9599
#define COLOR_G90 9099
#define COLOR_G85 8599
#define COLOR_G80 8099
#define COLOR_G75 7599
#define COLOR_G70 7099
#define COLOR_G65 6599
#define COLOR_G60 6099
#define COLOR_G55 5599
#define COLOR_G50 5099
#define COLOR_G45 4599
#define COLOR_G40 4099
#define COLOR_G35 3599
#define COLOR_G30 3099
#define COLOR_G25 2599
#define COLOR_G20 2099
#define COLOR_G15 1599
#define COLOR_G10 1099
#define COLOR_G5 599
#define COLOR_G0 99


//常用色

//红
#define COLOR_RED 5869999

//火
#define COLOR_FIRE 13849799

//珊瑚
#define COLOR_CORAL 16709999

//巧克力
#define COLOR_CHOCOLATE 25868299

//橙
#define COLOR_ORANGE 35999999

//古铜
#define COLOR_BRONZE 41888899

//金
#define COLOR_GOLD 48999999

//黄
#define COLOR_YELLOW 57999999

//橄榄
#define COLOR_OLIVE 73807199

//黄绿
#define COLOR_CHARTREUSE 90849599

//青柠
#define COLOR_LIME 106929399

//森林
#define COLOR_FOREST 120765599

//绿
#define COLOR_GREEN 130698699

//草绿
#define COLOR_GRASS 144995599

//春
#define COLOR_SPRING 157949699

//碧绿
#define COLOR_AQUAMARINE 171679899

//青
#define COLOR_CYAN 182829799

//天蓝
#define COLOR_SKY 191999999

//湖蓝
#define COLOR_LAKE 199679999

//蔚蓝
#define COLOR_AZURE 206629999

//蓝
#define COLOR_BLUE 212999999

//宝蓝
#define COLOR_ROYAL 225859099

//藏青
#define COLOR_NAVY 230955099

//深蓝
#define COLOR_DEEP 240995599

//海蓝
#define COLOR_SEA 246958099

//青蓝
#define COLOR_SLATEBLUE 254679399

//紫罗兰
#define COLOR_VIOLET 266879999

//紫
#define COLOR_PURPLE 278869799

//丁香紫
#define COLOR_LILAC 302859299

//玫红
#define COLOR_PLUM 319848999

//玫瑰
#define COLOR_ROSE 328929999

//血
#define COLOR_BLOOD 347918399

//赤
#define COLOR_CRIMSON 349849999

//粉
#define COLOR_PINK 351299999


//黑白灰和底色

//纯白
#define COLOR_WHITE 9999

//烟雾
#define COLOR_SMOKE 9699

//土灰
#define COLOR_DUST 8499

//银白
#define COLOR_SILVER 7599

//浅灰
#define COLOR_LIGHT 6299

//灰色
#define COLOR_GRAY 5099

//深灰
#define COLOR_DARK 3899

//黑夜
#define COLOR_NIGHT 1599

//黑暗
#define COLOR_DARKNESS 599

//黑
#define COLOR_BLACK 99

//雪白
#define COLOR_SNOW 29999

//幽灵
#define COLOR_GHOST 240039999

//背景
#define COLOR_BACKGROUND 240019899

//纸
#define COLOR_PAPER 48119899

//米色
#define COLOR_BEIGE 60109699

//线
#define COLOR_LINE 7599

//透明
#define COLOR_CLEAR 0


//阴影
#define COLOR_SHADOW_EX_LIGHT 8
#define COLOR_SHADOW_LIGHT 16
#define COLOR_SHADOW 38
#define COLOR_SHADOW_DARK 62
#define COLOR_SHADOW_EX_DARK 81



@interface KATColor : NSObject


#pragma -mark 类方法

///通过HSBA获取颜色(前2~3位为色相，取值范围为0~359度，之后2位为饱和度和明度，取值范围为0~99,最后2位为透明度，取值范围为0~99)
+ (UIColor *)colorWithHSBA:(int)HSBA;

///通过颜色获取HSBA值
+ (KATFloatArray *)HSBAValueFromColor:(UIColor *)color;

///通过颜色获取RGBA值
+ (KATFloatArray *)RGBAValueFromColor:(UIColor *)color;

///通过RGBA字符串获取颜色
+ (UIColor *)colorWithRGBA:(NSString *)RGBA;

///通过RGB字符串获取颜色
+ (UIColor *)colorWithRGB:(NSString *)RGB;

///获取颜色的RGB字符串
+ (NSString *)RGBWithColor:(UIColor *)color;

///获取颜色的RGBA字符串
+ (NSString *)RGBAWithColor:(UIColor *)color;

///获取颜色的HSBA数字
+ (int)HSBAWithColor:(UIColor *)color;

///获取HSBA颜色代码:调整调整颜色代码的色相、纯度、亮度和透明度(调整值为当前值+偏移量)(偏移量为0则不调整，偏移量为负数则向左调整)(H范围为0~359,其他属性范围为0~99)
+ (int)HSBAFromOriginalHSBA:(int)HSBA withAdjustedH:(int)H S:(int)S B:(int)B A:(int)A;

///获取颜色:调整颜色代码的色相、纯度、亮度和透明度(调整值为当前值+偏移量)(偏移量为0则不调整，偏移量为负数则向左调整)(H范围为0~359,其他属性范围为0~99)
+ (UIColor *)colorFromOriginalHSBA:(int)HSBA withAdjustedH:(int)H S:(int)S B:(int)B A:(int)A;

///获取颜色:调整原有颜色的色相、纯度、亮度和透明度(调整值为当前值+偏移量)(偏移量为0则不调整，偏移量为负数则向左调整)(H范围为0~359,其他属性范围为0~99)
+ (UIColor *)colorFromOriginalColor:(UIColor *)color withAdjustedH:(int)H S:(int)S B:(int)B A:(int)A;
                      
///改变颜色的透明度
+ (UIColor *)colorFromOldColor:(UIColor *)old withAlpha:(float)alpha;

///获取颜色的透明度
+ (CGFloat)alphaWithColor:(UIColor *)color;

///获取两个颜色的中间过渡色
+ (UIColor *)middleColorWithColorA:(UIColor *)ca andColorB:(UIColor *)cb;


@end
