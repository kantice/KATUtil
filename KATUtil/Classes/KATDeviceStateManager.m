//
//  KATDeviceStateManager.m
//  KATFramework
//
//  Created by Kantice on 16/1/16.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATDeviceStateManager.h"

@implementation KATDeviceStateManager


//获取实例
+ (instancetype)manager
{
    return [[[self alloc] init] autorelease];
}



#pragma -mark 距离传感器

//开启距离感应器监听
- (void)startProximityMonitoring
{
    //开启感应功能
    [UIDevice currentDevice].proximityMonitoringEnabled=YES;
    
    //添加监听感应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}


//停止距离感应器监听
- (void)stopProximityMonitoring
{
    //关闭感应功能
    [UIDevice currentDevice].proximityMonitoringEnabled=NO;
    
    //删除监听感应的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}


//距离改变通知(有物体接近时会关闭屏幕)
- (void)proximityChanged:(NSNotificationCenter *)notification
{
    //回调函数
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(proximityChangeState:)])
    {
        [_eventDelegate proximityChangeState:[UIDevice currentDevice].proximityState];
    }    
}



#pragma -mark 电池传感器

//开启电池感应器监听
- (void)startBatteryMonitoring
{
    //开启感应功能
    [UIDevice currentDevice].batteryMonitoringEnabled=YES;
    
    //添加监听感应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
}


//停止电池感应器监听
- (void)stopBatteryMonitoring
{
    //关闭感应功能
    [UIDevice currentDevice].batteryMonitoringEnabled=NO;
    
    //删除监听感应的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
}


//电池状态改变
- (void)batteryStateChanged:(NSNotificationCenter *)notification
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(batteryChangeState:)])
    {
        int state=DEVICE_BATTERY_UNKNOWN;
        
        if([UIDevice currentDevice].batteryState==UIDeviceBatteryStateUnplugged)
        {
            state=DEVICE_BATTERY_UNPLUGGED;
        }
        else if([UIDevice currentDevice].batteryState==UIDeviceBatteryStateCharging)
        {
            state=DEVICE_BATTERY_CHARGING;
        }
        else if([UIDevice currentDevice].batteryState==UIDeviceBatteryStateFull)
        {
            state=DEVICE_BATTERY_FULL;
        }
        
        [_eventDelegate batteryChangeState:state];
    }
}


//电池电量改变
- (void)batteryLevelChanged:(NSNotificationCenter *)notification
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(batteryChangeLevel:)])
    {
        [_eventDelegate batteryChangeLevel:[UIDevice currentDevice].batteryLevel];
    }
}



#pragma -mark 方向

//开启方向感应监听
- (void)startOrientationMonitoring
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


//停止方向感应监听
- (void)stopOrientationMonitoring
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


//方向改变
- (void)orientationChanged:(NSNotificationCenter *)notification
{
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(orientationChangeState:)])
    {
        int state=DEVICE_ORIENTATION_UNKNOWN;
        
        if([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait)
        {
            state=DEVICE_ORIENTATION_PORTRAIT;
        }
        else if([UIDevice currentDevice].orientation==UIDeviceOrientationPortraitUpsideDown)
        {
            state=DEVICE_ORIENTATION_PORTRAIT_UPSIDE_DOWM;
        }
        else if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft)
        {
            state=DEVICE_ORIENTATION_LANDSCAPE_LEFT;
        }
        else if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight)
        {
            state=DEVICE_ORIENTATION_LANDSCAPE_RIGHT;
        }
        else if([UIDevice currentDevice].orientation==UIDeviceOrientationFaceUp)
        {
            state=DEVICE_ORIENTATION_FACE_UP;
        }
        else if([UIDevice currentDevice].orientation==UIDeviceOrientationFaceDown)
        {
            state=DEVICE_ORIENTATION_FACE_DOWN;
        }

        [_eventDelegate orientationChangeState:state];
    }
}




- (void)dealloc
{
    
    
    [super dealloc];
}



@end
