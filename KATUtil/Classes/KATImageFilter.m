//
//  KATImageFilter.m
//  KATFramework
//
//  Created by Kantice on 15/12/23.
//  Copyright © 2015年 KatApp. All rights reserved.
//  图片滤镜

#import "KATImageFilter.h"

@implementation KATImageFilter


+ (instancetype)imageFilter
{
    KATImageFilter *imageFilter=[[[self alloc] init] autorelease];
    
    imageFilter.context=[CIContext contextWithOptions:nil];//GPU
    
    
    return imageFilter;
}



/**
 查看所有的滤镜
 */
+ (void)logAllFilters
{
    NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    
    NSLog(@"%@", properties);
    
    for(NSString *filterName in properties)
    {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}



/**
 从滤镜输出图片
 */
+ (UIImage *)imageFromContext:(CIContext *)context andFilter:(CIFilter *)filter
{
    if(!filter || !context)
    {
        return nil;
    }
    
    //输出CI图片
    CIImage *outputImage=[filter outputImage];
    
    //生成CG图片
    CGImageRef cgImage=[context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //返回的UI图片
    UIImage *newImage=[UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
//    UIImage *newImage=[UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    
    //释放CG图片
    CGImageRelease(cgImage);
    
    return newImage;
}


- (void)dealloc
{
    NSLog(@"KATImageFilter is dealloc!");
    
    
    [_filter release];
    [_image release];
    [_context release];
    
    
    [super dealloc];
}



#pragma -mark 模糊效果

/**
 快速均值模糊
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 版本:iOS 9.0
 */
- (UIImage *)blurBoxWithImage:(UIImage *)image andRadius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIBoxBlur"])
    {
        self.filter=[CIFilter filterWithName:@"CIBoxBlur"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 圆盘模糊
 
 参数为nil时使用配置的原图片
 默认半径:8.0
 版本:iOS 9.0
 */
- (UIImage *)blurDiscWithImage:(UIImage *)image andRadius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDiscBlur"])
    {
        self.filter=[CIFilter filterWithName:@"CIDiscBlur"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 高斯模糊
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 版本:iOS 6.0
 */
- (UIImage *)blurGaussianWithImage:(UIImage *)image andRadius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIGaussianBlur"])
    {
        self.filter=[CIFilter filterWithName:@"CIGaussianBlur"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}


/**
 中心过滤
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)blurMedianWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMedianFilter"])
    {
        self.filter=[CIFilter filterWithName:@"CIMedianFilter"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}


/**
 动感模糊
 
 参数为nil时使用配置的原图片
 默认半径:20.0
 默认角度:0.0
 版本:iOS 9.0
 */
- (UIImage *)blurMotionWithImage:(UIImage *)image radius:(float)radius andAngle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMotionBlur"])
    {
        self.filter=[CIFilter filterWithName:@"CIMotionBlur"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}


/**
 降噪
 
 参数为nil时使用配置的原图片
 默认等级:0.02
 默认锐度:0.4
 版本:iOS 9.0
 */
- (UIImage *)blurNoiseReductionWithImage:(UIImage *)image level:(float)level andSharpness:(float)sharpness
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CINoiseReduction"])
    {
        self.filter=[CIFilter filterWithName:@"CINoiseReduction"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(level) forKey:@"inputNoiseLevel"];
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 变焦模糊
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认数量:20.0
 版本:iOS 9.0
 */
- (UIImage *)blurZoomWithImage:(UIImage *)image center:(CGPoint)center andAmount:(float)amount
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIZoomBlur"])
    {
        self.filter=[CIFilter filterWithName:@"CIZoomBlur"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(amount) forKey:@"inputAmount"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




#pragma -mark 色彩调整

/**
 色彩容量
 
 参数为nil时使用配置的原图片
 默认最小RGBA构成:[0 0 0 0]
 默认最大RGBA构成:[1 1 1 1]
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustClampWithImage:(UIImage *)image minComponents:(CGRect)min maxComponents:(CGRect)max
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorClamp"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorClamp"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:min] forKey:@"inputMinComponents"];
    [_filter setValue:[CIVector vectorWithCGRect:max] forKey:@"inputMaxComponents"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}


/**
 色彩控制
 
 参数为nil时使用配置的原图片
 默认饱和度:1.0(有负值)
 默认亮度:0(有负值)
 默认对比度:1.0(有负值)
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustControlsWithImage:(UIImage *)image saturation:(float)s brightness:(float)b contrast:(float)c
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorControls"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorControls"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(s) forKey:@"inputSaturation"];
    [_filter setValue:@(b) forKey:@"inputBrightness"];
    [_filter setValue:@(c) forKey:@"inputContrast"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 色彩矩阵
 
 参数为nil时使用配置的原图片
 默认红色矩阵:[1 0 0 0]
 默认绿色矩阵:[0 1 0 0]
 默认蓝色矩阵:[0 0 1 0]
 默认透明矩阵:[0 0 0 1]
 默认偏移矩阵:[0 0 0 0]
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustMatrixWithImage:(UIImage *)image rVector:(CGRect)red gVector:(CGRect)green bVector:(CGRect)blue aVector:(CGRect)alpha andBiasVector:(CGRect)bias
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorMatrix"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorMatrix"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:red] forKey:@"inputRVector"];
    [_filter setValue:[CIVector vectorWithCGRect:green] forKey:@"inputGVector"];
    [_filter setValue:[CIVector vectorWithCGRect:blue] forKey:@"inputBVector"];
    [_filter setValue:[CIVector vectorWithCGRect:alpha] forKey:@"inputAVector"];
    [_filter setValue:[CIVector vectorWithCGRect:bias] forKey:@"inputBiasVector"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 色彩多项式
 
 参数为nil时使用配置的原图片
 默认红色系数:[0 1 0 0]
 默认绿色系数:[0 1 0 0]
 默认蓝色系数:[0 1 0 0]
 默认透明系数:[0 1 0 0]
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustPolynomialWithImage:(UIImage *)image rCoefficients:(CGRect)red gCoefficients:(CGRect)green bCoefficients:(CGRect)blue aCoefficients:(CGRect)alpha
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorPolynomial"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorPolynomial"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:red] forKey:@"inputRedCoefficients"];
    [_filter setValue:[CIVector vectorWithCGRect:green] forKey:@"inputGreenCoefficients"];
    [_filter setValue:[CIVector vectorWithCGRect:blue] forKey:@"inputBlueCoefficients"];
    [_filter setValue:[CIVector vectorWithCGRect:alpha] forKey:@"inputAlphaCoefficients"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 曝光调整
 
 参数为nil时使用配置的原图片
 默认曝光度:0.5
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustExposureWithImage:(UIImage *)image andEV:(float)ev
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIExposureAdjust"])
    {
        self.filter=[CIFilter filterWithName:@"CIExposureAdjust"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(ev) forKey:@"inputEV"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 灰度调整
 
 参数为nil时使用配置的原图片
 默认力量:0.8
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustGammaWithImage:(UIImage *)image andPower:(float)power
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIGammaAdjust"])
    {
        self.filter=[CIFilter filterWithName:@"CIGammaAdjust"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(power) forKey:@"inputPower"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 色调调整
 
 参数为nil时使用配置的原图片
 默认力量:0.0
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustHueWithImage:(UIImage *)image andAngle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHueAdjust"])
    {
        self.filter=[CIFilter filterWithName:@"CIHueAdjust"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 线性转化为sRGB色调曲线
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustLinearToSRGBToneCurveWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILinearToSRGBToneCurve"])
    {
        self.filter=[CIFilter filterWithName:@"CILinearToSRGBToneCurve"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}


/**
 sRGB色调曲线转化为线性
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustSRGBToneCurveToLinearWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISRGBToneCurveToLinear"])
    {
        self.filter=[CIFilter filterWithName:@"CISRGBToneCurveToLinear"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 色温调整
 
 参数为nil时使用配置的原图片
 默认原始中性色温:[6500 0]
 默认目标中性色温:[6500 0]
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustTemperatureWithImage:(UIImage *)image neutral:(CGPoint)neutral andTarget:(CGPoint)target
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CITemperatureAndTint"])
    {
        self.filter=[CIFilter filterWithName:@"CITemperatureAndTint"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:neutral] forKey:@"inputNeutral"];
    [_filter setValue:[CIVector vectorWithCGPoint:target] forKey:@"inputTargetNeutral"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 曲线调整
 
 参数为nil时使用配置的原图片
 默认曲线点0:[0.0,0.0]
 默认曲线点1:[0.25,0.25]
 默认曲线点2:[0.5,0.5]
 默认曲线点3:[0.75,0.75]
 默认曲线点4:[1.0,1.0]
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustToneCurveWithImage:(UIImage *)image point0:(CGPoint)p0 point1:(CGPoint)p1 point2:(CGPoint)p2 point3:(CGPoint)p3 point4:(CGPoint)p4
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIToneCurve"])
    {
        self.filter=[CIFilter filterWithName:@"CIToneCurve"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:p0] forKey:@"inputPoint0"];
    [_filter setValue:[CIVector vectorWithCGPoint:p1] forKey:@"inputPoint1"];
    [_filter setValue:[CIVector vectorWithCGPoint:p2] forKey:@"inputPoint2"];
    [_filter setValue:[CIVector vectorWithCGPoint:p3] forKey:@"inputPoint3"];
    [_filter setValue:[CIVector vectorWithCGPoint:p4] forKey:@"inputPoint4"];

    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 自然饱和度
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustVibranceWithImage:(UIImage *)image andAmount:(float)amount
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIVibrance"])
    {
        self.filter=[CIFilter filterWithName:@"CIVibrance"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(amount) forKey:@"inputAmount"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 白点调整
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustWhitePointWithImage:(UIImage *)image andColor:(UIColor *)color
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIWhitePointAdjust"])
    {
        self.filter=[CIFilter filterWithName:@"CIWhitePointAdjust"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




#pragma -mark 色彩效果



//CIColorCrossPolynomial
//交叉多项式


//CIColorCube
//RGB三维


//CIColorCubeWithColorSpace
//三维色彩空间


/**
 色彩倒置
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)colorEffectInvertWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorInvert"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorInvert"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




//CIColorMap
//色彩映射



/**
 单色
 
 参数为nil时使用配置的原图片
 默认强度:1.0
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMonochromeWithImage:(UIImage *)image color:(UIColor *)color andIntensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorMonochrome"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorMonochrome"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor"];
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 色调分离
 
 参数为nil时使用配置的原图片
 默认层级:6.0
 版本:iOS 6.0
 */
- (UIImage *)colorEffectPosterizeWithImage:(UIImage *)image andLevels:(float)levels
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorPosterize"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorPosterize"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(levels) forKey:@"inputLevels"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 伪色
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)colorEffectFalseWithImage:(UIImage *)image color1:(UIColor *)color1 color2:(UIColor *)color2
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIFalseColor"])
    {
        self.filter=[CIFilter filterWithName:@"CIFalseColor"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIColor colorWithCGColor:color1.CGColor] forKey:@"inputColor0"];
    [_filter setValue:[CIColor colorWithCGColor:color2.CGColor] forKey:@"inputColor1"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 透明蒙板
 
 参数为nil时使用配置的原图片
 白色为蒙板，黑色为透明
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMaskToAlphaWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMaskToAlpha"])
    {
        self.filter=[CIFilter filterWithName:@"CIMaskToAlpha"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 最大色彩容量
 
 参数为nil时使用配置的原图片
 返回灰阶图
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMaximumComponentWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMaximumComponent"])
    {
        self.filter=[CIFilter filterWithName:@"CIMaximumComponent"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 最小色彩容量
 
 参数为nil时使用配置的原图片
 返回灰阶图
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMinimumComponentWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMinimumComponent"])
    {
        self.filter=[CIFilter filterWithName:@"CIMMinimumComponent"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 棕色调
 
 参数为nil时使用配置的原图片
 默认强度:1.0
 版本:iOS 5.0
 */
- (UIImage *)colorEffectSepiaToneWithImage:(UIImage *)image andIntensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISepiaTone"])
    {
        self.filter=[CIFilter filterWithName:@"CISepiaTone"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 暗角
 
 参数为nil时使用配置的原图片
 默认半径:1.0
 默认强度:0.0
 版本:iOS 5.0
 */
- (UIImage *)colorEffectVignetteWithImage:(UIImage *)image radius:(float)radius andIntensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIVignette"])
    {
        self.filter=[CIFilter filterWithName:@"CIVignette"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 暗角
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:1.0
 默认强度:0.0
 版本:iOS 7.0
 */
- (UIImage *)colorEffectVignetteWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius andIntensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIVignetteEffect"])
    {
        self.filter=[CIFilter filterWithName:@"CIVignetteEffect"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



#pragma -mark 照片效果


/**
 铬色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectChromeWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectChrome"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectChrome"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 褪色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectFadeWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectFade"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectFade"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 印象
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectInstantWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectInstant"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectInstant"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 单色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectMonoWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectMono"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectMono"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 黑白
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectNoirWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectNoir"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectNoir"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 强调冷色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectProcessWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectProcess"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectProcess"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 黑白(不改变对比度)
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectTonalWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectTonal"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectTonal"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 强调暖色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectTransferWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPhotoEffectTransfer"])
    {
        self.filter=[CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




#pragma -mark 复合操作


/**
 添加组合亮色
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeAdditionWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAdditionCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CIAdditionCompositing"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 色彩混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeColorBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 加深混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeColorBurnBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorBurnBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorBurnBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 减淡混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeColorDodgeBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColorDodgeBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIColorDodgeBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 调暗混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeDarkenBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDarkenBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIDarkenBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 差异混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeDifferenceBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDifferenceBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIDifferenceBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 分割混合
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeDivideBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDivideBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIDivideBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 排除混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeExclusionBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIExclusionBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIExclusionBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 强光混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeHardLightBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHardLightBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIHardLightBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 色相混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeHueBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHueBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIHueBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 亮色混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeLightenBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILightenBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CILightenBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 线性加深
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeLinearBurnBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILinearBurnBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CILinearBurnBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 线性减淡
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeLinearDodgeBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILinearDodgeBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CILinearDodgeBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 亮度混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeLuminosityBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILuminosityBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CILuminosityBlendMode"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 最大混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMaximumWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMaximumCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CIMaximumCompositing"];
    }

    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 最小混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMinimumWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMinimumCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CIMinimumCompositing"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 乘法混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMultiplyBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMultiplyBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIMultiplyBlendMode"];
    }

    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 乘法合成
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMultiplyWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIMultiplyCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CIMultiplyCompositing"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 覆盖混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeOverlayBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIOverlayBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIOverlayBlendMode"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 点光混合
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositePinLightBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPinLightBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIPinLightBlendMode"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 饱和度混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSaturationBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISaturationBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CISaturationBlendMode"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 屏幕混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeScreenBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIScreenBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CIScreenBlendMode"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 柔光混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSoftLightBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISoftLightBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CISoftLightBlendMode"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 置顶组合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSourceAtopWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISourceAtopCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CISourceAtopCompositing"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 内置组合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSourceInWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISourceInCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CISourceInCompositing"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 外置组合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSourceOutWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISourceOutCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CISourceOutCompositing"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 上置组合
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)compositeSourceOverWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISourceOverCompositing"])
    {
        self.filter=[CIFilter filterWithName:@"CISourceOverCompositing"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 减法混合
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeSubtractBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISubtractBlendMode"])
    {
        self.filter=[CIFilter filterWithName:@"CISubtractBlendMode"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bgImage.CGImage] forKey:@"inputBackgroundImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




#pragma -mark 形变效果


/**
 凹凸形变
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:300.0
 默认比例:0.5
 版本:iOS 7.0
 */
- (UIImage *)distortionEffectBumpWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIBumpDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CIBumpDistortion"];
    }
    
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 环形飞闪形变
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:150.0
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectCircleSplashWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICircleSplashDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CICircleSplashDistortion"];
    }

    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 环绕形变
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:150.0
 默认角度:0.0
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectCircularWrapWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius angle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICircularWrap"])
    {
        self.filter=[CIFilter filterWithName:@"CICircularWrap"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 德罗斯特形变
 
 参数为nil时使用配置的原图片
 默认插入点0:[200 200]
 默认插入点1:[400 400]
 默认链:1
 默认周期:1
 默认旋转:0.0
 默认变焦:1
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectDrosteWithImage:(UIImage *)image point0:(CGPoint)p0 point1:(CGPoint)p1 strands:(int)strands periodicity:(int)periodicity rotation:(float)rotation zoom:(int)zoom
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDroste"])
    {
        self.filter=[CIFilter filterWithName:@"CIDroste"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:p0] forKey:@"inputInsetPoint0"];
    [_filter setValue:[CIVector vectorWithCGPoint:p1] forKey:@"inputInsetPoint1"];
    [_filter setValue:@(strands) forKey:@"inputStrands"];
    [_filter setValue:@(periodicity) forKey:@"inputPeriodicity"];
    [_filter setValue:@(rotation) forKey:@"inputRotation"];
    [_filter setValue:@(zoom) forKey:@"inputZoom"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 位移形变
 
 参数为nil时使用配置的原图片
 默认缩放比例:50.0
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectDisplacementWithImage:(UIImage *)image dImage:(UIImage *)dImage scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDisplacementDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CIDisplacementDistortion"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:dImage.CGImage] forKey:@"inputDisplacementImage"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 玻璃形变
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认缩放比例:200.0
 版本:iOS 8.0
 */
- (UIImage *)distortionEffectGlassWithImage:(UIImage *)image texture:(UIImage *)texture center:(CGPoint)center scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIGlassDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CIGlassDistortion"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:texture.CGImage] forKey:@"inputTexture"];
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 玻璃片
 
 参数为nil时使用配置的原图片
 默认插入点0:[150 150]
 默认插入点1:[350 150]
 默半径:100.0
 默认折射率:1.70
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectGlassLozengeWithImage:(UIImage *)image point0:(CGPoint)p0 point1:(CGPoint)p1 radius:(float)radius refraction:(float)refraction
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIGlassLozenge"])
    {
        self.filter=[CIFilter filterWithName:@"CIGlassLozenge"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:p0] forKey:@"inputPoint0"];
    [_filter setValue:[CIVector vectorWithCGPoint:p1] forKey:@"inputPoint1"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(refraction) forKey:@"inputRefraction"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 洞形变
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认半径:150.0
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectHoleWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHoleDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CIHoleDistortion"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 光隧道
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认旋转:0.0
 默认半径:0.0
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectLightTunnelWithImage:(UIImage *)image center:(CGPoint)center rotation:(float)rotation radius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILightTunnel"])
    {
        self.filter=[CIFilter filterWithName:@"CILightTunnel"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(rotation) forKey:@"inputRotation"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 挤压形变
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认半径:300.0
 默认缩放比例:0.5(小于2)
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectPinchWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPinchDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CIPinchDistortion"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 拉伸形变
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectStretchCropWithImage:(UIImage *)image size:(CGSize)size cropAmount:(float)crop stretchAmount:(float)stretch
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIStretchCrop"])
    {
        self.filter=[CIFilter filterWithName:@"CIStretchCrop"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:CGPointMake(size.width, size.height)] forKey:@"inputSize"];
    [_filter setValue:@(crop) forKey:@"inputCropAmount"];
    [_filter setValue:@(stretch) forKey:@"inputCenterStretchAmount"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 圆环镜头形变
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默半径:160.0
 默认宽度:80.0
 默认折射率:1.70
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectTorusLensWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius width:(float)width refraction:(float)refraction
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CITorusLensDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CITorusLensDistortion"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(refraction) forKey:@"inputRefraction"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 旋转扭曲形变
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默半径:300.0
 默认角度:3.14
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectTwirlWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius angle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CITwirlDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CITwirlDistortion"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 漩涡扭曲
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默半径:300.0
 默认角度:56.55
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectVortexWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius angle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIVortexDistortion"])
    {
        self.filter=[CIFilter filterWithName:@"CIVortexDistortion"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





#pragma -mark 生成器


/**
 Aztec二维码
 
 默认校准级别:23.0(范围5.0-95.0)
 默认层数:1.0(范围1.0-32.0)
 默认紧凑风格:否
 版本:iOS 8.0
 */
- (UIImage *)generateAztecCodeWithMessage:(NSString *)message correctionLevel:(float)level layers:(float)layers compactStyle:(BOOL)style
{
    //判断参数范围
    if(level<5.0)
    {
        level=5.0;
    }
    
    if(level>95.0)
    {
        level=95.0;
    }
    
    if(layers<1.0)
    {
        layers=1.0;
    }
    
    if(layers>32.0)
    {
        layers=32.0;
    }
    
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAztecCodeGenerator"])
    {
        self.filter=[CIFilter filterWithName:@"CIAztecCodeGenerator"];
    }
    
    //设置参数
    [_filter setValue:[message dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [_filter setValue:@(level) forKey:@"inputCorrectionLevel"];
    [_filter setValue:@(layers) forKey:@"inputLayers"];
    [_filter setValue:@(style) forKey:@"inputCompactStyle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 生成棋盘
 
 默认中心:[150 150]
 默认宽度:80.0
 默认锐度:1.0
 版本:iOS 6.0
 */
- (UIImage *)generateCheckerboardWithCenter:(CGPoint)center color0:(UIColor *)color0 color1:(UIColor *)color1 width:(float)width sharpness:(float)sharpness;
{
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICheckerboardGenerator"])
    {
        self.filter=[CIFilter filterWithName:@"CICheckerboardGenerator"];
    }
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:[CIColor colorWithCGColor:color0.CGColor] forKey:@"inputColor0"];
    [_filter setValue:[CIColor colorWithCGColor:color1.CGColor] forKey:@"inputColor1"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 生成128条形码
 
 默认空间:7.0(范围0.0-20.0)
 版本:iOS 8.0
 */
- (UIImage *)generate128BarcodeWithMessage:(NSString *)message andQuietSpace:(float)space
{
    //判断参数范围
    if(space<0.0)
    {
        space=0.0;
    }
    
    if(space>20.0)
    {
        space=20.0;
    }
    
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICode128BarcodeGenerator"])
    {
        self.filter=[CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    }
    
    //设置参数
    [_filter setValue:[message dataUsingEncoding:NSASCIIStringEncoding] forKey:@"inputMessage"];
    [_filter setValue:@(space) forKey:@"inputQuietSpace"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




//CILenticularHaloGenerator
//生成光晕




//CIPDF417BarcodeGenerator
//生成PDF417条形码




/**
 生成QR二维码
 
 版本:iOS 7.0
 */
- (UIImage *)generateQRCodeWithMessage:(NSString *)message
{
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIQRCodeGenerator"])
    {
        self.filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    }
    
    //设置参数
    [_filter setValue:[message dataUsingEncoding:NSISOLatin1StringEncoding] forKey:@"inputMessage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 生成随机色
 
 版本:iOS 6.0
 */
- (UIImage *)generateRandom
{
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIRandomGenerator"])
    {
        self.filter=[CIFilter filterWithName:@"CIRandomGenerator"];
    }
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





//CIStarShineGenerator
//生成星光




//CIStripesGenerator
//生成条纹



//CISunbeamsGenerator
//生成光束




#pragma -mark 几何调整



/**
 仿射变换
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)geometryAdjustAffineTransformWithImage:(UIImage *)image andTransform:(CGAffineTransform)transform;
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAffineTransform"])
    {
        self.filter=[CIFilter filterWithName:@"CIAffineTransform"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 裁剪
 
 参数为nil时使用配置的原图片
 默认区域:[0 0 300 300]
 版本:iOS 5.0
 */
- (UIImage *)geometryAdjustCropWithImage:(UIImage *)image andRect:(CGRect)rect
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICrop"])
    {
        self.filter=[CIFilter filterWithName:@"CICrop"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:rect] forKey:@"inputRectangle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 Lanczos缩放
 
 参数为nil时使用配置的原图片
 默认缩放比例:1.0
 默认宽高比:1.0
 版本:iOS 6.0
 */
- (UIImage *)geometryAdjustLanczosScaleWithImage:(UIImage *)image scale:(float)scale aspectRatio:(float)ratio
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILanczosScaleTransform"])
    {
        self.filter=[CIFilter filterWithName:@"CILanczosScaleTransform"];
    }
    
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(scale) forKey:@"inputScale"];
    [_filter setValue:@(ratio) forKey:@"inputAspectRatio"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 透视校正
 
 参数为nil时使用配置的原图片
 默认左上角:[118 484]
 默认右上角:[646 507]
 默认左下角:[155 153]
 默认右下角:[548 140]
 版本:iOS 8.0
 */
- (UIImage *)geometryAdjustPerspectiveCorrectionWithImage:(UIImage *)image topLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPerspectiveCorrection"])
    {
        self.filter=[CIFilter filterWithName:@"CIPerspectiveCorrection"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:tl] forKey:@"inputTopLeft"];
    [_filter setValue:[CIVector vectorWithCGPoint:tr] forKey:@"inputTopRight"];
    [_filter setValue:[CIVector vectorWithCGPoint:bl] forKey:@"inputBottomLeft"];
    [_filter setValue:[CIVector vectorWithCGPoint:br] forKey:@"inputBottomRight"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 透视变形
 
 参数为nil时使用配置的原图片
 默认左上角:[118 484]
 默认右上角:[646 507]
 默认左下角:[155 153]
 默认右下角:[548 140]
 版本:iOS 6.0
 */
- (UIImage *)geometryAdjustPerspectiveTransformWithImage:(UIImage *)image topLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPerspectiveTransform"])
    {
        self.filter=[CIFilter filterWithName:@"CIPerspectiveTransform"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:tl] forKey:@"inputTopLeft"];
    [_filter setValue:[CIVector vectorWithCGPoint:tr] forKey:@"inputTopRight"];
    [_filter setValue:[CIVector vectorWithCGPoint:bl] forKey:@"inputBottomLeft"];
    [_filter setValue:[CIVector vectorWithCGPoint:br] forKey:@"inputBottomRight"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 透视变形
 
 参数为nil时使用配置的原图片
 默认左上角:[118 484]
 默认右上角:[646 507]
 默认左下角:[155 153]
 默认右下角:[548 140]
 版本:iOS 6.0
 */
- (UIImage *)geometryAdjustPerspectiveTransformWithImage:(UIImage *)image extent:(CGRect)extent topLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPerspectiveTransformWithExtent"])
    {
        self.filter=[CIFilter filterWithName:@"CIPerspectiveTransformWithExtent"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    [_filter setValue:[CIVector vectorWithCGPoint:tl] forKey:@"inputTopLeft"];
    [_filter setValue:[CIVector vectorWithCGPoint:tr] forKey:@"inputTopRight"];
    [_filter setValue:[CIVector vectorWithCGPoint:bl] forKey:@"inputBottomLeft"];
    [_filter setValue:[CIVector vectorWithCGPoint:br] forKey:@"inputBottomRight"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 旋转裁剪
 
 参数为nil时使用配置的原图片
 默认角度:0.0
 版本:iOS 5.0
 */
- (UIImage *)geometryAdjustStraightenWithImage:(UIImage *)image andAngle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIStraightenFilter"])
    {
        self.filter=[CIFilter filterWithName:@"CIStraightenFilter"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}






#pragma -mark 渐变


/**
 高斯渐变
 
 默认中心:[150 150]
 默认半径:300.0
 版本:iOS 6.0
 */
- (UIImage *)gradientGaussianWithCenter:(CGPoint)center color0:(UIColor *)color0 color1:(UIColor *)color1 radius:(float)radius
{
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIGaussianGradient"])
    {
        self.filter=[CIFilter filterWithName:@"CIGaussianGradient"];
    }
    
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:[CIColor colorWithCGColor:color0.CGColor] forKey:@"inputColor0"];
    [_filter setValue:[CIColor colorWithCGColor:color1.CGColor] forKey:@"inputColor1"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 线性渐变
 
 默认点0:[0 0]
 默认点1:[200 200]
 版本:iOS 6.0
 */
- (UIImage *)gradientLinearWithPoint0:(CGPoint)point0 point1:(CGPoint)point1 color0:(UIColor *)color0 color1:(UIColor *)color1;
{
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILinearGradient"])
    {
        self.filter=[CIFilter filterWithName:@"CILinearGradient"];
    }
    
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:point0] forKey:@"inputPoint0"];
    [_filter setValue:[CIVector vectorWithCGPoint:point1] forKey:@"inputPoint1"];
    [_filter setValue:[CIColor colorWithCGColor:color0.CGColor] forKey:@"inputColor0"];
    [_filter setValue:[CIColor colorWithCGColor:color1.CGColor] forKey:@"inputColor1"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




//CIRadialGradient
//径向渐变




//CISmoothLinearGradient
//平滑界面



#pragma -mark 色调效果


/**
 圆形屏幕
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认宽度:6.0
 默认锐度:0.7
 版本:iOS 6.0
 */
- (UIImage *)halftoneEffectCircularScreenWithImage:(UIImage *)image center:(CGPoint)center width:(float)width sharpness:(float)sharpness
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICircularScreen"])
    {
        self.filter=[CIFilter filterWithName:@"CICircularScreen"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 圆点屏幕
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认角度:0.0
 默认宽度:6.0
 默认锐度:0.7
 版本:iOS 6.0
 */
- (UIImage *)halftoneEffectDotScreenWithImage:(UIImage *)image center:(CGPoint)center angle:(float)angle width:(float)width sharpness:(float)sharpness;
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIDotScreen"])
    {
        self.filter=[CIFilter filterWithName:@"CIDotScreen"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 影线屏幕
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认角度:0.0
 默认宽度:6.0
 默认锐度:0.7
 版本:iOS 6.0
 */
- (UIImage *)halftoneEffectHatchedScreenWithImage:(UIImage *)image center:(CGPoint)center angle:(float)angle width:(float)width sharpness:(float)sharpness
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHatchedScreen"])
    {
        self.filter=[CIFilter filterWithName:@"CIHatchedScreen"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 直线屏幕
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认角度:0.0
 默认宽度:6.0
 默认锐度:0.7
 版本:iOS 6.0
 */
- (UIImage *)halftoneEffectLineScreenWithImage:(UIImage *)image center:(CGPoint)center angle:(float)angle width:(float)width sharpness:(float)sharpness
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CILineScreen"])
    {
        self.filter=[CIFilter filterWithName:@"CILineScreen"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





#pragma -mark 减色



/**
 区域平均色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaAverageWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAreaAverage"])
    {
        self.filter=[CIFilter filterWithName:@"CIAreaAverage"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 区域直方图
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaHistogramWithImage:(UIImage *)image extent:(CGRect)extent count:(int)count scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAreaHistogram"])
    {
        self.filter=[CIFilter filterWithName:@"CIAreaHistogram"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    [_filter setValue:@(count) forKey:@"inputCount"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 行平均色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceRowAverageWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIRowAverage"])
    {
        self.filter=[CIFilter filterWithName:@"CIRowAverage"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 列平均色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceColumnAverageWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIColumnAverage"])
    {
        self.filter=[CIFilter filterWithName:@"CIColumnAverage"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 直方图展示
 
 参数为nil时使用配置的原图片
 默认高度:100.0
 默认上限:1.0
 默认下限:0.0
 版本:iOS 8.0
 */
- (UIImage *)reduceDisplayHistogramWithImage:(UIImage *)image height:(float)height highLimit:(float)high lowLimit:(float)low
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHistogramDisplayFilter"])
    {
        self.filter=[CIFilter filterWithName:@"CIHistogramDisplayFilter"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(height) forKey:@"inputHeight"];
    [_filter setValue:@(high) forKey:@"inputHighLimit"];
    [_filter setValue:@(low) forKey:@"inputLowLimit"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 区域最大色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMaximumWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAreaMaximum"])
    {
        self.filter=[CIFilter filterWithName:@"CIAreaMaximum"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 区域最小色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMinimumWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAreaMinimum"])
    {
        self.filter=[CIFilter filterWithName:@"CIAreaMinimum"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 区域最大透明度
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMaximumAlphaWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAreaMaximumAlpha"])
    {
        self.filter=[CIFilter filterWithName:@"CIAreaMaximumAlpha"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 区域最小透明度
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMinimumAlphaWithImage:(UIImage *)image andExtent:(CGRect)extent
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIAreaMinimumAlpha"])
    {
        self.filter=[CIFilter filterWithName:@"CIAreaMinimumAlpha"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGRect:extent] forKey:@"inputExtent"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}








#pragma -mark 锐化



/**
 高光锐化
 
 参数为nil时使用配置的原图片
 默认锐度:0.4
 版本:iOS 6.0
 */
- (UIImage *)sharpenLuminanceWithImage:(UIImage *)image andSharpness:(float)sharpness
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CISharpenLuminance"])
    {
        self.filter=[CIFilter filterWithName:@"CISharpenLuminance"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(sharpness) forKey:@"inputSharpness"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 USM锐化
 
 参数为nil时使用配置的原图片
 默认半径:2.5
 默认力度:0.5
 版本:iOS 6.0
 */
- (UIImage *)sharpenUnsharpMaskWithImage:(UIImage *)image radius:(float)radius intensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIUnsharpMask"])
    {
        self.filter=[CIFilter filterWithName:@"CIUnsharpMask"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




#pragma -mark 风格化



/**
 透明蒙板融合
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)stylizeAlphaMaskBlendWithImage:(UIImage *)image bgImage:(UIImage *)bg maskImage:(UIImage *)mask
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIBlendWithAlphaMask"])
    {
        self.filter=[CIFilter filterWithName:@"CIBlendWithAlphaMask"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bg.CGImage] forKey:@"inputBackgroundImage"];
    [_filter setValue:[CIImage imageWithCGImage:mask.CGImage] forKey:@"inputMaskImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 蒙板融合
 
 参数为nil时使用配置的原图片
 白色为不透明，黑色透明
 版本:iOS 6.0
 */
- (UIImage *)stylizeMaskBlendWithImage:(UIImage *)image bgImage:(UIImage *)bg maskImage:(UIImage *)mask
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIBlendWithMask"])
    {
        self.filter=[CIFilter filterWithName:@"CIBlendWithMask"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:bg.CGImage] forKey:@"inputBackgroundImage"];
    [_filter setValue:[CIImage imageWithCGImage:mask.CGImage] forKey:@"inputMaskImage"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 绽放
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 默认力度:1.0
 版本:iOS 6.0
 */
- (UIImage *)stylizeBloomWithImage:(UIImage *)image radius:(float)radius intensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIBloom"])
    {
        self.filter=[CIFilter filterWithName:@"CIBloom"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 漫画效果
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)stylizeComicWithImage:(UIImage *)image
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIComicEffect"])
    {
        self.filter=[CIFilter filterWithName:@"CIComicEffect"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





//CIConvolution3X3
//3X3卷积


//CIConvolution5X5
//5X5卷积


//CIConvolution7X7
//7X7卷积


//CIConvolution9Horizontal
//水平9卷积


//CIConvolution9Vertical
//垂直9卷积





/**
 水晶化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认半径:20.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeCrystallizeWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CICrystallize"])
    {
        self.filter=[CIFilter filterWithName:@"CICrystallize"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 描边
 
 参数为nil时使用配置的原图片
 默认力度:1.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeEdgesWithImage:(UIImage *)image andIntensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIEdges"])
    {
        self.filter=[CIFilter filterWithName:@"CIEdges"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 石化
 
 参数为nil时使用配置的原图片
 默认半径:3.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeEdgeWorkWithImage:(UIImage *)image andRadius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIEdgeWork"])
    {
        self.filter=[CIFilter filterWithName:@"CIEdgeWork"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 雾化
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 默认力度:1.0
 版本:iOS 6.0
 */
- (UIImage *)stylizeGloomWithImage:(UIImage *)image radius:(float)radius intensity:(float)intensity
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIGloom"])
    {
        self.filter=[CIFilter filterWithName:@"CIGloom"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    [_filter setValue:@(intensity) forKey:@"inputIntensity"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 立体化
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeHeightFieldFromMaskWithImage:(UIImage *)image andRadius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHeightFieldFromMask"])
    {
        self.filter=[CIFilter filterWithName:@"CIHeightFieldFromMask"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}





/**
 六边形像素化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认缩放比例:8.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeHexagonalPixellateWithImage:(UIImage *)image center:(CGPoint)center scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHexagonalPixellate"])
    {
        self.filter=[CIFilter filterWithName:@"CIHexagonalPixellate"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 高光阴影调整
 
 参数为nil时使用配置的原图片
 默认高光数:1.0
 版本:iOS 5.0
 */
- (UIImage *)stylizeHighlightShadowAdjustWithImage:(UIImage *)image highlightAmount:(float)light shadowAmount:(float)shadow
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIHighlightShadowAdjust"])
    {
        self.filter=[CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:@(light) forKey:@"inputHighlightAmount"];
    [_filter setValue:@(shadow) forKey:@"inputShadowAmount"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}






/**
 像素化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认缩放比例:8.0
 版本:iOS 6.0
 */
- (UIImage *)stylizePixellateWithImage:(UIImage *)image center:(CGPoint)center scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPixellate"])
    {
        self.filter=[CIFilter filterWithName:@"CIPixellate"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




/**
 点状化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认半径:20.0
 版本:iOS 9.0
 */
- (UIImage *)stylizePointillizeWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIPointillize"])
    {
        self.filter=[CIFilter filterWithName:@"CIPointillize"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(radius) forKey:@"inputRadius"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}



/**
 材质着色
 
 参数为nil时使用配置的原图片
 默认缩放比例:10.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeShadedMaterialWithImage:(UIImage *)image material:(UIImage *)material scale:(float)scale
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIShadedMaterial"])
    {
        self.filter=[CIFilter filterWithName:@"CIShadedMaterial"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIImage imageWithCGImage:material.CGImage] forKey:@"inputShadingImage"];
    [_filter setValue:@(scale) forKey:@"inputScale"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}






#pragma -mark 平铺





//CIAffineClamp
//仿射夹



//CIAffineTile
//仿射平铺



/**
 八重反射平铺
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认宽度:100.0
 默认角度:0.0
 版本:iOS 6.0
 */
- (UIImage *)tileEffectEightfoldReflectedWithImage:(UIImage *)image center:(CGPoint)center width:(float)width angle:(float)angle
{
    if(!image && !_image)
    {
        return nil;
    }
    
    //判断滤镜是否需要重新生成
    if(!_filter || ![_filter.name isEqualToString:@"CIEightfoldReflectedTile"])
    {
        self.filter=[CIFilter filterWithName:@"CIEightfoldReflectedTile"];
    }
    
    //生成CI图片(传入图片为空值时，使用配置的原图片)
    CIImage *cimage=!image?_image:[CIImage imageWithCGImage:image.CGImage];
    
    //设置图片
    [_filter setValue:cimage forKey:kCIInputImageKey];
    
    //设置参数
    [_filter setValue:[CIVector vectorWithCGPoint:center] forKey:@"inputCenter"];
    [_filter setValue:@(width) forKey:@"inputWidth"];
    [_filter setValue:@(angle) forKey:@"inputAngle"];
    
    
    return [KATImageFilter imageFromContext:_context andFilter:_filter];
}




//CIFourfoldReflectedTile
//四重反射平铺


//CIFourfoldRotatedTile
//四重旋转平铺


//CIFourfoldTranslatedTile
//四重变化平铺


//CIGlideReflectedTile
//平滑反射平铺


//CIKaleidoscope
//万花筒


//CIOpTile
//OP平铺


//CIParallelogramTile
//平行四边形平铺


//CIPerspectiveTile
//透视平铺


//CISixfoldReflectedTile
//六重反射平铺


//CISixfoldRotatedTile
//六重旋转平铺


//CITriangleKaleidoscope
//三角万花筒


//CITriangleTile
//三角平铺


//CITwelvefoldReflectedTile
//十二重反射平铺




#pragma -mark 过渡



//CIAccordionFoldTransition
//折叠过渡


//CIBarsSwipeTransition
//滑动条过渡


//CICopyMachineTransition
//复印机过渡


//CIDisintegrateWithMaskTransition
//蒙板溶解过渡


//CIDissolveTransition
//溶解过渡


//CIFlashTransition
//闪光过渡


//CIModTransition
//Mod过渡


//CIPageCurlTransition
//翻页过渡


//CIPageCurlWithShadowTransition
//带阴影的翻页过渡


//CIRippleTransition
//波纹过渡


//CISwipeTransition
//扫动过渡
















@end
