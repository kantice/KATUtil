//
//  KATImagePicker.h
//  KATFramework
//
//  Created by Kantice on 15/12/30.
//  Copyright © 2015年 KatApp. All rights reserved.
//  图像拾取器（封装了UIImagePickerController）

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>

#import "KATHashMap.h"


#define PICKER_FLASH_AUTO 0
#define PICKER_FLASH_OFF 1
#define PICKER_FLASH_ON 2


#define PICKER_VIDEO_DEFAULT 0
#define PICKER_VIDEO_HIGH 1
#define PICKER_VIDEO_MEDIUM 2
#define PICKER_VIDEO_LOW 3
#define PICKER_VIDEO_480P 4
#define PICKER_VIDEO_540P 5
#define PICKER_VIDEO_720P 6

#define PICKER_VIDEO_SOUND_ON 0
#define PICKER_VIDEO_SOUND_OFF 1


#pragma -mark 常量

//常量
extern NSString * const kImagePickerTypePictureOriginal;
extern NSString * const kImagePickerTypePictureEdited;
extern NSString * const kImagePickerTypeVideo;


@class KATImagePicker;

//图像拾取器代理
@protocol KATImagePickerDelegate <NSObject>

@optional

///取消选取
- (void)imagePickerDidCancel:(KATImagePicker *)picker;

///完成选取
- (void)imagePicker:(KATImagePicker *)picker didFinishPickingData:(KATHashMap *)data;

///保存图片到相册完成(有完成回调)
- (void)imagePickerDidFinishSaveImageToAlbum:(KATImagePicker *)picker;

///保存视频到相册完成(有完成回调)
- (void)imagePickerDidFinishSaveVideoToAlbum:(KATImagePicker *)picker;

@end




@interface KATImagePicker : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


#pragma -mark 属性

///拾取器
@property(nonatomic,retain) UIImagePickerController *picker;

///事件代理
@property(nonatomic,assign) id<KATImagePickerDelegate> eventDelegate;

///是否保存拍摄的照片
@property(nonatomic,assign) BOOL savePhoto;

///是否保存编辑后的照片
@property(nonatomic,assign) BOOL saveEdited;

///是否保存拍摄的视频
@property(nonatomic,assign) BOOL saveVideo;


#pragma -mark 类方法

///获取实例
+ (instancetype)imagePicker;


#pragma -mark 对象方法

///显示界面
- (void)showWithParentVC:(UIViewController *)parentVC;

///从相册中选取图像
- (void)pickPictureFromAlbumWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable;

///从相册中选取视频
- (void)pickVideoFromAlbumWithParentVC:(UIViewController *)parentVC;

///从相册中选取数据
- (void)pickDataFromAlbumWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable;

///从图库中选取图像
- (void)pickPictureFromLibraryWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable;

///从图库中选取视频
- (void)pickVideoFromLibraryWithParentVC:(UIViewController *)parentVC;

///从图库中选取数据
- (void)pickDataFromLibraryWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable;

///从摄像头中选取图像
- (void)pickPictureFromCameraWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable;

///从摄像头中选取视频
- (void)pickVideoFromCameraWithParentVC:(UIViewController *)parentVC andMaxDuration:(float)duration andQuality:(int)quality andSound:(BOOL)sound;

///设置默认前摄像头
- (void)useFrontCamera;

///设置默认后摄像头
- (void)useRearCamera;

///设置闪光灯模式
- (void)setCameraFlashMode:(int)mode;

///保存图片到相册
- (void)saveToAlbumWithImage:(UIImage *)image;

///保存视频到相册
- (void)saveToAlbumWithVideo:(NSString *)videoPath;


///释放内存
- (void)dealloc;


@end



