//
//  FZAVAssetAuthorization.m
//  FZAVAsset
//
//  Created by 吴福增 on 2019/8/16.
//

#import "FZAVAssetAuthorization.h"
#import <Photos/Photos.h>
@implementation FZAVAssetAuthorization
#pragma mark -- 获取系统权限
// 相机权限
+ (BOOL)cameraAuthorized{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // 客户端授权访问硬件支持的媒体类型
        return YES;
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        //没有询问是否开启相机
        return NO;
    } else if(authStatus == AVAuthorizationStatusDenied){
        // 明确拒绝用户访问硬件支持的媒体类型的客户
    } else if(authStatus == AVAuthorizationStatusRestricted){
        //未授权，家长限制
    }
    return NO;
}

//麦克风权限
+ (BOOL)microPhoneAuthorized{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // 客户端授权访问硬件支持的媒体类型
        return YES;
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        //没有询问是否开启相机
    } else if(authStatus == AVAuthorizationStatusDenied){
        // 明确拒绝用户访问硬件支持的媒体类型的客户
    } else if(authStatus == AVAuthorizationStatusRestricted){
        //未授权，家长限制
    }
    return NO;
}

+ (BOOL)albumAuthorized{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        // 客户端授权访问硬件支持的媒体类型
        return YES;
    } else if(photoAuthorStatus == PHAuthorizationStatusNotDetermined){
        //没有询问是否开启相机
    } else if(photoAuthorStatus == PHAuthorizationStatusDenied){
        // 明确拒绝用户访问硬件支持的媒体类型的客户
    } else if(photoAuthorStatus == PHAuthorizationStatusRestricted){
        //未授权，家长限制
    }
    return NO;
}

+ (void)requestCameraAuth:(void (^)(BOOL granted))authorized{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (authorized) {
            authorized(granted);
        }
    }];
}

+ (void)requestMicroPhoneAuth:(void (^)(BOOL granted))authorized{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (authorized) {
            authorized(granted);
        }
    }];
}

+ (void)requestAlbumAuth:(void (^)(BOOL))authorized{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
            if (authorized) {
                authorized(NO);
            }
        }else{
            if (authorized) {
                authorized(YES);
            }
        }
    }];
}

@end
