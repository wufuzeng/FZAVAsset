//
//  FZAVAssetAlbum.h
//  FZAVAsset
//
//  Created by 吴福增 on 2019/8/16.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface FZAVAssetAlbum : NSObject

/** 影集已存在 */
+ (BOOL)isAlbumExist:(NSString *)name;
/** 新建影集 */
+ (BOOL)createAlbum:(NSString *)name;

/**
 * 保存视频到指定相册
 *
 * @param videoUrl videoUrl
 * @param albumName albumName
 * @param block block
 */
+ (void)saveVideo:(NSString *)videoUrl
          toAlbum:(NSString *)albumName
       completion:(void (^)(NSURL* url, NSError* error))block;

@end

NS_ASSUME_NONNULL_END
