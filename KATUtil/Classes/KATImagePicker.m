//
//  KATImagePicker.m
//  KATFramework
//
//  Created by Kantice on 15/12/30.
//  Copyright © 2015年 KatApp. All rights reserved.
//

#import "KATImagePicker.h"
#import "KATImageUtil.h"


NSString * const kImagePickerTypePictureOriginal=@"picture_original";
NSString * const kImagePickerTypePictureEdited=@"picture_edited";
NSString * const kImagePickerTypeVideo=@"video";



@implementation KATImagePicker


//构造函数
+ (instancetype)imagePicker
{
    return [[[self alloc] init] autorelease];
}


//初始化
- (instancetype)init
{
    self=[super init];
    
    self.picker=[[[UIImagePickerController alloc] init] autorelease];
    self.picker.delegate=self;
    self.savePhoto=NO;
    self.saveVideo=NO;
    self.saveEdited=NO;
    
    return self;
}


//显示界面
- (void)showWithParentVC:(UIViewController *)parentVC
{
    if(parentVC)
    {
        [parentVC presentViewController:_picker animated:YES completion:nil];
    }
}



//从相册中选取图像
- (void)pickPictureFromAlbumWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        _picker.mediaTypes=@[(NSString *)kUTTypeImage];
        
        _picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _picker.allowsEditing=editable;
        
        [self showWithParentVC:parentVC];
    }
}


//从相册中选取视频
- (void)pickVideoFromAlbumWithParentVC:(UIViewController *)parentVC
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        _picker.mediaTypes=@[(NSString *)kUTTypeVideo,(NSString *)kUTTypeMovie];
        
        _picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self showWithParentVC:parentVC];
    }
}


//从相册中选取数据
- (void)pickDataFromAlbumWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        _picker.mediaTypes=@[(NSString *)kUTTypeImage,(NSString *)kUTTypeVideo,(NSString *)kUTTypeMovie];
        
        _picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _picker.allowsEditing=editable;
        
        [self showWithParentVC:parentVC];
    }
}


//从图库中选取图像
- (void)pickPictureFromLibraryWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.allowsEditing=editable;
        
        [self showWithParentVC:parentVC];
    }
}



//从图库中选取视频
- (void)pickVideoFromLibraryWithParentVC:(UIViewController *)parentVC
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _picker.mediaTypes=@[(NSString *)kUTTypeVideo,(NSString *)kUTTypeMovie];
        
        _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self showWithParentVC:parentVC];
    }
}



//从图库中选取数据
- (void)pickDataFromLibraryWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _picker.mediaTypes=@[(NSString *)kUTTypeImage,(NSString *)kUTTypeVideo,(NSString *)kUTTypeMovie];
        
        _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.allowsEditing=editable;
        
        [self showWithParentVC:parentVC];
    }
}


//从摄像头中选取图像
- (void)pickPictureFromCameraWithParentVC:(UIViewController *)parentVC andEditable:(BOOL)editable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        _picker.allowsEditing=editable;
        
        [self showWithParentVC:parentVC];
    }
}


//从摄像头中选取视频
- (void)pickVideoFromCameraWithParentVC:(UIViewController *)parentVC andMaxDuration:(float)duration andQuality:(int)quality andSound:(BOOL)sound
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        _picker.videoMaximumDuration=duration;//最大时长
        
        //画质
        if(quality==PICKER_VIDEO_HIGH)
        {
            _picker.videoQuality=UIImagePickerControllerQualityTypeHigh;
        }
        else if(quality==PICKER_VIDEO_MEDIUM)
        {
            _picker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        }
        else if(quality==PICKER_VIDEO_LOW)
        {
            _picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        }
        else if(quality==PICKER_VIDEO_480P)
        {
            _picker.videoQuality=UIImagePickerControllerQualityType640x480;
        }
        else if(quality==PICKER_VIDEO_540P)
        {
            _picker.videoQuality=UIImagePickerControllerQualityTypeIFrame960x540;
        }
        else if(quality==PICKER_VIDEO_720P)
        {
            _picker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        }
        else
        {
            _picker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        }
        
        
        //是否录制声音
        if(sound)
        {
            _picker.mediaTypes=@[(NSString *)kUTTypeMovie];
        }
        else
        {
            _picker.mediaTypes=@[(NSString *)kUTTypeVideo];
        }
        
        _picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//必须在mediaType设置完之后设置
        
        [self showWithParentVC:parentVC];
    }
}


//设置默认前摄像头
- (void)useFrontCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    }
}


//设置默认后摄像头
- (void)useRearCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    }
}


//设置闪光灯模式
- (void)setCameraFlashMode:(int)mode
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        if(mode==PICKER_FLASH_OFF)
        {
            _picker.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
        }
        else if(mode==PICKER_FLASH_ON)
        {
            _picker.cameraFlashMode=UIImagePickerControllerCameraFlashModeOn;
        }
        else
        {
            _picker.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        }
    }
}



//保存图片到相册
- (void)saveToAlbumWithImage:(UIImage *)image
{
    if(image)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImageToAlbumFinished), nil);//保存到相簿
    }
}


//保存视频到相册
- (void)saveToAlbumWithVideo:(NSString *)videoPath
{
    if(videoPath && UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath))//判断是否为所拍摄的视频
    {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(saveVideoToAlbumFinished), nil);//保存视频到相簿
    }    
}


//保存图片到相册完成
- (void)saveImageToAlbumFinished
{
    //回调
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(imagePickerDidFinishSaveImageToAlbum:)])
    {
        [_eventDelegate imagePickerDidFinishSaveImageToAlbum:self];
    }
}


//保存图片到相册完成
- (void)saveVideoToAlbumFinished
{
    //回调
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(imagePickerDidFinishSaveVideoToAlbum:)])
    {
        [_eventDelegate imagePickerDidFinishSaveVideoToAlbum:self];
    }
}



#pragma -mark 回调函数

//取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //回调
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(imagePickerDidCancel:)])
    {
        [_eventDelegate imagePickerDidCancel:self];
    }
    
    [_picker dismissViewControllerAnimated:YES completion:nil];//退出界面
}


//选择完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //选取的数据
    KATHashMap *data=[KATHashMap hashMapWithCapacity:20 andMaxUsage:70];
    
    //获取的数据类型
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])//图片类型
    {
        UIImage *oImage=[info objectForKey:UIImagePickerControllerOriginalImage];//原图
        
        //原图可能有旋转问题，需要修复
        oImage=[KATImageUtil fixOrientationWithImage:oImage];
        
        [data putWithKey:kImagePickerTypePictureOriginal andValue:oImage];
        
        if(_savePhoto && _picker.sourceType==UIImagePickerControllerSourceTypeCamera)//判断是否为所拍摄的照片
        {
            UIImageWriteToSavedPhotosAlbum(oImage, nil, nil, nil);//保存到相簿
        }
        
        if(_picker.allowsEditing)//允许编辑
        {
            UIImage *eImage=[info objectForKey:UIImagePickerControllerEditedImage];//编辑图
            
            [data putWithKey:kImagePickerTypePictureEdited andValue:eImage];
            
            if(_saveEdited)//保存编辑图
            {
                UIImageWriteToSavedPhotosAlbum(oImage, nil, nil, nil);//保存到相簿
            }
        }
        
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie] || [mediaType isEqualToString:(NSString *)kUTTypeVideo])//视频类型
    {
        NSString *videoUrl=[((NSURL *)[info objectForKey:UIImagePickerControllerMediaURL]) path];//视频路径
        
        [data putWithKey:kImagePickerTypeVideo andValue:videoUrl];
        
        if(_saveVideo && _picker.sourceType==UIImagePickerControllerSourceTypeCamera && UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoUrl))//判断是否为所拍摄的视频
        {
            UISaveVideoAtPathToSavedPhotosAlbum(videoUrl, nil, nil, nil);//保存视频到相簿
        }
    }
    
    
    //回调
    if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(imagePicker:didFinishPickingData:)])
    {
        [_eventDelegate imagePicker:self didFinishPickingData:data];
    }
    
    [_picker dismissViewControllerAnimated:YES completion:nil];//退出界面
}







- (void)dealloc
{
    [_picker release];
    
    [super dealloc];
}

@end
