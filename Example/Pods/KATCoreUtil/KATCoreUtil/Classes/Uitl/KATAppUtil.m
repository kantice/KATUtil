//
//  KATAppUtil.m
//  KATFramework
//
//  Created by Kantice on 16/4/5.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATAppUtil.h"
#import <StoreKit/StoreKit.h>
#import "KATMacros.h"
#import "KATCodeUtil.h"

#import <AdSupport/AdSupport.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <mach/mach.h>
#import <mach/task_info.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation KATAppUtil



//发短信
+ (void)messageTo:(NSString *)number
{
    NSString *url=[NSString stringWithFormat:@"sms://%@",number];
    
    [self openURL:url];
}


//打电话
+ (void)dialTo:(NSString *)number
{
    NSString *url=[NSString stringWithFormat:@"telprompt://%@",number];
    
    [self openURL:url];
}


//发送邮件
+ (void)mailTo:(NSString *)address
{
    NSString *url=[NSString stringWithFormat:@"mailto://%@",address];
    
    [self openURL:url];
}


//打开URL(网页或地图)
+ (void)browseURL:(NSString *)URL
{
    URL=[URL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    URL=[NSString stringWithFormat:@"http://%@",URL];
    
    [self openURL:URL];
}


//打开应用商店
+ (void)viewApp:(NSString *)appID
{    
    NSString *url=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",appID];
    
    [self openURL:url];
}


//打开应用评分
+ (void)rateApp:(NSString *)appID
{
    if(@available(iOS 10.3, *))
    {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)])
        {
            [SKStoreReviewController requestReview];
        }
        else
        {
            NSString *url=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",appID];
            
            [self openURL:url];
        }
    }
    else
    {
        NSString *url=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",appID];
        
        [self openURL:url];
    }
}


//设置app
+ (void)goToAppSetting
{
    NSString *url=UIApplicationOpenSettingsURLString;
    
    [self openURL:url];
}


//打开app
+ (void)openApp:(NSString *)app withMessage:(NSString *)msg
{
    NSString *url=[NSString stringWithFormat:@"%@://%@",app,msg];
    
    [self openURL:url];
}


//打开URL
+ (void)openURL:(NSString *)URL
{
    //注意url中包含协议名称，iOS根据协议确定调用哪个应用，例如发送邮件是“sms://”其中“//”可以省略写成“sms:”(其他协议也是如此)
    NSURL *url=[NSURL URLWithString:URL];
    
    //    UIApplication *application=[UIApplication sharedApplication];
    //
    //    if(![application canOpenURL:url])//白名单才能返回YES
    //    {
    //        NSLog(@"can not open url:%@",url);
    //
    //        return;
    //    }
    //    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}


//获取主窗口
+ (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}



//获取根视图
+ (UIView *)rootViewFromView:(UIView *)view
{
    if(view)
    {
        UIView *rootView=view;
        
        while(rootView.superview)
        {
            if([rootView.superview isKindOfClass:[UIWindow class]])
            {
                break;
            }
            
            rootView=rootView.superview;
        }
        
        return rootView;
    }
    else
    {
        return [self keyWindow];
    }
}


//获取当前的视图控制器
+ (UIViewController *)currentViewController
{
    UIViewController *currentVC=nil;
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    
    if(window.windowLevel!=UIWindowLevelNormal)
    {
        NSArray *windows=[[UIApplication sharedApplication] windows];
        
        for(UIWindow * tmpWin in windows)
        {
            if(tmpWin.windowLevel==UIWindowLevelNormal)
            {
                window=tmpWin;
                
                break;
            }
        }
    }
    
    
    UIView *frontView=[[window subviews] objectAtIndex:0];
    
    id nextResponder=[frontView nextResponder];
    
    if([nextResponder isKindOfClass:[UIViewController class]])
    {
        currentVC=nextResponder;
    }
    else
    {
        currentVC=window.rootViewController;
    }
    
    
    return currentVC;
}


//获取顶层的视图控制器
+ (UIViewController *)topViewController
{
    UIViewController *topVC=nil;

    topVC=[self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    while(topVC.presentedViewController)
    {
        topVC=[self _topViewController:topVC.presentedViewController];
    }
    
    return topVC;
}


//获取顶层视图控制器的内部递归方法
+ (UIViewController *)_topViewController:(UIViewController *)vc
{
    if([vc isKindOfClass:[UINavigationController class]])
    {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else
    {
        return vc;
    }
    
    return nil;
}


//获取view所在的视图控制器
+ (UIViewController *)controllerWithView:(UIView *)view
{
    for(UIView* next=[view superview];next;next=next.superview)
    {
        UIResponder* nextResponder=[next nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


//获取View相对于某个控件的frame
+ (CGRect)frameInOther:(UIView *)other fromView:(UIView *)view
{
    return [view.superview convertRect:view.frame toView:other];
}


//获取View相对keyWindow的frame
+ (CGRect)frameInWindowFromView:(UIView *)view
{
    if(view)
    {
        CGRect rect=[view.superview convertRect:view.frame toView:[self keyWindow]];
        
        if(rect.size.width>0 && rect.size.height>0 && fabs(view.frame.size.width-rect.size.width)>0.0001)//被压缩
        {
            double scale=view.frame.size.width/rect.size.width;
            
            return RECT(rect.origin.x*scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
        }
        
        return rect;
    }
    else
    {
        return CGRectZero;
    }
}


//获取View相对于某个控件的center
+ (CGPoint)centerInOther:(UIView *)other fromView:(UIView *)view
{
    return [view.superview convertPoint:view.center toView:other];
}


//获取View相对keyWindow的center
+ (CGPoint)centerInWindowFromView:(UIView *)view
{
    if(view)
    {
        return [view.superview convertPoint:view.center toView:[self keyWindow]];
    }
    else
    {
        return CGPointZero;
    }
}


//获取屏幕尺寸
+ (CGSize)screenSize
{
    return [[UIScreen mainScreen] bounds].size;
}


//获取屏幕缩放比率
+ (float)screenScale
{
    return [UIScreen mainScreen].scale;
}


//获取状态栏尺寸
+ (CGSize)statusBarSize
{
    return [UIApplication sharedApplication].statusBarFrame.size;
}


//设置网络活动指示器
+ (void)setNetworkStateActive:(BOOL)active
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:active];//显示状态栏的网络活动指示器
    });
}


//设置状态栏隐藏
+ (void)setStatusBarHidden:(BOOL)hidden withAnimation:(BOOL)animation
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animation];
}


//设置状态栏亮色
+ (void)setStatusBarLightStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}


//设置状态栏暗色
+ (void)setStatusBarDarkStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


//获取状态栏是否亮色
+ (BOOL)isStatusBarLightStyle
{
    return [[UIApplication sharedApplication] statusBarStyle]==UIStatusBarStyleLightContent;
}


//显示状态栏
+ (void)showStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}


//隐藏状态栏
+ (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}


//获取文档路径
+ (NSString *)docPath
{
    return [NSString stringWithFormat:@"%@/Documents",[KATSystemInfo systemInfo].homePath];
}


//获取app路径
+ (NSString *)appPath
{
    return [KATSystemInfo systemInfo].appPath;
}


//获取库文件路径
+ (NSString *)libPath
{
    return [NSString stringWithFormat:@"%@/Library",[KATSystemInfo systemInfo].homePath];
}


//获取临时文件路径
+ (NSString *)tempPath
{
    return [KATSystemInfo systemInfo].tmpPath;
}


//获取图标
+ (UIImage *)iconImage
{
    UIImage *iconImage=nil;
    
    NSString *iconPath=[[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    if(iconPath)
    {
        iconImage=[UIImage imageNamed:iconPath];
    }
    
    return iconImage;
}


//获取启动图片
+ (UIImage *)launchImage
{
    UIImage *lauchImage=nil;
    NSString *viewOrientation=nil;//方向
    CGSize viewSize=[UIScreen mainScreen].bounds.size;
    
    UIInterfaceOrientation orientation=[[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        viewOrientation=@"Landscape";
    }
    else
    {
        viewOrientation=@"Portrait";
    }
    
    NSArray *imagesDictionary=[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for(NSDictionary *dict in imagesDictionary)
    {
        CGSize imageSize=CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if((CGSizeEqualToSize(imageSize, viewSize) || (imageSize.width==viewSize.height && imageSize.height==viewSize.width)) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            lauchImage=[UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    NSLog(@"=== %@",@(lauchImage.size));
    
    return lauchImage;
}


//获取竖屏方向的启动图片
+ (UIImage *)portraitLaunchImage
{
    UIImage *lauchImage=nil;
    NSString *viewOrientation=@"Portrait";//方向
    CGSize viewSize=[UIScreen mainScreen].bounds.size;
    
    NSArray *imagesDictionary=[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for(NSDictionary *dict in imagesDictionary)
    {
        CGSize imageSize=CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if((CGSizeEqualToSize(imageSize, viewSize) || (imageSize.width==viewSize.height && imageSize.height==viewSize.width)) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            lauchImage=[UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return lauchImage;
}


//获取横屏方向的启动图片
+ (UIImage *)landscapeLaunchImage
{
    UIImage *lauchImage=nil;
    NSString *viewOrientation=@"Landscape";//方向
    CGSize viewSize=[UIScreen mainScreen].bounds.size;
    
    NSArray *imagesDictionary=[[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for(NSDictionary *dict in imagesDictionary)
    {
        CGSize imageSize=CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            lauchImage=[UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return lauchImage;
}


//获取系统版本
+ (NSString *)OSVersion
{
    return [KATSystemInfo systemInfo].osVersion;
}


//获取app版本
+ (NSString *)appVersion
{
    return [KATSystemInfo systemInfo].appVersion;
}


//获取系统语言
+ (int)language
{
    return [KATSystemInfo systemInfo].languageID;
}


//获取info.plist
+ (KATHashMap *)info
{
    return [KATSystemInfo systemInfo].info;
}


//获取Schemes
+ (KATArray<NSString *> *)schemes
{
    return [KATSystemInfo systemInfo].schemes;
}


//修复无法播放声音的问题
+ (void)repairAudioPlayer
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}


//设置应用图标徽标数字
+ (void)setBadgeNumber:(long)badge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
}


//获取当前应用图标徽标数字
+ (long)getBadgeNumber
{
    return [[UIApplication sharedApplication] applicationIconBadgeNumber];
}


//切换屏幕方向
+ (BOOL)setOrientation:(UIInterfaceOrientation)orientation
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector=NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val=orientation;
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
        return YES;
    }
    
    return NO;
}


//获取当前的屏幕方向
+ (UIDeviceOrientation)currentOrientation
{
    return [UIDevice currentDevice].orientation;
}


//设置禁止自动锁屏
+ (void)setAutoLockScreenDisabled:(BOOL)disabled
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:disabled];
}


//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray=preferIPv4?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses=[self _getIPInfo];
    
    __block NSString *address;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address=addresses[key];
         
         if(address)
         {
             *stop=YES;
         }
     }];
    
    return address?address:@"0.0.0.0";
}


//获取所有相关IP信息
+ (NSDictionary *)_getIPInfo
{
    NSMutableDictionary *addresses=[NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        
        for(interface=interfaces; interface; interface=interface->ifa_next)
        {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ )
            {
                continue; // deeply nested code harder to read
            }
            
            const struct sockaddr_in *addr=(const struct sockaddr_in*)interface->ifa_addr;
            
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6))
            {
                NSString *name=[NSString stringWithUTF8String:interface->ifa_name];
                NSString *type=nil;
                
                if(addr->sin_family==AF_INET)
                {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN))
                    {
                        type=IP_ADDR_IPv4;
                    }
                }
                else
                {
                    const struct sockaddr_in6 *addr6=(const struct sockaddr_in6 *)interface->ifa_addr;
                    
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN))
                    {
                        type=IP_ADDR_IPv6;
                    }
                }
                
                if(type)
                {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        
        // Free memory
        freeifaddrs(interfaces);
    }
    
    return [addresses count]?addresses:nil;
}


//获取mak地址(iOS7之后已经获取不到了)
+ (NSString *)getMakAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0]=CTL_NET;
    mib[1]=AF_ROUTE;
    mib[2]=0;
    mib[3]=AF_LINK;
    mib[4]=NET_RT_IFLIST;
    
    if((mib[5]=if_nametoindex("en0"))==0)
    {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0)<0)
    {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if((buf = malloc(len))==NULL)
    {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0)<0)
    {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm=(struct if_msghdr *)buf;
    sdl=(struct sockaddr_dl *)(ifm+1);
    ptr=(unsigned char *)LLADDR(sdl);
    
    NSString *outstring=[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}


//获取MAC地址(目前也无法获取)
+ (NSString *)getMacAddress
{
    char macAddress[18];
    
    if([self _getMACAddressCommandResult:macAddress]==-1)
    {
        return nil;
    }
    
    return [NSString stringWithUTF8String:macAddress];
}


//内部方法，通过命令行获取设备IP地址和MAC地址，思路是ifconfig命令，获取en0的信息，然后筛选出IP和MAC
+ (int)_getMACAddressCommandResult:(char *)result
{
    char buffer[18];
    FILE *pipe=popen("ifconfig en0 | grep ether | cut -d' ' -f 2", "r");
    
    if(!pipe)
    {
        return -1;
    }
    
    while(!feof(pipe))
    {
        if(fgets(buffer, 1024, pipe))
        {
            //strcat(result, buffer);
            strncpy(result, buffer, sizeof(buffer)-1);
            result[sizeof(buffer)-1]='\0';
        }
    }
    
    pclose(pipe);
    
    return 0;
}


//获取剪切板中的字符串
+ (NSString *)stringFromPasteboard
{
    return [UIPasteboard generalPasteboard].string;
}


//设置剪切板中的字符串
+ (void)setStringToPasteboard:(NSString *)string
{
    [[UIPasteboard generalPasteboard] setString:string];
}


//获取剪切板中的图片
+ (UIImage *)imageFromPasteboard
{
    return [UIPasteboard generalPasteboard].image;
}


//设置剪切板中的图片
+ (void)setImageToPasteboard:(UIImage *)image
{
    [[UIPasteboard generalPasteboard] setImage:image];
}


//获取剪切板中的URL
+ (NSURL *)urlFromPasteboard
{
    return [UIPasteboard generalPasteboard].URL;
}


//设置剪切板中的URL
+ (void)setUrlToPasteboard:(NSURL *)url
{
    [[UIPasteboard generalPasteboard] setURL:url];
}


//获取剪切板中的颜色
+ (UIColor *)colorFromPasteboard
{
    return [UIPasteboard generalPasteboard].color;
}


//设置剪切板中的颜色
+ (void)setColorToPasteboard:(UIColor *)color
{
    [[UIPasteboard generalPasteboard] setColor:color];
}


//分享内容(简单模式)
+ (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSURL *)url andCompletion:(void (^)(BOOL))completion
{
    //项目
    KATArray *items=[KATArray array];
    
    [items put:title];
    [items put:image];
    [items put:url];
    
    //排除类型
    KATArray *types=[KATArray array];
    [types put:UIActivityTypeMail];
    [types put:UIActivityTypeAssignToContact];
    [types put:UIActivityTypeCopyToPasteboard];
    [types put:UIActivityTypePrint];
    [types put:UIActivityTypeAssignToContact];
    [types put:UIActivityTypeSaveToCameraRoll];
    [types put:UIActivityTypeAddToReadingList];
    [types put:UIActivityTypePostToFlickr];
    [types put:UIActivityTypePostToVimeo];
    [types put:UIActivityTypeAirDrop];
    [types put:UIActivityTypeOpenInIBooks];
    
    //调用通用方法
    [self shareWithItems:items excludedTypes:types andCompletion:completion];
}


//分享内容(Items只能为UIImage,NSString或NSURL)
+ (void)shareWithItems:(KATArray *)items excludedTypes:(NSArray<UIActivityType> *)types andCompletion:(void (^)(BOOL completed))completion
{
    //项目
    NSMutableArray *activityItems=[NSMutableArray array];
    
    for(id item in items)
    {
        if([item isKindOfClass:[UIImage class]] || [item isKindOfClass:[NSString class]] || [item isKindOfClass:[NSURL class]])//类型判断
        {
            [activityItems addObject:item];
        }
    }
    
    //分享视图控制器
    UIActivityViewController *activityView=[[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil] autorelease];
    
    //排除目标
    NSMutableArray<UIActivityType> *excludedTypes=[NSMutableArray array];
    
    for(UIActivityType type in types)
    {
        [excludedTypes addObject:type];
    }
    
    activityView.excludedActivityTypes=excludedTypes;
    
    //回调
    activityView.completionWithItemsHandler=^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError)
    {
        if(completion)
        {
            completion(completed);
        }
    };
    
    //弹出视图
    if(DEVICE_PAD)//平板
    {
        activityView.popoverPresentationController.sourceView=[self topViewController].view;
    }
    
    [[self topViewController] presentViewController:activityView animated:YES completion:nil];
}


//获取指定类的所有属性名称
+ (KATArray<NSString *> *)propertiesInClass:(Class)cls
{
    if(cls)
    {
        //获取属性列表
        u_int count;
        objc_property_t *properties=class_copyPropertyList(cls, &count);
        
        KATArray<NSString *> *array=[KATArray arrayWithCapacity:count];
        
        for(int i=0;i<count;i++)
        {
            //获取属性
            objc_property_t property=properties[i];
            
            //属性名
            NSString *name=[NSString stringWithUTF8String:property_getName(property)];
            
            [array put:name];
        }
        
        //释放属性列表
        free(properties);
        
        return array;
    }
    
    return nil;
}


//加密保存对象
+ (void)saveObject:(id)object withPassword:(NSString *)password andPath:(NSString *)path
{
    if(object && password && password)
    {
        //对象转json
        NSString *json=[[KATHashMap hashMapWithObject:object] description];
        
        //AES加密
        NSString *content=[KATCodeUtil AESEncrypt2Base64WithContent:json andKey:password];
        
        //保存文件
        [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}


//加载加密保存的对象
+ (id)loadObjectWithPassword:(NSString *)password andPath:(NSString *)path
{
    if(password && path)
    {
        //获取文件内容
        NSString *content=[KATFileUtil stringOfFile:path];
        
        //获取json
        NSString *json=[KATCodeUtil AESDecryptWithBase64Content:content andKey:password];
        
        //转成对象
        return [[KATHashMap hashMapWithString:json] object];
    }
    
    return nil;
}


//内存使用量(Byte)
+ (long long int)usageOfMemory
{
    int64_t memoryUsageInByte=0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count=TASK_VM_INFO_COUNT;
    
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    
    if(kernelReturn == KERN_SUCCESS)
    {
        memoryUsageInByte=(int64_t) vmInfo.phys_footprint;
        
        return memoryUsageInByte;
    }
    else
    {
        return -1;
    }
}


//CPU使用率(精确到0.1%)
+ (float)usageOfCPU
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count=TASK_INFO_MAX;
    kr=task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    
    if(kr!=KERN_SUCCESS)
    {
        return -1;
    }
    
    task_basic_info_t basic_info;
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread=0;//Mach threads
    
    basic_info=(task_basic_info_t)tinfo;
    
    //get threads in the task
    kr=task_threads(mach_task_self(), &thread_list, &thread_count);
    
    if(kr!=KERN_SUCCESS)
    {
        return -1;
    }
    
    if(thread_count>0)
    {
        stat_thread+=thread_count;
    }
    
    long tot_sec=0;
    long tot_usec=0;
    float tot_cpu=0;
    
    int j;
    for(j=0;j<(int)thread_count;j++)
    {
        thread_info_count=THREAD_INFO_MAX;
        kr=thread_info(thread_list[j], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        
        if(kr!=KERN_SUCCESS)
        {
            return -1;
        }
        
        basic_info_th=(thread_basic_info_t)thinfo;
        
        if(!(basic_info_th->flags & TH_FLAGS_IDLE))
        {
            tot_sec=tot_sec+basic_info_th->user_time.seconds+basic_info_th->system_time.seconds;
            tot_usec=tot_usec+basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu=tot_cpu+basic_info_th->cpu_usage/(float)TH_USAGE_SCALE*100.0;
        }
    }
    
    kr=vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    
    return tot_cpu;
}


//判断某个版本号是否不比指定版本早(xx.xx.xx)(大于等于返回YES)
+ (BOOL)isVersionA:(NSString *)versionA notEarlierThanVersionB:(NSString *)versionB
{
    if(versionA && versionB)
    {
        //子版本号分隔
        KATArray<NSString *> *va=[KATArray arrayWithString:versionA andSep:@"."];
        KATArray<NSString *> *vb=[KATArray arrayWithString:versionB andSep:@"."];
        
        for(int i=0;i<va.length;i++)
        {
            if(i<vb.length)//b有子版本号
            {
                long long ia=[va[i] longLongValue];
                long long ib=[vb[i] longLongValue];
                
                if(ia>ib)
                {
                    return YES;
                }
                else if(ia<ib)
                {
                    return NO;
                }
            }
            else//b没有更多子版本号
            {
                return YES;
            }
        }
        
        //比较完成,还未有结果
        if(va.length>=vb.length)
        {
            return YES;
        }
        else//b的子版本号更多
        {
            return NO;
        }
    }
    
    return NO;
}


//判断当前系统版本号是否是否不早于指定的版本号
+ (BOOL)isOSNotEarlierThanVersion:(NSString *)version
{
    return [self isVersionA:[self OSVersion] notEarlierThanVersionB:version];
}


//判断当前app版本号是否不早于指定的版本号
+ (BOOL)isAppNotEarlierThanVersion:(NSString *)version
{
    return [self isVersionA:[self appVersion] notEarlierThanVersionB:version];
}


//隐藏键盘
+ (void)hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


@end




