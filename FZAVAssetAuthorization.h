//
//  FZAVAssetAuthorization.h
//  FZAVAsset
//
//  Created by 吴福增 on 2019/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZAVAssetAuthorization : NSObject
#pragma mark -- 验证是否具有媒体权限
+ (BOOL)cameraAuthorized;
+ (BOOL)microPhoneAuthorized;
+ (BOOL)albumAuthorized;

#pragma mark -- 请求媒体权限
+ (void)requestCameraAuth:(void(^)(BOOL granted))authorized;
+ (void)requestMicroPhoneAuth:(void(^)(BOOL granted))authorized;
+ (void)requestAlbumAuth:(void(^)(BOOL granted))authorized;
@end

NS_ASSUME_NONNULL_END
