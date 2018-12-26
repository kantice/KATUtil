//
//  KATMacros.h
//  KATFramework
//
//  Created by Kantice on 16/3/23.
//  Copyright © 2016年 KatApp. All rights reserved.
//


#import "KATColor.h"
#import "KATTimer.h"
#import "KATAppUtil.h"
#import "KATFileUtil.h"
#import "KATDateUtil.h"


#ifndef KATMacros_h
#define KATMacros_h



//block self
#define BLOCK_SELF __block typeof(self) blockSelf=self;

//weak self
#define WEAK_SELF __weak typeof(self) weakSelf=self;

//weak object
#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak=o;


///时间差
#define TICK KATTimer *timer=[KATTimer timer];\
[timer restart];

#define TOCK [timer stop];\
NSLog(@"------------ duration:%@",[timer difTimes]);\
[timer restart];



///打印格式化输出
#define KATLog(format,...) {\
fprintf(stderr,"-------------------------------------------------------------\n");\
fprintf(stderr,"%s (%s:%d)(t:%s)\n%s\n",\
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
        __func__,__LINE__,[[[NSThread currentThread] description] UTF8String],[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]);\
fprintf(stderr,"-------------------------------------------------------------\n");\
}



///写入日志文件
#define FLog(format,...) \
[KATFileUtil writeToFile:[NSString stringWithFormat:@"%@/%@_%@_%@_%@_log.txt",[KATSystemInfo systemInfo].tmpPath,[KATSystemInfo systemInfo].phoneName,[KATSystemInfo systemInfo].phoneModel,[KATSystemInfo systemInfo].osVersion,[KATSystemInfo systemInfo].appVersion] withData:[[NSString stringWithFormat:@"\n[TIME]:%@\n[FILE]:%s (Line:%d)\n[FUNC]:%s (%s)\n[INFO]:%@\n",[KATDateUtil formatDateTimeString:[KATDateUtil now]],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__,__func__,[[[NSThread currentThread] description] UTF8String],[NSString stringWithFormat:(format),##__VA_ARGS__]] dataUsingEncoding:NSUTF8StringEncoding] append:YES]



///屏幕尺寸
#define SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_MIN MIN(SCREEN_WIDTH,SCREEN_HEIGHT)
#define SCREEN_MAX MAX(SCREEN_WIDTH,SCREEN_HEIGHT)
#define SCREEN_SCALE ([UIScreen mainScreen].scale)
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define SCREEN_MARGIN_BOTTOM ((DEVICE_IPHONE_X || DEVICE_IPHONE_X_MAX)?34.0:0.0)
#define ORIENTATION_LANDSCAPE ([KATAppUtil currentOrientation]==UIDeviceOrientationLandscapeLeft || [KATAppUtil currentOrientation]==UIDeviceOrientationLandscapeRight)
#define ORIENTATION_PORTRAIT ([KATAppUtil currentOrientation]==UIInterfaceOrientationPortrait || [KATAppUtil currentOrientation]==UIInterfaceOrientationPortraitUpsideDown)


//转化成像素格式
#define PIXEL(value) (((int)((value+0.5/SCREEN_SCALE)*SCREEN_SCALE))*1.0/SCREEN_SCALE)

//标注转换
#define FIT(value) ((MIN(SCREEN_MIN, 480.0))/375.0*(value))

//标注转换并修复像素
#define FIX(value) PIXEL(FIT(value))


///样式

//线宽
#define LINE_BOLD (1.5)
#define LINE_NORMAL (1.0)
#define LINE_SLIM (1.0/SCREEN_SCALE)


//按钮缩放
#define BUTTON_SCALE_XXL (1.0)
#define BUTTON_SCALE_XL (0.88)
#define BUTTON_SCALE_L (0.75)
#define BUTTON_SCALE (0.62)
#define BUTTON_SCALE_S (0.48)
#define BUTTON_SCALE_XS (0.36)
#define BUTTON_SCALE_XXS (0.24)

//按钮尺寸
#define BUTTON_SIZE_XXXL (FIT(80.0))
#define BUTTON_SIZE_XXL (FIT(64.0))
#define BUTTON_SIZE_XL (FIT(56.0))
#define BUTTON_SIZE_L (FIT(48.0))
#define BUTTON_SIZE (FIT(40.0))
#define BUTTON_SIZE_S (FIT(32.0))
#define BUTTON_SIZE_XS (FIT(24.0))
#define BUTTON_SIZE_XXS (FIT(16.0))
#define BUTTON_SIZE_XXXS (FIT(12.0))

//按钮线宽
#define BUTTON_LINE_XXB (6.0)
#define BUTTON_LINE_XB (4.0)
#define BUTTON_LINE_B (3.0)
#define BUTTON_LINE (2.0)
#define BUTTON_LINE_F (1.5)
#define BUTTON_LINE_XF (1.0)
#define BUTTON_LINE_XXF (0.5)

//圆角
#define CORNER_RADIUS_XXL (12.0)
#define CORNER_RADIUS_XL (10.0)
#define CORNER_RADIUS_L (8.0)
#define CORNER_RADIUS (6.0)
#define CORNER_RADIUS_S (4.0)
#define CORNER_RADIUS_XS (3.0)
#define CORNER_RADIUS_XXS (2.0)

#define CORNER_RADIUS_RATE_XXL (0.28)
#define CORNER_RADIUS_RATE_XL (0.24)
#define CORNER_RADIUS_RATE_L (0.2)
#define CORNER_RADIUS_RATE (0.16)
#define CORNER_RADIUS_RATE_S (0.12)
#define CORNER_RADIUS_RATE_XS (0.08)
#define CORNER_RADIUS_RATE_XXS (0.05)

///字体
#define FONT_B_XXXL [UIFont boldSystemFontOfSize:FIT(28.0)]
#define FONT_B_XXL [UIFont boldSystemFontOfSize:FIT(24.0)]
#define FONT_B_XL [UIFont boldSystemFontOfSize:FIT(21.0)]
#define FONT_B_L [UIFont boldSystemFontOfSize:FIT(19.0)]
#define FONT_B_N [UIFont boldSystemFontOfSize:FIT(17.0)]
#define FONT_B_S [UIFont boldSystemFontOfSize:FIT(15.0)]
#define FONT_B_XS [UIFont boldSystemFontOfSize:FIT(13.0)]
#define FONT_B_XXS [UIFont boldSystemFontOfSize:FIT(11.0)]
#define FONT_B_XXXS [UIFont boldSystemFontOfSize:FIT(9.0)]

#define FONT_XXXL [UIFont systemFontOfSize:FIT(27.0)]
#define FONT_XXL [UIFont systemFontOfSize:FIT(23.0)]
#define FONT_XL [UIFont systemFontOfSize:FIT(20.0)]
#define FONT_L [UIFont systemFontOfSize:FIT(18.0)]
#define FONT_N [UIFont systemFontOfSize:FIT(16.0)]
#define FONT_S [UIFont systemFontOfSize:FIT(14.0)]
#define FONT_XS [UIFont systemFontOfSize:FIT(12.0)]
#define FONT_XXS [UIFont systemFontOfSize:FIT(10.0)]
#define FONT_XXXS [UIFont systemFontOfSize:FIT(8.0)]

#define FONT_TITLE_1_XXL [UIFont systemFontOfSize:34.0]
#define FONT_TITLE_1_XL [UIFont systemFontOfSize:32.0]
#define FONT_TITLE_1_L [UIFont systemFontOfSize:30.0]
#define FONT_TITLE_1 [UIFont systemFontOfSize:28.0]
#define FONT_TITLE_1_S [UIFont systemFontOfSize:27.0]
#define FONT_TITLE_1_XS [UIFont systemFontOfSize:26.0]
#define FONT_TITLE_1_XXS [UIFont systemFontOfSize:25.0]

#define FONT_TITLE_2_XXL [UIFont systemFontOfSize:28.0]
#define FONT_TITLE_2_XL [UIFont systemFontOfSize:26.0]
#define FONT_TITLE_2_L [UIFont systemFontOfSize:24.0]
#define FONT_TITLE_2 [UIFont systemFontOfSize:22.0]
#define FONT_TITLE_2_S [UIFont systemFontOfSize:21.0]
#define FONT_TITLE_2_XS [UIFont systemFontOfSize:20.0]
#define FONT_TITLE_2_XXS [UIFont systemFontOfSize:19.0]

#define FONT_TITLE_3_XXL [UIFont systemFontOfSize:26.0]
#define FONT_TITLE_3_XL [UIFont systemFontOfSize:24.0]
#define FONT_TITLE_3_L [UIFont systemFontOfSize:22.0]
#define FONT_TITLE_3 [UIFont systemFontOfSize:20.0]
#define FONT_TITLE_3_S [UIFont systemFontOfSize:19.0]
#define FONT_TITLE_3_XS [UIFont systemFontOfSize:18.0]
#define FONT_TITLE_3_XXS [UIFont systemFontOfSize:17.0]

#define FONT_HEADLINE_XXL [UIFont boldSystemFontOfSize:23.0]
#define FONT_HEADLINE_XL [UIFont boldSystemFontOfSize:21.0]
#define FONT_HEADLINE_L [UIFont boldSystemFontOfSize:19.0]
#define FONT_HEADLINE [UIFont boldSystemFontOfSize:17.0]
#define FONT_HEADLINE_S [UIFont boldSystemFontOfSize:16.0]
#define FONT_HEADLINE_XS [UIFont boldSystemFontOfSize:15.0]
#define FONT_HEADLINE_XXS [UIFont boldSystemFontOfSize:14.0]

#define FONT_BODY_XXL [UIFont systemFontOfSize:23.0]
#define FONT_BODY_XL [UIFont systemFontOfSize:21.0]
#define FONT_BODY_L [UIFont systemFontOfSize:19.0]
#define FONT_BODY [UIFont systemFontOfSize:17.0]
#define FONT_BODY_S [UIFont systemFontOfSize:16.0]
#define FONT_BODY_XS [UIFont systemFontOfSize:15.0]
#define FONT_BODY_XXS [UIFont systemFontOfSize:14.0]

#define FONT_CALLOUT_XXL [UIFont systemFontOfSize:22.0]
#define FONT_CALLOUT_XL [UIFont systemFontOfSize:20.0]
#define FONT_CALLOUT_L [UIFont systemFontOfSize:18.0]
#define FONT_CALLOUT [UIFont systemFontOfSize:16.0]
#define FONT_CALLOUT_S [UIFont systemFontOfSize:15.0]
#define FONT_CALLOUT_XS [UIFont systemFontOfSize:14.0]
#define FONT_CALLOUT_XXS [UIFont systemFontOfSize:13.0]

#define FONT_SUBHEAD_XXL [UIFont systemFontOfSize:21.0)]
#define FONT_SUBHEAD_XL [UIFont systemFontOfSize:19.0)]
#define FONT_SUBHEAD_L [UIFont systemFontOfSize:17.0)]
#define FONT_SUBHEAD [UIFont systemFontOfSize:15.0]
#define FONT_SUBHEAD_S [UIFont systemFontOfSize:14.0]
#define FONT_SUBHEAD_XS [UIFont systemFontOfSize:13.0]
#define FONT_SUBHEAD_XXS [UIFont systemFontOfSize:12.0]

#define FONT_FOOTNOTE_XXL [UIFont systemFontOfSize:19.0]
#define FONT_FOOTNOTE_XL [UIFont systemFontOfSize:17.0]
#define FONT_FOOTNOTE_L [UIFont systemFontOfSize:15.0]
#define FONT_FOOTNOTE [UIFont systemFontOfSize:13.0]
#define FONT_FOOTNOTE_S [UIFont systemFontOfSize:12.0]
#define FONT_FOOTNOTE_XS [UIFont systemFontOfSize:12.0]
#define FONT_FOOTNOTE_XXS [UIFont systemFontOfSize:12.0]

#define FONT_CAPTION_1_XXL [UIFont systemFontOfSize:18.0]
#define FONT_CAPTION_1_XL [UIFont systemFontOfSize:16.0]
#define FONT_CAPTION_1_L [UIFont systemFontOfSize:14.0]
#define FONT_CAPTION_1 [UIFont systemFontOfSize:12.0]
#define FONT_CAPTION_1_S [UIFont systemFontOfSize:11.0]
#define FONT_CAPTION_1_XS [UIFont systemFontOfSize:11.0]
#define FONT_CAPTION_1_XXS [UIFont systemFontOfSize:11.0]

#define FONT_CAPTION_2_XXL [UIFont systemFontOfSize:17.0]
#define FONT_CAPTION_2_XL [UIFont systemFontOfSize:15.0]
#define FONT_CAPTION_2_L [UIFont systemFontOfSize:13.0]
#define FONT_CAPTION_2 [UIFont systemFontOfSize:11.0]
#define FONT_CAPTION_2_S [UIFont systemFontOfSize:11.0]
#define FONT_CAPTION_2_XS [UIFont systemFontOfSize:11.0]
#define FONT_CAPTION_2_XXS [UIFont systemFontOfSize:11.0]




///颜色
#define KCOLOR_CLEAR [UIColor clearColor]
#define KCOLOR_WHITE [KATColor colorWithHSBA:COLOR_WHITE]
#define KCOLOR_LIGHT [KATColor colorWithHSBA:COLOR_LIGHT]
#define KCOLOR_GRAY [KATColor colorWithHSBA:COLOR_GRAY]
#define KCOLOR_DARK [KATColor colorWithHSBA:COLOR_DARK]
#define KCOLOR_NIGHT [KATColor colorWithHSBA:COLOR_NIGHT]
#define KCOLOR_BLACK [KATColor colorWithHSBA:COLOR_BLACK]

#define KCOLOR_RED [KATColor colorWithHSBA:COLOR_RED]
#define KCOLOR_FIRE [KATColor colorWithHSBA:COLOR_FIRE]
#define KCOLOR_CORAL [KATColor colorWithHSBA:COLOR_CORAL]
#define KCOLOR_CHOCOLATE [KATColor colorWithHSBA:COLOR_CHOCOLATE]
#define KCOLOR_ORANGE [KATColor colorWithHSBA:COLOR_ORANGE]
#define KCOLOR_BRONZE [KATColor colorWithHSBA:COLOR_BRONZE]
#define KCOLOR_GOLD [KATColor colorWithHSBA:COLOR_GOLD]
#define KCOLOR_YELLOW [KATColor colorWithHSBA:COLOR_YELLOW]
#define KCOLOR_OLIVE [KATColor colorWithHSBA:COLOR_OLIVE]
#define KCOLOR_CHARTREUSE [KATColor colorWithHSBA:COLOR_CHARTREUSE]
#define KCOLOR_LIME [KATColor colorWithHSBA:COLOR_LIME]
#define KCOLOR_FOREST [KATColor colorWithHSBA:COLOR_FOREST]
#define KCOLOR_GREEN [KATColor colorWithHSBA:COLOR_GREEN]
#define KCOLOR_GRASS [KATColor colorWithHSBA:COLOR_GRASS]
#define KCOLOR_SPRING [KATColor colorWithHSBA:COLOR_SPRING]
#define KCOLOR_AQUAMARINE [KATColor colorWithHSBA:COLOR_AQUAMARINE]
#define KCOLOR_CYAN [KATColor colorWithHSBA:COLOR_CYAN]
#define KCOLOR_SKY [KATColor colorWithHSBA:COLOR_SKY]
#define KCOLOR_LAKE [KATColor colorWithHSBA:COLOR_LAKE]
#define KCOLOR_AZURE [KATColor colorWithHSBA:COLOR_AZURE]
#define KCOLOR_BLUE [KATColor colorWithHSBA:COLOR_BLUE]
#define KCOLOR_ROYAL [KATColor colorWithHSBA:COLOR_ROYAL]
#define KCOLOR_NAVY [KATColor colorWithHSBA:COLOR_NAVY]
#define KCOLOR_DEEP [KATColor colorWithHSBA:COLOR_DEEP]
#define KCOLOR_SEA [KATColor colorWithHSBA:COLOR_SEA]
#define KCOLOR_SLATEBLUE [KATColor colorWithHSBA:COLOR_SLATEBLUE]
#define KCOLOR_VIOLET [KATColor colorWithHSBA:COLOR_VIOLET]
#define KCOLOR_PURPLE [KATColor colorWithHSBA:COLOR_PURPLE]
#define KCOLOR_LILAC [KATColor colorWithHSBA:COLOR_LILAC]
#define KCOLOR_PLUM [KATColor colorWithHSBA:COLOR_PLUM]
#define KCOLOR_ROSE [KATColor colorWithHSBA:COLOR_ROSE]
#define KCOLOR_BLOOD [KATColor colorWithHSBA:COLOR_BLOOD]
#define KCOLOR_CRIMSON [KATColor colorWithHSBA:COLOR_CRIMSON]
#define KCOLOR_PINK [KATColor colorWithHSBA:COLOR_PINK]

#define KCOLOR_LINE [KATColor colorWithHSBA:COLOR_LINE]
#define KCOLOR_BEIGE [KATColor colorWithHSBA:COLOR_BEIGE]
#define KCOLOR_PAPER [KATColor colorWithHSBA:COLOR_PAPER]
#define KCOLOR_BACKGROUND [KATColor colorWithHSBA:COLOR_BACKGROUND]
#define KCOLOR_SMOKE [KATColor colorWithHSBA:COLOR_SMOKE]
#define KCOLOR_DUST [KATColor colorWithHSBA:COLOR_DUST]
#define KCOLOR_SILVER [KATColor colorWithHSBA:COLOR_SILVER]
#define KCOLOR_SNOW [KATColor colorWithHSBA:COLOR_SNOW]
#define KCOLOR_GHOST [KATColor colorWithHSBA:COLOR_GHOST]
#define KCOLOR_SHADOW_EX_LIGHT [KATColor colorWithHSBA:COLOR_SHADOW_EX_LIGHT]
#define KCOLOR_SHADOW_LIGHT [KATColor colorWithHSBA:COLOR_SHADOW_LIGHT]
#define KCOLOR_SHADOW [KATColor colorWithHSBA:COLOR_SHADOW]
#define KCOLOR_SHADOW_DARK [KATColor colorWithHSBA:COLOR_SHADOW_DARK]
#define KCOLOR_SHADOW_EX_DARK [KATColor colorWithHSBA:COLOR_SHADOW_EX_DARK]

#define KCOLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]
#define KCOLOR_HSBA(h,s,b,a) [UIColor colorWithHue:h/255.0 saturation:s/255.0 brightness:b/255.0 alpha:a/255.0]
#define RGBA(rgba) [KATColor colorWithRGBA:rgba]
#define RGB(rgb) [KATColor colorWithRGB:rgb]
#define HSBA(hsba) [KATColor colorWithHSBA:hsba]
#define HSB(hsb) [KATColor colorWithHSBA:hsb*100+99]
#define COLOR(hsba) [KATColor colorWithHSBA:hsba]
#define HSBA_ADJUST(hsba,h,s,b,a) [KATColor HSBAFromOriginalHSBA:hsba withAdjustedH:h S:s B:b A:a]
#define COLOR_ADJUST(hsba,h,s,b,a) [KATColor colorFromOriginalHSBA:hsba withAdjustedH:h S:s B:b A:a]

#define ACOLOR_RED RGB(@"F34235")
#define ACOLOR_PINK RGB(@"E81D62")
#define ACOLOR_DARK RGB(@"363F45")
#define ACOLOR_PURPLE RGB(@"9B26AF")
#define ACOLOR_PURPLE_DEEP RGB(@"6639B6")
#define ACOLOR_INDIGO RGB(@"3E50B4")
#define ACOLOR_BLUE RGB(@"2095F2")
#define ACOLOR_BLUE_LIGHT RGB(@"02A8F3")
#define ACOLOR_CYAN RGB(@"00BBD3")
#define ACOLOR_TEAL RGB(@"009587")
#define ACOLOR_GREEN RGB(@"4BAE4F")
#define ACOLOR_GREEN_LIGHT RGB(@"8AC249")
#define ACOLOR_LIME RGB(@"CCDB38")
#define ACOLOR_YELLOW RGB(@"FEEA3A")
#define ACOLOR_AMBER RGB(@"FEC006")
#define ACOLOR_ORANGE RGB(@"FE9700")
#define ACOLOR_ORANGE_DEEP RGB(@"FE5621")
#define ACOLOR_BROWN RGB(@"785447")
#define ACOLOR_GRAY RGB(@"9D9D9D")
#define ACOLOR_GRAY_BLUE RGB(@"5F7C8A")



///系统
#define SYSTEM_INFO [KATSystemInfo systemInfo]
#define OS_VERSION [KATAppUtil OSVersion]
#define APP_VERSION [KATAppUtil appVersion]
#define DOCUMENTS_PATH [KATAppUtil docPath]
#define APP_PATH [KATAppUtil appPath]
#define LIBRARY_PATH [KATAppUtil libPath]
#define TEMP_PATH [KATAppUtil tempPath]
#define LANGUAGE [KATAppUtil language]
#define LANGUAGE_CH (([KATAppUtil language]==SYSTEM_LANGUAGE_CH)?YES:NO)
#define LANGUAGE_CHT (([KATAppUtil language]==SYSTEM_LANGUAGE_CHT)?YES:NO)
#define LANGUAGE_EN (([KATAppUtil language]==SYSTEM_LANGUAGE_EN)?YES:NO)
#define LANGUAGE_JA (([KATAppUtil language]==SYSTEM_LANGUAGE_JA)?YES:NO)
#define LANGUAGE_OTHER (([KATAppUtil language]==SYSTEM_LANGUAGE_OTHER)?YES:NO)
#define LOCALE [KATSystemInfo systemInfo].locale
#define DEVICE_MODEL [KATSystemInfo systemInfo].deviceModel

#define IS_OS_VERSION_NOT_EARLIER_THAN(version) [KATAppUtil isOSNotEarlierThanVersion:version]
#define IS_APP_VERSION_NOT_EARLIER_THAN(version) [KATAppUtil isAppNotEarlierThanVersion:version]


///设备
#define DEVICE_UNKNOWN ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomUnspecified)
#define DEVICE_PHONE ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
#define DEVICE_PAD ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
#define DEVICE_TV ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomTV)
#define DEVICE_CAR_PLAY ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomCarPlay)

#define DEVICE_IPHONE_4 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=479 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=481)?YES:NO)
#define DEVICE_IPHONE_5 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=567 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=569)?YES:NO)
#define DEVICE_IPHONE_6 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=666 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=668)?YES:NO)
#define DEVICE_IPHONE_6_PLUS ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=735 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=737)?YES:NO)
#define DEVICE_IPHONE_X ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=811 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=813)?YES:NO)
#define DEVICE_IPHONE_X_MAX ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=895 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=897)?YES:NO)
#define DEVICE_IPAD_AIR ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1023 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1025)?YES:NO)
#define DEVICE_IPAD_PRO_105 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1111 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1113)?YES:NO)
#define DEVICE_IPAD_PRO_110 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1193 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1195)?YES:NO)
#define DEVICE_IPAD_PRO_129 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1365 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1367)?YES:NO)

#define IS_SCREEN_HEIGHT_480 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=479 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=481)?YES:NO)
#define IS_SCREEN_HEIGHT_568 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=567 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=569)?YES:NO)
#define IS_SCREEN_HEIGHT_667 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=666 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=668)?YES:NO)
#define IS_SCREEN_HEIGHT_736 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=735 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=737)?YES:NO)
#define IS_SCREEN_HEIGHT_812 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=811 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=813)?YES:NO)
#define IS_SCREEN_HEIGHT_896 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=895 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=897)?YES:NO)
#define IS_SCREEN_HEIGHT_1024 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1023 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1025)?YES:NO)
#define IS_SCREEN_HEIGHT_1112 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1111 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1113)?YES:NO)
#define IS_SCREEN_HEIGHT_1366 ((MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)>=1365 && MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)<=1367)?YES:NO)



///GCD
#define GCD_ASYNC_MAIN(block) dispatch_async(dispatch_get_main_queue(),^block)
#define GCD_ASYNC_GLOBAL(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^block)
#define GCD_SYNC_MAIN(block) dispatch_sync(dispatch_get_main_queue(),^block)
#define GCD_SYNC_GLOBAL(block) dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^block)
#define GCD_AFTER(seconds,queue,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, ^block)
#define GCD_MAIN_AFTER(seconds,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^block)




///BOX

//基础BOX(纵向可滚动,子视图拉伸,横向填满屏幕,作为基容器)(y轴坐标,高度,上下间距,左右间距,内间距)
#define BOX_BASE(positionY,height,topBottomPadding,leftRightPadding,innerPadding) [KATBox verticalBoxWithFrame:CGRectMake(0, positionY, SCREEN_WIDTH, height) paddingEdge:UIEdgeInsetsMake(topBottomPadding, leftRightPadding, topBottomPadding, leftRightPadding) paddingInner:innerPadding]

//横向BOX(横向非滚动,自动布局,子视图拉伸)(高度,上下间距,左右间距,内间距)
#define BOX_H(height,topBottomPadding,leftRightPadding,innerPadding) [KATBox horizontalBoxWithFrame:CGRectMake(0, 0, 0, height) paddingEdge:UIEdgeInsetsMake(topBottomPadding, leftRightPadding, topBottomPadding, leftRightPadding) paddingInner:innerPadding]

//纵向BOX(纵向滚动)(高度,上下间距,左右间距,内间距)
#define BOX_V(height,topBottomPadding,leftRightPadding,innerPadding) [KATBox verticalBoxWithFrame:CGRectMake(0, 0, 0, height) paddingEdge:UIEdgeInsetsMake(topBottomPadding, leftRightPadding, topBottomPadding, leftRightPadding) paddingInner:innerPadding]



///常用结构体
#define RECT(x,y,w,h) CGRectMake(x, y, w, h)
#define SIZE(w,h) CGSizeMake(w, h)
#define POINT(x,y) CGPointMake(x, y)
#define RANGE(o,l) NSMakeRange(o, l)
#define BOUNDS(w,h) CGRectMake(0, 0, w, h)


///数据结构
#define ARRAY(...) [KATArray arrayWithMembers:__VA_ARGS__,nil]
#define JMAP(s) [KATHashMap hashMapWithString:s]
#define MAP(c) [KATHashMap hashMapWithCapacity:c andMaxUsage:70]


///数学



#endif /* KATHeader_h */







