//
//  KATImageUtil.m
//  KATFramework
//
//  Created by Kantice on 15/10/11.
//  Copyright (c) 2015年 KatApp. All rights reserved.
//

#import "KATImageUtil.h"



@implementation KATImageUtil


//UIView转化为图片
+ (UIImage *)imageFromView:(UIView *)view
{
    return [self imageFromView:view withScale:0];
}


//UIView转化为图片
+ (UIImage *)imageFromView:(UIView *)view withScale:(float)scale
{
    if(!view)
    {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    
    return image;
}


//CALayer转化为图片
+ (UIImage *)imageFromLayer:(CALayer *)layer
{
    return [self imageFromLayer:layer withScale:0];
}


//CALayer转化为图片
+ (UIImage *)imageFromLayer:(CALayer *)layer withScale:(float)scale
{
    if(!layer)
    {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, scale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    
    return image;
}


//保存图片到地址
+ (void)savePngImage:(UIImage *)image withPath:(NSString *)path
{
    if(image && path)
    {
        //保存图片
        NSData *data=UIImagePNGRepresentation(image);
        
        [data writeToFile:path atomically:YES];
    }
}


//保存jpg图片到地址
+ (void)saveJpgImage:(UIImage *)image withPath:(NSString *)path andQuality:(float)quality
{
    if(image && path)
    {
        //保存图片
        NSData *data=UIImageJPEGRepresentation(image, quality);
        
        [data writeToFile:path atomically:YES];
    }
}


//将图片缩放到指定的尺寸
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size andScale:(float)scale
{
    if(!image)
    {
        return nil;
    }
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


//将图片缩放到指定的尺寸
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    return [self scaleImage:image withSize:size andScale:0];
}


//将图片等比例缩放到指定的尺寸
+ (UIImage *)fitImage:(UIImage *)image withSize:(CGSize)size andScale:(float)scale
{
    if(!image || size.height<=0 || size.width<=0)
    {
        return nil;
    }
    
    //获取图片的高和宽
    float height=image.size.height;
    float width=image.size.width;
    float rate=height/width;//高宽比
    CGSize fitSize;//修正后的尺寸
    
    //以小的为基准
    if(size.height/rate<=size.width)//以高为基准
    {
        fitSize=CGSizeMake(size.height/rate, size.height);
    }
    else//以宽为基准
    {
        fitSize=CGSizeMake(size.width, size.width*rate);
    }
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(fitSize, NO, scale);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, fitSize.width, fitSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


//将图片等比例缩放到指定的尺寸
+ (UIImage *)fitImage:(UIImage *)image withSize:(CGSize)size
{
    return [self fitImage:image withSize:size andScale:0];
}


//将图片等比例填充到指定的尺寸
+ (UIImage *)fillImage:(UIImage *)image withSize:(CGSize)size andScale:(float)scale
{
    if(!image || size.height<=0 || size.width<=0)
    {
        return nil;
    }
    
    //获取图片的高和宽
    float height=image.size.height;
    float width=image.size.width;
    float rate=height/width;//高宽比
    CGSize fillSize;//修正后的尺寸
    
    //以大的为基准
    if(size.height/rate>=size.width)//以高为基准
    {
        fillSize=CGSizeMake(size.height/rate, size.height);
    }
    else//以宽为基准
    {
        fillSize=CGSizeMake(size.width, size.width*rate);
    }
        
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(fillSize, NO, scale);
        
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, fillSize.width, fillSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;

}


//将图片等比例填充到指定的尺寸
+ (UIImage *)fillImage:(UIImage *)image withSize:(CGSize)size
{
    return [self fillImage:image withSize:size andScale:0];
}


//截取图片
+ (UIImage *)clipImage:(UIImage *)image withFrame:(CGRect)frame
{
    if(!image)
    {
        return nil;
    }
    
    UIImageView *iv=[[[UIImageView alloc] init] autorelease];
    iv.frame=CGRectMake(-frame.origin.x, -frame.origin.y, image.size.width, image.size.height);
    iv.contentMode=UIViewContentModeScaleAspectFit;
    iv.image=image;
    
    UIView *view=[[[UIView alloc] init] autorelease];
    view.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    view.clipsToBounds=YES;
    
    [view addSubview:iv];
    
    return [self imageFromView:view];
}


//截取图片中间部分
+ (UIImage *)clipImage:(UIImage *)image withSize:(CGSize)size
{
    if(!image)
    {
        return nil;
    }
    
    UIImageView *iv=[[[UIImageView alloc] init] autorelease];
    iv.frame=CGRectMake((size.width-image.size.width)/2.0, (size.height-image.size.height)/2.0, image.size.width, image.size.height);
    iv.contentMode=UIViewContentModeScaleAspectFit;
    iv.image=image;
    
    UIView *view=[[[UIView alloc] init] autorelease];
    view.frame=CGRectMake(0, 0, size.width, size.height);
    view.clipsToBounds=YES;
    
    [view addSubview:iv];
    
    return [self imageFromView:view];
}


//保存图片到相册
+ (void)saveToAlbumWithImage:(UIImage *)image
{
    if(image)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }
}


//保存视频到相册
+ (void)saveToAlbumWithVideo:(NSString *)videoPath
{
    if(videoPath && UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath))//判断是否为所拍摄的视频
    {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);//保存视频到相簿
    }
}


//截屏
+ (UIImage *)screenshot
{
    return [self imageFromView:[KATAppUtil keyWindow]];
}


//生成条形码
+ (UIImage *)generateBarcodeWithMessage:(NSString *)message andSize:(CGSize)size
{
    if(message)
    {
        UIImageView *image=[[[UIImageView alloc] init] autorelease];
        image.frame=CGRectMake(0, 0, size.width, size.height);
        image.contentMode=UIViewContentModeScaleAspectFit;
        
        image.image=[[KATImageFilter imageFilter] generate128BarcodeWithMessage:message andQuietSpace:1.0];
        image.layer.magnificationFilter=kCAFilterNearest;//最近像素拉伸
        
        return [self imageFromView:image];
    }
    else
    {
        return nil;
    }
    
}


//生成条形码(默认尺寸)
+ (UIImage *)generateBarcodeWithMessage:(NSString *)message
{
    return [[KATImageFilter imageFilter] generate128BarcodeWithMessage:message andQuietSpace:1.0];
}


//生成二维码
+ (UIImage *)generateQRCodeWithMessage:(NSString *)message andSize:(CGSize)size
{
    if(message)
    {
        UIImageView *image=[[[UIImageView alloc] init] autorelease];
        image.frame=CGRectMake(0, 0, size.width, size.height);
        image.contentMode=UIViewContentModeScaleAspectFit;
        
        image.image=[[KATImageFilter imageFilter] generateQRCodeWithMessage:message];
        image.layer.magnificationFilter=kCAFilterNearest;//最近像素拉伸
        
        return [self imageFromView:image];
    }
    else
    {
        return nil;
    }
}


//生成二维码(默认尺寸)
+ (UIImage *)generateQRCodeWithMessage:(NSString *)message
{
    return [[KATImageFilter imageFilter] generateQRCodeWithMessage:message];
}


//修复照片方向
+ (UIImage *)fixOrientationWithImage:(UIImage *)image
{
    if(!image)
    {
        return nil;
    }
    
    //无需修复
    if(image.imageOrientation==UIImageOrientationUp)
    {
        return image;
    }
    
    //变换
    CGAffineTransform transform=CGAffineTransformIdentity;
    
    //根据方向变换
    switch(image.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            
            transform=CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform=CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            
            transform=CGAffineTransformTranslate(transform, image.size.width, 0);
            transform=CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            transform=CGAffineTransformTranslate(transform, 0, image.size.height);
            transform=CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
            
        default:
            break;
    }
    
    //镜像图片再变换
    switch(image.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            
            transform=CGAffineTransformTranslate(transform, image.size.width, 0);
            transform=CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
        default:
            
            break;
    }
    
    //图片上下文
    CGContextRef ctx=CGBitmapContextCreate(NULL,image.size.width, image.size.height,CGImageGetBitsPerComponent(image.CGImage), 0,CGImageGetColorSpace(image.CGImage),CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch(image.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            
            break;
            
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            
            break;
    }
    
    //输出变换后的图片
    CGImageRef cgimg=CGBitmapContextCreateImage(ctx);
    UIImage *img=[UIImage imageWithCGImage:cgimg];
    
    //释放内存
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    
    return img;
}



@end
