//
//  KATDeviceStateManager.h
//  KATFramework
//
//  Created by Kantice on 16/1/16.
//  Copyright © 2016年 KatApp. All rights reserved.
//  设备状态管理（距离，电池和方向等）

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#define DEVICE_BATTERY_UNKNOWN 0
#define DEVICE_BATTERY_UNPLUGGED 1
#define DEVICE_BATTERY_CHARGING 2
#define DEVICE_BATTERY_FULL 3

#define DEVICE_ORIENTATION_UNKNOWN 0
#define DEVICE_ORIENTATION_PORTRAIT 1
#define DEVICE_ORIENTATION_PORTRAIT_UPSIDE_DOWM 2
#define DEVICE_ORIENTATION_LANDSCAPE_LEFT 3
#define DEVICE_ORIENTATION_LANDSCAPE_RIGHT 4
#define DEVICE_ORIENTATION_FACE_UP 5
#define DEVICE_ORIENTATION_FACE_DOWN 6


@class KATDeviceStateMangaer;

//代理
@protocol KATDeviceStateManagerDelegate <NSObject>

@optional

///是否有物体接近
- (void)proximityChangeState:(BOOL)state;

///电池状态改变
- (void)batteryChangeState:(int)state;

///电池电量改变(0~1.0,-1.0为未知)
- (void)batteryChangeLevel:(double)level;

///设备方向改变
- (void)orientationChangeState:(int)state;

@end



@interface KATDeviceStateManager : NSObject




@property(nonatomic,assign) id<KATDeviceStateManagerDelegate> eventDelegate;//事件代理


#pragma mark - 类方法

///获取实例
+ (instancetype)manager;


#pragma mark - 对象方法

///开启距离感应器监听
- (void)startProximityMonitoring;

///停止距离感应器监听
- (void)stopProximityMonitoring;

///开启电池感应器监听
- (void)startBatteryMonitoring;

///停止电池感应器监听
- (void)stopBatteryMonitoring;

///开启方向感应监听
- (void)startOrientationMonitoring;

///停止方向感应监听
- (void)stopOrientationMonitoring;


///释放内存
- (void)dealloc;



@end
