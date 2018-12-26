//
//  KATImageUtil.h
//  KATFramework
//
//  Created by Kantice on 15/10/11.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//  图像工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KATAppUtil.h"
#import "KATImageFilter.h"


@interface KATImageUtil : NSObject


#pragma -mark 类方法

///UIView转化为图片
+ (UIImage *)imageFromView:(UIView *)view;

///CALayer转化为图片
+ (UIImage *)imageFromLayer:(CALayer *)layer;

///UIView转化为图片
+ (UIImage *)imageFromView:(UIView *)view withScale:(float)scale;

///CALayer转化为图片
+ (UIImage *)imageFromLayer:(CALayer *)layer  withScale:(float)scale;

///保存png图片到地址
+ (void)savePngImage:(UIImage *)image withPath:(NSString *)path;

///保存jpg图片到地址(质量为0~1)
+ (void)saveJpgImage:(UIImage *)image withPath:(NSString *)path andQuality:(float)quality;

///将图片缩放到指定的尺寸
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size andScale:(float)scale;

///将图片缩放到指定的尺寸
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size;

///将图片等比例缩放到指定的尺寸
+ (UIImage *)fitImage:(UIImage *)image withSize:(CGSize)size andScale:(float)scale;

///将图片等比例缩放到指定的尺寸
+ (UIImage *)fitImage:(UIImage *)image withSize:(CGSize)size;

///将图片等比例填充到指定的尺寸
+ (UIImage *)fillImage:(UIImage *)image withSize:(CGSize)size andScale:(float)scale;

///将图片等比例填充到指定的尺寸
+ (UIImage *)fillImage:(UIImage *)image withSize:(CGSize)size;

///截取图片
+ (UIImage *)clipImage:(UIImage *)image withFrame:(CGRect)frame;

///截取图片中间部分
+ (UIImage *)clipImage:(UIImage *)image withSize:(CGSize)size;

///保存图片到相册(无回调)
+ (void)saveToAlbumWithImage:(UIImage *)image;

///保存视频到相册(无回调)
+ (void)saveToAlbumWithVideo:(NSString *)videoPath;

///截屏
+ (UIImage *)screenshot;

///生成条形码
+ (UIImage *)generateBarcodeWithMessage:(NSString *)message andSize:(CGSize)size;

///生成条形码(默认尺寸)
+ (UIImage *)generateBarcodeWithMessage:(NSString *)message;

///生成二维码
+ (UIImage *)generateQRCodeWithMessage:(NSString *)message andSize:(CGSize)size;

///生成二维码(默认尺寸)
+ (UIImage *)generateQRCodeWithMessage:(NSString *)message;

///修复照片方向
+ (UIImage *)fixOrientationWithImage:(UIImage *)image;


@end


