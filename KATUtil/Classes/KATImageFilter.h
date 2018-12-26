//
//  KATImageFilter.h
//  KATFramework
//
//  Created by Kantice on 15/12/23.
//  Copyright © 2015年 KatApp. All rights reserved.
//  图像滤镜

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>



@interface KATImageFilter : NSObject


#pragma -mark 属性

///上下文
@property(nonatomic,retain) CIContext *context;

///滤镜
@property(nonatomic,retain) CIFilter *filter;

///原图片
@property(nonatomic,retain) CIImage *image;


//滤镜参数范围


///获取实例
+ (instancetype)imageFilter;

///释放内存
- (void)dealloc;

/**
 查看所有的滤镜
 */
+ (void)logAllFilters;

/**
 从滤镜输出图片
 */
+ (UIImage *)imageFromContext:(CIContext *)context andFilter:(CIFilter *)filter;


#pragma -mark 模糊效果

/**
 快速均值模糊
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 版本:iOS 9.0
 */
- (UIImage *)blurBoxWithImage:(UIImage *)image andRadius:(float)radius;

/**
 圆盘模糊
 
 参数为nil时使用配置的原图片
 默认半径:8.0
 版本:iOS 9.0
 */
- (UIImage *)blurDiscWithImage:(UIImage *)image andRadius:(float)radius;

/**
 高斯模糊
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 版本:iOS 6.0
 */
- (UIImage *)blurGaussianWithImage:(UIImage *)image andRadius:(float)radius;

/**
 中心过滤
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)blurMedianWithImage:(UIImage *)image;

/**
 动感模糊
 
 参数为nil时使用配置的原图片
 默认半径:20.0
 默认角度:0.0
 版本:iOS 9.0
 */
- (UIImage *)blurMotionWithImage:(UIImage *)image radius:(float)radius andAngle:(float)angle;

/**
 降噪
 
 参数为nil时使用配置的原图片
 默认等级:0.02
 默认锐度:0.4
 版本:iOS 9.0
 */
- (UIImage *)blurNoiseReductionWithImage:(UIImage *)image level:(float)level andSharpness:(float)sharpness;

/**
 变焦模糊
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认数量:20.0
 版本:iOS 9.0
 */
- (UIImage *)blurZoomWithImage:(UIImage *)image center:(CGPoint)center andAmount:(float)amount;


#pragma -mark 色彩调整

/**
 色彩容量
 
 参数为nil时使用配置的原图片
 默认最小RGBA构成:[0 0 0 0]
 默认最大RGBA构成:[1 1 1 1]
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustClampWithImage:(UIImage *)image minComponents:(CGRect)min maxComponents:(CGRect)max;

/**
 色彩控制
 
 参数为nil时使用配置的原图片
 默认饱和度:1.0(有负值)
 默认亮度:0(有负值)
 默认对比度:1.0(有负值)
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustControlsWithImage:(UIImage *)image saturation:(float)s brightness:(float)b contrast:(float)c;

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
- (UIImage *)colorAdjustMatrixWithImage:(UIImage *)image rVector:(CGRect)red gVector:(CGRect)green bVector:(CGRect)blue aVector:(CGRect)alpha andBiasVector:(CGRect)bias;

/**
 色彩多项式
 
 参数为nil时使用配置的原图片
 默认红色系数:[0 1 0 0]
 默认绿色系数:[0 1 0 0]
 默认蓝色系数:[0 1 0 0]
 默认透明系数:[0 1 0 0]
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustPolynomialWithImage:(UIImage *)image rCoefficients:(CGRect)red gCoefficients:(CGRect)green bCoefficients:(CGRect)blue aCoefficients:(CGRect)alpha;

/**
 曝光调整
 
 参数为nil时使用配置的原图片
 默认曝光度:0.5
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustExposureWithImage:(UIImage *)image andEV:(float)ev;

/**
 灰度调整
 
 参数为nil时使用配置的原图片
 默认力量:0.8
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustGammaWithImage:(UIImage *)image andPower:(float)power;

/**
 色调调整
 
 参数为nil时使用配置的原图片
 默认角度:0.0(2*M_PI)
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustHueWithImage:(UIImage *)image andAngle:(float)angle;

/**
 线性转化为sRGB色调曲线
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustLinearToSRGBToneCurveWithImage:(UIImage *)image;

/**
 sRGB色调曲线转化为线性
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)colorAdjustSRGBToneCurveToLinearWithImage:(UIImage *)image;

/**
 色温调整
 
 参数为nil时使用配置的原图片
 默认原始中性色温:[6500 0]
 默认目标中性色温:[6500 0]
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustTemperatureWithImage:(UIImage *)image neutral:(CGPoint)neutral andTarget:(CGPoint)target;

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
- (UIImage *)colorAdjustToneCurveWithImage:(UIImage *)image point0:(CGPoint)p0 point1:(CGPoint)p1 point2:(CGPoint)p2 point3:(CGPoint)p3 point4:(CGPoint)p4;

/**
 自然饱和度
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustVibranceWithImage:(UIImage *)image andAmount:(float)amount;

/**
 白点调整
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)colorAdjustWhitePointWithImage:(UIImage *)image andColor:(UIColor *)color;


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
- (UIImage *)colorEffectInvertWithImage:(UIImage *)image;

//CIColorMap
//色彩映射

/**
 单色
 
 参数为nil时使用配置的原图片
 默认强度:1.0
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMonochromeWithImage:(UIImage *)image color:(UIColor *)color andIntensity:(float)intensity;

/**
 色调分离
 
 参数为nil时使用配置的原图片
 默认层级:6.0
 版本:iOS 6.0
 */
- (UIImage *)colorEffectPosterizeWithImage:(UIImage *)image andLevels:(float)levels;

/**
 伪色
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)colorEffectFalseWithImage:(UIImage *)image color1:(UIColor *)color1 color2:(UIColor *)color2;

/**
 透明蒙板
 
 参数为nil时使用配置的原图片
 白色为蒙板，黑色为透明
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMaskToAlphaWithImage:(UIImage *)image;

/**
 最大色彩容量
 
 参数为nil时使用配置的原图片
 返回灰阶图
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMaximumComponentWithImage:(UIImage *)image;

/**
 最小色彩容量
 
 参数为nil时使用配置的原图片
 返回灰阶图
 版本:iOS 6.0
 */
- (UIImage *)colorEffectMinimumComponentWithImage:(UIImage *)image;

/**
 棕色调
 
 参数为nil时使用配置的原图片
 默认强度:1.0
 版本:iOS 5.0
 */
- (UIImage *)colorEffectSepiaToneWithImage:(UIImage *)image andIntensity:(float)intensity;

/**
 暗角
 
 参数为nil时使用配置的原图片
 默认半径:1.0
 默认强度:0.0
 版本:iOS 5.0
 */
- (UIImage *)colorEffectVignetteWithImage:(UIImage *)image radius:(float)radius andIntensity:(float)intensity;

/**
 暗角
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:1.0
 默认强度:0.0
 版本:iOS 7.0
 */
- (UIImage *)colorEffectVignetteWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius andIntensity:(float)intensity;


#pragma -mark 照片效果

/**
 铬色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectChromeWithImage:(UIImage *)image;

/**
 褪色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectFadeWithImage:(UIImage *)image;

/**
 印象
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectInstantWithImage:(UIImage *)image;

/**
 单色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectMonoWithImage:(UIImage *)image;

/**
 黑白
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectNoirWithImage:(UIImage *)image;

/**
 强调冷色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectProcessWithImage:(UIImage *)image;

/**
 黑白(不改变对比度)
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectTonalWithImage:(UIImage *)image;

/**
 强调暖色
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)photoEffectTransferWithImage:(UIImage *)image;


#pragma -mark 复合操作

/**
 添加组合亮色
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeAdditionWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 色彩混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeColorBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 加深混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeColorBurnBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 减淡混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeColorDodgeBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 调暗混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeDarkenBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 差异混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeDifferenceBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 分割混合
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeDivideBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 排除混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeExclusionBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 强光混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeHardLightBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 色相混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeHueBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 亮色混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeLightenBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 线性加深
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeLinearBurnBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 线性减淡
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeLinearDodgeBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 亮度混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeLuminosityBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 最大混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMaximumWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 最小混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMinimumWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 乘法混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMultiplyBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 乘法合成
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeMultiplyWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 覆盖混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeOverlayBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 点光混合
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositePinLightBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 饱和度混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSaturationBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 屏幕混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeScreenBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 柔光混合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSoftLightBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 置顶组合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSourceAtopWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 内置组合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSourceInWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 外置组合
 
 参数为nil时使用配置的原图片
 版本:iOS 6.0
 */
- (UIImage *)compositeSourceOutWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 上置组合
 
 参数为nil时使用配置的原图片
 版本:iOS 5.0
 */
- (UIImage *)compositeSourceOverWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;

/**
 减法混合
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)compositeSubtractBlendWithImage:(UIImage *)image andBgImage:(UIImage *)bgImage;


#pragma -mark 形变效果

/**
 凹凸形变
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:300.0
 默认比例:0.5
 版本:iOS 7.0
 */
- (UIImage *)distortionEffectBumpWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius scale:(float)scale;

/**
 环形飞闪形变
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:150.0
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectCircleSplashWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius;

/**
 环绕形变
 
 参数为nil时使用配置的原图片
 默认圆心:[150 150]
 默认半径:150.0
 默认角度:0.0
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectCircularWrapWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius angle:(float)angle;

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
- (UIImage *)distortionEffectDrosteWithImage:(UIImage *)image point0:(CGPoint)p0 point1:(CGPoint)p1 strands:(int)strands periodicity:(int)periodicity rotation:(float)rotation zoom:(int)zoom;

/**
 位移形变
 
 参数为nil时使用配置的原图片
 默认缩放比例:50.0
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectDisplacementWithImage:(UIImage *)image dImage:(UIImage *)dImage scale:(float)scale;

/**
 玻璃形变
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认缩放比例:200.0
 版本:iOS 8.0
 */
- (UIImage *)distortionEffectGlassWithImage:(UIImage *)image texture:(UIImage *)texture center:(CGPoint)center scale:(float)scale;

/**
 玻璃片
 
 参数为nil时使用配置的原图片
 默认插入点0:[150 150]
 默认插入点1:[350 150]
 默半径:100.0
 默认折射率:1.70
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectGlassLozengeWithImage:(UIImage *)image point0:(CGPoint)p0 point1:(CGPoint)p1 radius:(float)radius refraction:(float)refraction;

/**
 洞形变
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认半径:150.0
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectHoleWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius;

/**
 光隧道
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认旋转:0.0
 默认半径:0.0
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectLightTunnelWithImage:(UIImage *)image center:(CGPoint)center rotation:(float)rotation radius:(float)radius;

/**
 挤压形变
 
 参数为nil时使用配置的原图片
 默认中点:[150 150]
 默认半径:300.0
 默认缩放比例:0.5(小于2)
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectPinchWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius scale:(float)scale;

/**
 拉伸形变
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectStretchCropWithImage:(UIImage *)image size:(CGSize)size cropAmount:(float)crop stretchAmount:(float)stretch;

/**
 圆环镜头形变
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默半径:160.0
 默认宽度:80.0
 默认折射率:1.70
 版本:iOS 9.0
 */
- (UIImage *)distortionEffectTorusLensWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius width:(float)width refraction:(float)refraction;

/**
 旋转扭曲
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默半径:300.0
 默认角度:3.14
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectTwirlWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius angle:(float)angle;

/**
 漩涡扭曲
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认半径:300.0
 默认角度:56.55
 版本:iOS 6.0
 */
- (UIImage *)distortionEffectVortexWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius angle:(float)angle;


#pragma -mark 生成器

/**
 生成Aztec二维码
 
 默认校准级别:23.0(范围5.0-95.0)
 默认层数:1.0(范围1.0-32.0)
 默认紧凑风格:否
 版本:iOS 8.0
 */
- (UIImage *)generateAztecCodeWithMessage:(NSString *)message correctionLevel:(float)level layers:(float)layers compactStyle:(BOOL)style;

/**
 生成棋盘
 
 默认中心:[150 150]
 默认宽度:80.0
 默认锐度:1.0
 版本:iOS 6.0
 */
- (UIImage *)generateCheckerboardWithCenter:(CGPoint)center color0:(UIColor *)color0 color1:(UIColor *)color1 width:(float)width sharpness:(float)sharpness;

/**
 生成128条形码
 
 默认空间:7.0(范围0.0-20.0)
 版本:iOS 8.0
 */
- (UIImage *)generate128BarcodeWithMessage:(NSString *)message andQuietSpace:(float)space;


//CILenticularHaloGenerator
//生成光晕


//CIPDF417BarcodeGenerator
//生成PDF417条形码


/**
 生成QR二维码

 版本:iOS 7.0
 */
- (UIImage *)generateQRCodeWithMessage:(NSString *)message;

/**
 生成随机色
 
 版本:iOS 6.0
 */
- (UIImage *)generateRandom;


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

/**
 裁剪
 
 参数为nil时使用配置的原图片
 默认区域:[0 0 300 300]
 版本:iOS 5.0
 */
- (UIImage *)geometryAdjustCropWithImage:(UIImage *)image andRect:(CGRect)rect;

/**
 Lanczos缩放
 
 参数为nil时使用配置的原图片
 默认缩放比例:1.0
 默认宽高比:1.0
 版本:iOS 6.0
 */
- (UIImage *)geometryAdjustLanczosScaleWithImage:(UIImage *)image scale:(float)scale aspectRatio:(float)ratio;

/**
 透视校正
 
 参数为nil时使用配置的原图片
 默认左上角:[118 484]
 默认右上角:[646 507]
 默认左下角:[155 153]
 默认右下角:[548 140]
 版本:iOS 8.0
 */
- (UIImage *)geometryAdjustPerspectiveCorrectionWithImage:(UIImage *)image topLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

/**
 透视变形
 
 参数为nil时使用配置的原图片
 默认左上角:[118 484]
 默认右上角:[646 507]
 默认左下角:[155 153]
 默认右下角:[548 140]
 版本:iOS 6.0
 */
- (UIImage *)geometryAdjustPerspectiveTransformWithImage:(UIImage *)image topLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

/**
 透视变形
 
 参数为nil时使用配置的原图片
 默认左上角:[118 484]
 默认右上角:[646 507]
 默认左下角:[155 153]
 默认右下角:[548 140]
 版本:iOS 6.0
 */
- (UIImage *)geometryAdjustPerspectiveTransformWithImage:(UIImage *)image extent:(CGRect)extent topLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

/**
 旋转裁剪
 
 参数为nil时使用配置的原图片
 默认角度:0.0
 版本:iOS 5.0
 */
- (UIImage *)geometryAdjustStraightenWithImage:(UIImage *)image andAngle:(float)angle;


#pragma -mark 渐变

/**
 高斯渐变
 
 默认中心:[150 150]
 默认半径:300.0
 版本:iOS 6.0
 */
- (UIImage *)gradientGaussianWithCenter:(CGPoint)center color0:(UIColor *)color0 color1:(UIColor *)color1 radius:(float)radius;

/**
 线性渐变
 
 默认点0:[0 0]
 默认点1:[200 200]
 版本:iOS 6.0
 */
- (UIImage *)gradientLinearWithPoint0:(CGPoint)point0 point1:(CGPoint)point1 color0:(UIColor *)color0 color1:(UIColor *)color1;

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
- (UIImage *)halftoneEffectCircularScreenWithImage:(UIImage *)image center:(CGPoint)center width:(float)width sharpness:(float)sharpness;


//CICMYKHalftone
//CMYK色调


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

/**
 影线屏幕
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认角度:0.0
 默认宽度:6.0
 默认锐度:0.7
 版本:iOS 6.0
 */
- (UIImage *)halftoneEffectHatchedScreenWithImage:(UIImage *)image center:(CGPoint)center angle:(float)angle width:(float)width sharpness:(float)sharpness;

/**
 直线屏幕
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认角度:0.0
 默认宽度:6.0
 默认锐度:0.7
 版本:iOS 6.0
 */
- (UIImage *)halftoneEffectLineScreenWithImage:(UIImage *)image center:(CGPoint)center angle:(float)angle width:(float)width sharpness:(float)sharpness;


#pragma -mark 减色

/**
 区域平均色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaAverageWithImage:(UIImage *)image andExtent:(CGRect)extent;

/**
 区域直方图
 
 参数为nil时使用配置的原图片
 版本:iOS 8.0
 */
- (UIImage *)reduceAreaHistogramWithImage:(UIImage *)image extent:(CGRect)extent count:(int)count scale:(float)scale;

/**
 行平均色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceRowAverageWithImage:(UIImage *)image andExtent:(CGRect)extent;

/**
 列平均色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceColumnAverageWithImage:(UIImage *)image andExtent:(CGRect)extent;

/**
 直方图展示
 
 参数为nil时使用配置的原图片
 默认高度:100.0
 默认上限:1.0
 默认下限:0.0
 版本:iOS 8.0
 */
- (UIImage *)reduceDisplayHistogramWithImage:(UIImage *)image height:(float)height highLimit:(float)high lowLimit:(float)low;

/**
 区域最大色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMaximumWithImage:(UIImage *)image andExtent:(CGRect)extent;

/**
 区域最小色
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMinimumWithImage:(UIImage *)image andExtent:(CGRect)extent;

/**
 区域最大透明度
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMaximumAlphaWithImage:(UIImage *)image andExtent:(CGRect)extent;

/**
 区域最小透明度
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)reduceAreaMinimumAlphaWithImage:(UIImage *)image andExtent:(CGRect)extent;


#pragma -mark 锐化

/**
 高光锐化
 
 参数为nil时使用配置的原图片
 默认锐度:0.4
 版本:iOS 6.0
 */
- (UIImage *)sharpenLuminanceWithImage:(UIImage *)image andSharpness:(float)sharpness;

/**
 USM锐化
 
 参数为nil时使用配置的原图片
 默认半径:2.5
 默认力度:0.5
 版本:iOS 6.0
 */
- (UIImage *)sharpenUnsharpMaskWithImage:(UIImage *)image radius:(float)radius intensity:(float)intensity;


#pragma -mark 风格化

/**
 透明蒙板融合
 
 参数为nil时使用配置的原图片
 版本:iOS 7.0
 */
- (UIImage *)stylizeAlphaMaskBlendWithImage:(UIImage *)image bgImage:(UIImage *)bg maskImage:(UIImage *)mask;

/**
 蒙板融合
 
 参数为nil时使用配置的原图片
 白色为不透明，黑色透明
 版本:iOS 6.0
 */
- (UIImage *)stylizeMaskBlendWithImage:(UIImage *)image bgImage:(UIImage *)bg maskImage:(UIImage *)mask;

/**
 绽放
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 默认力度:1.0
 版本:iOS 6.0
 */
- (UIImage *)stylizeBloomWithImage:(UIImage *)image radius:(float)radius intensity:(float)intensity;

/**
 漫画效果
 
 参数为nil时使用配置的原图片
 版本:iOS 9.0
 */
- (UIImage *)stylizeComicWithImage:(UIImage *)image;

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
- (UIImage *)stylizeCrystallizeWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius;


//CIDepthOfField
//景深


/**
 描边
 
 参数为nil时使用配置的原图片
 默认力度:1.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeEdgesWithImage:(UIImage *)image andIntensity:(float)intensity;

/**
 石化
 
 参数为nil时使用配置的原图片
 默认半径:3.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeEdgeWorkWithImage:(UIImage *)image andRadius:(float)radius;

/**
 雾化
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 默认力度:1.0
 版本:iOS 6.0
 */
- (UIImage *)stylizeGloomWithImage:(UIImage *)image radius:(float)radius intensity:(float)intensity;

/**
 立体化
 
 参数为nil时使用配置的原图片
 默认半径:10.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeHeightFieldFromMaskWithImage:(UIImage *)image andRadius:(float)radius;

/**
 六边形像素化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认缩放比例:8.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeHexagonalPixellateWithImage:(UIImage *)image center:(CGPoint)center scale:(float)scale;

/**
 高光阴影调整
 
 参数为nil时使用配置的原图片
 默认高光数:1.0
 版本:iOS 5.0
 */
- (UIImage *)stylizeHighlightShadowAdjustWithImage:(UIImage *)image highlightAmount:(float)light shadowAmount:(float)shadow;


//CILineOverlay
//等高线

/**
 像素化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认缩放比例:8.0
 版本:iOS 6.0
 */
- (UIImage *)stylizePixellateWithImage:(UIImage *)image center:(CGPoint)center scale:(float)scale;

/**
 点状化
 
 参数为nil时使用配置的原图片
 默认中心:[150 150]
 默认半径:20.0
 版本:iOS 9.0
 */
- (UIImage *)stylizePointillizeWithImage:(UIImage *)image center:(CGPoint)center radius:(float)radius;

/**
 材质着色
 
 参数为nil时使用配置的原图片
 默认缩放比例:10.0
 版本:iOS 9.0
 */
- (UIImage *)stylizeShadedMaterialWithImage:(UIImage *)image material:(UIImage *)material scale:(float)scale;


//CISpotColor
//点色

//CISpotLight
//聚光灯


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
- (UIImage *)tileEffectEightfoldReflectedWithImage:(UIImage *)image center:(CGPoint)center width:(float)width angle:(float)angle;

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



