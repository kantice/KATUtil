//
//  KATStringUtil.h
//  KATFramework
//
//  Created by Kantice on 16/1/26.
//  Copyright © 2016年 KatApp. All rights reserved.
//  字符串工具


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface KATStringUtil : NSObject


#pragma mark - 类方法

///将html内容转化为富文本字符串
+ (NSAttributedString *)attrStringWithHtml:(NSString *)html;

///给url补充http://协议头
+ (NSString *)httpHeaderWithUrl:(NSString *)url;

///给url补充https://协议头
+ (NSString *)httpsHeaderWithUrl:(NSString *)url;

///字符串转URL
+ (NSURL *)urlWithString:(NSString *)string;

///URL转字符串
+ (NSString *)stringWithUrl:(NSURL *)url;

///转化为百分号编码（Get请求带中文字符串）
+ (NSString *)percentEncodingWithString:(NSString *)string;

///获取字体大小(通过给定的字体名(空为系统默认字体)、尺寸、最大字体、最小字体和留空)
+ (UIFont *)fontWithName:(NSString *)name size:(CGSize)size max:(float)max min:(float)min padding:(float)padding andText:(NSString *)text;

///获取字体大小(默认参数:系统字体、最大字体64、最小字体6、留空1)
+ (UIFont *)fontWithSize:(CGSize)size andText:(NSString *)text;


@end

